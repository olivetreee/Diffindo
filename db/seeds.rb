
num_users = 11
num_bills = 30
num_splits = 20

# USERS

users = {}
for i in (1..num_users-1)
  username = Faker::Name.name
  email = Faker::Internet.email(username)

  users[i] = User.create!(username: username, email: email, password: "password", activated: true)
end

guest = User.create!(username: "Meryl", email: "meryl@burbankgalaxy.com", password: "password", activated: true)

users[num_users] = guest

# BILLS

TITLES = [
  "Birthday lunch",
  "Electrical bill",
  "Rent",
  "Gas for SD trip",
  "new computer!!",
  "Phone bill",
  "Comcast",
  "PGE",
  "hotel in NY",
  "Plane tkt for Israel",
  "brunch @ Hobee's"
]

bills = {}

for i in (1..num_bills)
  title = TITLES[rand(TITLES.length)]
  amount = Faker::Commerce.price
  cat_id = 1
  author_id = users[rand(11)+1].id
  payer_id = users[rand(11)+1].id
  date = Faker::Date.between(1.year.ago, Date.today)
  split_type = "even"
  splits_attrs = [{user_id: payer_id, amount: amount/2}]

  bills[i] = Bill.create!(title: title, amount: amount, category_id: cat_id, author_id: author_id, payer_id: payer_id, date: date, split_type: split_type, splits_attributes: splits_attrs)
end


# SPLITS

splits = {}

# Generate random splits
for i in (1..num_splits)
  bill_id = bills[rand(30)+1].id
  user_id = users[rand(11)+1].id
  amount = (bills[bill_id].amount)/2

  splits[i] = Split.new(user_id: user_id, bill_id: bill_id, amount: amount)
  # Does the split already exist? If so, regenerate
  until splits[i].save
    bill_id = bills[rand(30)+1].id
    user_id = users[rand(11)+1].id
    splits[i] = Split.new(user_id: user_id, bill_id: bill_id, amount: amount)
  end

end
