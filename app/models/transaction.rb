class Transaction < ApplicationRecord
  belongs_to :package

  # Validations
  validates :transaction_type, presence: true
end
