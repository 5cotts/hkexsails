['VERIFYURL', 'SCOPE'].map (name) ->
  if not (name of process.env)
    throw new Error "process.env.#{name} note yet defined"

module.exports =
  oauth2:
    verifyUrl: process.env.VERIFYURL
    scope: process.env.SCOPE.split(' ')
