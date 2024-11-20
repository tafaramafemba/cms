class User < ApplicationRecord
  has_many :sent_packages, class_name: 'Package', foreign_key: 'sender_id'
  has_many :received_packages, class_name: 'Package', foreign_key: 'receiver_id'

  # Validations
  validates :name, :id_number, :phone, presence: true
  validates :id_number, uniqueness: true
end
