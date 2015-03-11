require 'action_view'

class Cat < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  COLORS = %w(Black White Orange Calico Grey)

  has_many :cat_rental_requests, dependent: :destroy

  validates_presence_of :name, :birth_date, :sex, :color
  validates :color, inclusion: COLORS
  validates :sex, inclusion: %w(M F)

  def age
    time_ago_in_words(birth_date)
  end

end