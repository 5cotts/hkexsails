oauth2 = require 'oauth2_client'
Promise = require 'bluebird'
needle = Promise.promisifyAll require 'needle'

[
  'TOKENURL'
  'CLIENT_ID'
  'CLIENT_SECRET'
  'USER_ID'
  'USER_SECRET'
  'SCOPE'
  'ALERT_DETAIL'
  'NOTIFYURL'
  'FROM'
  'TO'
].map (name) ->
  if not (name of process.env)
    throw new Error "process.env.#{name} not yet defined"

client =
  id: process.env.CLIENT_ID
  secret: process.env.CLIENT_SECRET
user =
  id: process.env.USER_ID
  secret: process.env.USER_SECRET
scope = process.env.SCOPE.split ' '
detail_alert = process.env.ALERT_DETAIL

module.exports =

  tablesName: 'news'

  schema: true

  attributes:

    code:
      type: 'string'

    name:
      type: 'string'

    type:
      type: 'string'

    typeDetail:
      type: 'string'

    title:
      type: 'string'

    link:
      type: 'string'

    size:
      type: 'string'

    releasedAt:
      type: 'date'

  beforeCreate: (values, cb) ->
    if values.typeDetail?.match process.env.ALERT_DETAIL
      oauth2
        .token process.env.TOKENURL, client, user, scope
        .then (token) ->
          headers =
            Authorization: "Bearer #{token}"
          msg =
            to: process.env.TO
            body: JSON.stringify values
          needle.requestAsync 'post', process.env.NOTIFYURL, msg, headers: headers
        .then (res) ->
          if res.statusCode != 201
            sails.log.error res.body.toString()
    cb()
