class FirstInformationReport < ApplicationRecord
  belongs_to :user
  belongs_to :complainant
  validates :offense, :date, :location, :suspect_details, presence: true, length: { minimum: 5 }

  enum status: %i[pending approved rejected]

  scope :all_active, -> { where(active: TRUE).all }
  scope :result, ->(start_date, end_date) { where('date >= ? and date <= ?', start_date, end_date).all }
end
