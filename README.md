# Inn

Тестовый сервис для проверки ИНН. Работает на вебсокетах фреймфорка [Phoenix](https://hexdocs.pm/phoenix/channels.html#content).

**Все время указано в UTC+0**

Сервис предусматривает авторизацию и две роли: администратор(admin@example.com), оператор (operator@example.com).

Оператор -- имеет доступ к [панеле администратора](https://rocky-atoll-20786.herokuapp.com/admin), может удалять записи.

Администратор -- может все тоже самое, но видит ip адреса и может [забанить](https://rocky-atoll-20786.herokuapp.com/admin/banned) на N-секунд.


Гость -- guest@example.com не имеет ролей.

Ниже приведены значения логин/пароль:
```
admin@example.com
admin

operator@example.com
operator

guest@example.com
guest
```

Для авторизации используется кука `_inn_token`, которая является jwt, сформированная через [Guardian](https://github.com/ueberauth/guardian).

Для реализации бана по ip используется [sorted_sets Redis](https://redis.io/commands#sorted_set) и библиотека [Redix](https://hexdocs.pm/redix/readme.html) к эликсиру

## https://rocky-atoll-20786.herokuapp.com 

Приожение развернуто в облаке на [Heroku](https://www.heroku.com/).


### Ниже официальное ридми к фениксу.

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
