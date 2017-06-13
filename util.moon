import to_json from require "lapis.util"

print_as_json = (obj) ->
  print "#{to_json(obj)}"

map = (arr, f) ->
  ret = {}
  for i = 1, #arr
    table.insert(ret, f arr[i])
  ret

iter = (arr, f) ->
  for i = 1, #arr
    f arr[i]

parse_date = (date) ->
  year, month, day = string.match date, "(%d+)-(%d+)-(%d+)"
  {:year, :month, :day}

sum = (arr) ->
  total = 0
  for v in *arr
    total += v
  total

apply = (tbl, f) ->
  ret = {}
  for k, v in pairs tbl
    ret.k = f v
  ret

{:print_as_json, :map, :iter, :parse_date, :apply, :sum}
