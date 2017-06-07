map = (arr, f) ->
  ret = {}
  for i = 1, #arr
    table.insert(ret, f arr[i])
  ret

{:map}
