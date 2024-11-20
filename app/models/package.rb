class Package < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :category
  has_many :transactions, dependent: :destroy
  belongs_to :origin_city, class_name: 'City'
  belongs_to :destination_city, class_name: 'City'

  before_create :generate_tracking_number_and_pin


  # Validations
  validates :weight, :cost, :status, presence: true
  validates :payment_method, presence: true, inclusion: { in: %w[Cash Swipe] }
  validates :origin_city_id, presence: true
  validates :destination_city_id, presence: true



  # Enum for status
  enum status: { sent: 0, collected: 1 }
  enum payment_status: { unpaid: 0, paid: 1 }



  def total_cost
  
    return 0 if category.nil? || category.base_price.nil? || category.minimum_cost.nil?
  
    cost = weight * category.base_price
  
    [cost, category.minimum_cost].max
  end
  
  def generate_tracking_number_and_pin
    self.tracking_number = "PKG#{SecureRandom.hex(4).upcase}H#{SecureRandom.hex(4).upcase}"
    self.collection_pin = rand(1000000..9999999).to_s
  end

  def calculate_cost
      calculated_fee = amount * (category.fee_percentage / 100.0)
      self.cost = [calculated_fee, category.minimum_cost].max
  end

end

