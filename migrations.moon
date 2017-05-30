import create_table, types from require "lapis.db.schema"

{
  [1]: =>
    create_table "test", {
      {"id", types.serial}

      "PRIMARY KEY (id)"
    }
}
