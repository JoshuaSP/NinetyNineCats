# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ValidDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record.changed_attributes[attribute] && record.changed_attributes[attribute] < Date.today
      record.errors.add(attribute, 'cannot be changed')
    elsif value < Date.today
      record.errors.add(attribute, 'cannot be set before today')
    end
  end
end

class CatRentalRequest < ActiveRecord::Base

  STATUSES = %w(PENDING APPROVED DENIED)

  belongs_to :cat

  after_initialize :set_default_status

  validates_presence_of :cat_id, :end_date, :start_date, :status
  validates :cat_id, numericality: { greater_than: 0 }
  validates :status, inclusion: STATUSES
  validates :start_date, :end_date, valid_date: true
  validate :start_not_after_end, :no_overlapping_approved_requests

  def approved?
    self.status == 'APPROVED'
  end

  def denied?
    self.status == 'DENIED'
  end

  def pending?
    self.status == 'PENDING'
  end

  def approve!
    self.status = 'APPROVED'
    save!
  end

  def deny!
    self.status = 'DENIED'
    save!
  end

  private

  def set_default_status
    self.status ||= 'PENDING'
  end

  def overlapping_requests
    CatRentalRequest
      .where('(:id IS NULL) OR (id != :id)', id: self.id)
      .where(cat_id: cat_id)
      .where(<<-SQL, start_date: start_date, end_date: end_date)
       NOT( (start_date > :end_date) OR (end_date < :start_date) )
    SQL
  end

  def overlapping_approved_requests
    overlapping_requests.where("status = 'APPROVED'")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = 'APPROVED'")
  end

  def no_overlapping_approved_requests
    return if self.denied?

    unless overlapping_approved_requests.empty?
      errors[:base] <<
        'Request conflicts with existing approved request'
    end
  end

  def start_not_after_end
    if self.start_date > self.end_date
      errors.add(:start_date, "can't be after end date")
      errors.add(:end_date, "can't be before start date")
    end
  end
end
