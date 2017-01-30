oauth2 = require 'oauth2_client'

[
  'TOKENURL'
  'CLIENT_ID'
  'CLIENT_SECRET'
  'USER_ID'
  'USER_SECRET'
  'SCOPE'
  'DETAIL_ALERT'
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
detail_alert = process.env.DETAIL_ALERT

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
    if values.typeDetail.match DETAIL_ALERT
      oauth2
        .token process.env.TOKENURL, client, user, scope
        .then (token) ->
          needle.
