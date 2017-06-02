import config from require "lapis.config"

config {"development"}, ->
  app_name "HouseholdAccounts"

  port 8080

  logging {
    queries: true
    requests: true
  }

  postgres {
    backend: "pgmoon"
    host: "postgres"
    user: "accounts"
    password: "password"
    database: "accounts"
  }

config {"production"}, ->
  port 80
  num_workers 4
  code_cache "on"

  logging {
    queries: false
    requests: true
  }

  postgres {
    backend: "pgmoon"
    host: "postgres"
    user: "accounts"
    password: "password"
    database: "accounts"
  }
