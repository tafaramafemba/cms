
cities = ["Harare", "Bulawayo", "Mutare", "Gweru", "Kwekwe", "Masvingo", "Chinhoyi", "Zvishavane", "Victoria Falls", "Beitbridge", "Kariba", "Bindura", "Chiredzi", "Rusape"]

cities.each do |city|
  City.find_or_create_by(name: city)
end

City.update(1, collection_point_address: "Hand2hand,  Roadport")
City.update(2, collection_point_address: "Shop no 1 Crownmall, 87c Herbert Chitepo Street, Manica Post Building")

Admin.create!(email: 'teller1@hand2handcourierszw.com', password: 'password', password_confirmation: 'password')
Admin.create!(email: 'teller2@hand2handcourierszw.com', password: 'password', password_confirmation: 'password')
Admin.create!(email: 'teller3@hand2handcourierszw.com', password: 'password', password_confirmation: 'password')
Admin.create!(email: 'teller4@hand2handcourierszw.com', password: 'password', password_confirmation: 'password')
Admin.create!(email: 'teller5@hand2handcourierszw.com', password: 'password', password_confirmation: 'password')
Admin.create!(email: 'teller6@hand2handcourierszw.com', password: 'password', password_confirmation: 'password')

Category.create!(name: 'Letter/Documents', base_price: 3, minimum_cost: 5, additional_cost_per_gram: 0, fee_percentage: 0)
Category.create!(name: 'Parcel', base_price: 3, minimum_cost: 10, additional_cost_per_gram: 0, fee_percentage: 0)
Category.create!(name: 'Cash', base_price: 0, minimum_cost: 5, additional_cost_per_gram: 0, fee_percentage: 5)

