# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Inn.Repo.insert!(%Inn.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Inn.Account

admin = %{
  name: "admin",
  email: "admin@example.com",
  password: "admin",
  is_admin: true,
  is_operator: false
}

operator = %{
  name: "operator",
  email: "operator@example.com",
  password: "operator",
  is_admin: false,
  is_operator: true
}

guest = %{
  name: "guest",
  email: "guest@example.com",
  password: "guest",
  is_admin: false,
  is_operator: false
}

unless Account.get_user_by_email(admin[:email]) do
  Account.create_user!(admin)
end

unless Account.get_user_by_email(operator[:email]) do
  Account.create_user!(operator)
end

unless Account.get_user_by_email(guest[:email]) do
  Account.create_user!(guest)
end
