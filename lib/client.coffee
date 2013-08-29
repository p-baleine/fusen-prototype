
factorial = (x) ->
  return 1 if x is 0
  x * factorial(x - 1)

console.log(factorial 6)