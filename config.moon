import config from require "lapis.config"

config {"development"}, ->
  app_name "HouseholdAccounts"

  port 8080

  logging {
    queries: true
    requests: true
  }

  postgres {
    host: "postgres"
    user: "accounts"
    password: "password"
    database: "accounts"
  }
