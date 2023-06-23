# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

50.times  do
	User.create({
		name: Faker::Name.name,
		email: Faker::Internet.email,
        password: Faker::Internet.password
	})
end

User.all.each do |user|
	rand(1..5).times do
	  Payment.create({
		user: user,
		holder_name: Faker::Name.name,
		card_number: Faker::Finance.credit_card,
		expiration_date: Faker::Business.credit_card_expiry_date,
		ccv: Faker::Number.number(digits: 3)
	  })
	end
  end
  