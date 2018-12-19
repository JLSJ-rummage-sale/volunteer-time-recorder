# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
include Faker

# Events:

Event.create(
  name: "Rummage Sale",
  year: 2018
)

# Categories:

pre_sale_category = Category.create(
  name: "RS Work Week/Pre-Sale"
)

sale_day_category = Category.create(
  name: "RS Sale Day/Post-Sale Hours"
)

# Member Types:

# Member Status : Work Week/Pre-Sale Hours : Sale Day/Post-Sale Hours
### Provisional : 7 : 8

provisional_member = MemberType.create(
  name: "Provisional",
  details: ""
)

provisional_quota_1 = Quota.create(
  name: "Work Week/Pre-Sale Hours",
  hours: 7,
  category_id: pre_sale_category.id,
  member_type_id: provisional_member.id
)

provisional_quota_2 = Quota.create(
  name: "Sale Day/Post-Sale Hours",
  hours: 8,
  category_id: sale_day_category.id,
  member_type_id: provisional_member.id
)

### Active : 7 : 8

active_member = MemberType.create(
  name: "Active",
  details: ""
)

active_quota_1 = Quota.create(
  name: "Work Week/Pre-Sale Hours",
  hours: 7,
  category_id: pre_sale_category.id,
  member_type_id: active_member.id
)

active_quota_2 = Quota.create(
  name: "Sale Day/Post-Sale Hours",
  hours: 8,
  category_id: sale_day_category.id,
  member_type_id: active_member.id
)

### Active Silver : 6 : 7

active_silver_member = MemberType.create(
  name: "Active Silver",
  details: ""
)

active_silver_quota_1 = Quota.create(
  name: "Work Week/Pre-Sale Hours",
  hours: 6,
  category_id: pre_sale_category.id,
  member_type_id: active_silver_member.id
)

active_silver_quota_2 = Quota.create(
  name: "Sale Day/Post-Sale Hours",
  hours: 7,
  category_id: sale_day_category.id,
  member_type_id: active_silver_member.id
)

### Active Gold : 5 : 6

active_gold_member = MemberType.create(
  name: "Active Gold",
  details: ""
)

active_gold_quota_1 = Quota.create(
  name: "Work Week/Pre-Sale Hours",
  hours: 5,
  category_id: pre_sale_category.id,
  member_type_id: active_gold_member.id
)

active_gold_quota_2 = Quota.create(
  name: "Sale Day/Post-Sale Hours",
  hours: 6,
  category_id: sale_day_category.id,
  member_type_id: active_gold_member.id
)

### Active Diamond (either financial or work) : 5 : 6

active_diamond_member = MemberType.create(
  name: "Active Diamond",
  details: ""
)

active_diamond_quota_1 = Quota.create(
  name: "Work Week/Pre-Sale Hours",
  hours: 5,
  category_id: pre_sale_category.id,
  member_type_id: active_diamond_member.id
)

active_diamond_quota_2 = Quota.create(
  name: "Sale Day/Post-Sale Hours",
  hours: 6,
  category_id: sale_day_category.id,
  member_type_id: active_diamond_member.id
)

### Past Presidents : 0 : 0

past_presidents_member = MemberType.create(
  name: "Past President",
  details: ""
)

past_presidents_quota_1 = Quota.create(
  name: "Work Week/Pre-Sale Hours",
  hours: 0,
  category_id: pre_sale_category.id,
  member_type_id: past_presidents_member.id
)

past_presidents_quota_2 = Quota.create(
  name: "Sale Day/Post-Sale Hours",
  hours: 0,
  category_id: sale_day_category.id,
  member_type_id: past_presidents_member.id
)

# Fake Volunteers:

15.times do
    random_first_name = Faker::Name.first_name;
    random_last_name = Faker::Name.last_name;

    Volunteer.create(
        first_name: random_first_name,
        last_name: random_last_name,
        email_address: random_first_name.to_s.downcase.delete(' ') + "." + random_last_name.to_s.downcase.delete(' ') + "@email.com",
        phone: Faker::PhoneNumber.phone_number,
        notes: "This is a fake record for example purposes only.",
        member_type_id: provisional_member.id
    )
end
