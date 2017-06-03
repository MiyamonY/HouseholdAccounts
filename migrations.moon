import create_table, types from require "lapis.db.schema"
db = require "lapis.db"

{
  [1]: =>
    create_table "accounts", {
      {"id", types.serial}
      {"type", types.integer}
      {"date", types.date}
      {"member_id", types.foreign_key}
      {"kind_id", types.foreign_key}
      {"amount", types.integer}
      {"etc", types.text}
      {"input_date", types.date}

      "PRIMARY KEY (id)"
    }

    create_table "kinds", {
      {"id", types.serial}
      {"kind", types.text}

      "PRIMARY KEY (id)"
    }

    create_table "members", {
      {"id", types.serial}
      {"member", types.text}
      {"color", types.integer}

      "PRIMARY KEY (id)"
    }

    create_table "tags", {
      {"id", types.serial}
      {"name", types.text}
      {"color", types.integer}

      "PRIMARY KEY (id)"
    }

[2]: =>
  db.insert "kinds", {
    kind: "食費"
  }
  db.insert "kinds", {
    kind: "住居費"
  }
  db.insert "kinds", {
    kind: "教養・娯楽費"
  }
  db.insert "kinds", {
    kind: "その他"
  }

  db.insert "members", {
    member: "洋平"
    color: 1
  }
  db.insert "members", {
    member: "あゆみ"
    color: 2
  }
}
