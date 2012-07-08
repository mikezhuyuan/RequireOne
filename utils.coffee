exports.unique = (array) ->
  uni_arr = []
  for item in array when item not in uni_arr
    uni_arr.push item
  return uni_arr