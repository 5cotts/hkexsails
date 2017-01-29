['DB'].map (name) ->
  if not (name of process.env)
    throw new Error "process.env.#{name} not yet defined"

module.exports =
  connections:
    mongo:
      adapter: 'sails-mongo'
      driver: 'mongodb'
      url: process.env.DB
