# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  birth_date  :date             not null
#  color       :string           not null
#  sex         :string(1)        not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#

require 'action_view'

class Cat < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  COLORS = %w(Black White Orange Calico Grey)

  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :cat_rental_requests, dependent: :destroy

  validates_presence_of :name, :birth_date, :sex, :color, :user_id
  validates :color, inclusion: COLORS
  validates :sex, inclusion: %w(M F)

  def age
    time_ago_in_words(birth_date)
  end

end
