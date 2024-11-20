class City < ApplicationRecord
  has_many :origin_city_packages, class_name: 'Package', foreign_key: 'origin_city_id'
  has_many :destination_city_packages, class_name: 'Package', foreign_key: 'destination_city_id'
end