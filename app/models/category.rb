class Category < ApplicationRecord
  has_many :packages
  # Validations
  validates :name, presence: true, uniqueness: true
  validates :base_price, :minimum_cost, :additional_cost_per_gram, :fee_percentage, numericality: { greater_than_or_equal_to: 0 }

end
