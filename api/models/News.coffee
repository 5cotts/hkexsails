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
    # check if typeDetails, type, or title matched ALERT_DETAIL
    match = (values) ->
      r = new RegExp process.env.ALERT_DETAIL
      values.typeDetail?.match(r) or values.type?.match(r) or values.title?.match(r)
    if match values
      return oauth2
        .token process.env.TOKENURL, client, user, scope
        .then (token) ->
          opts = headers:
            Authorization: "Bearer #{token}"
          msg =
            to: process.env.TO
            body: JSON.stringify values
          needle.postAsync process.env.NOTIFYURL, msg, opts
        .then (res) ->
          if res.statusCode != 201
            sails.log.error res.body.toString()
        .then ->
          cb()
        .catch cb
    cb()
