# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creating roles for different access
['user','admin'].each do |role|
  if !Role.find_by_title(role).present?
    Role.create(title: role)
  end
end
#creating admin user
if !User.where(email: 'admin@admin.com').first.present?
  u = User.new(email: 'admin@admin.com', password: 'password',password_confirmation: 'password')
  u.skip_confirmation!
  u.save(validate: false)
  u.roles << Role.where(title: 'admin').first
end


# ['s','m','l','f'].each do |title|
#   if !ItemType.find_by_title(title).present?
#     ItemType.create(title: title, base_rate: 4, per_km_rate: 1 )
#   end
# end

# if !Priority.first.present?
#   Priority.create(percentage: 20)
# end