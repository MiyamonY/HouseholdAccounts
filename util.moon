import to_json from require "lapis.util"

print_as_json = (obj) ->
  print "#{to_json(obj)}"

map = (arr, f) ->
  ret = {}
  for i = 1, #arr
    table.insert(ret, f arr[i])
  ret

{:print_as_json, :map}
