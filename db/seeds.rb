# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
include Faker

# Member Types:

# MemberType.create(
#   name: "New",
#   quota_hours: 5,
#   details: "Fake Member Type"
# )

15.times do
    random_first_name = Faker::Name.first_name;
    random_last_name = Faker::Name.last_name;

    Volunteer.create(
        first_name: random_first_name,
        last_name: random_last_name,
        email_address: random_first_name.to_s.downcase.delete(' ') + "." + random_last_name.to_s.downcase.delete(' ') + "@email.com",
        phone: Faker::PhoneNumber.phone_number,
        notes: "This is a fake record for example purposes only.",
        member_type_id: 1
    )
end
