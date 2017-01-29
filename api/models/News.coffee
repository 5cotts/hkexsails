module.exports =

  tablesName: 'news'

  schema: true

  attributes:

    code:
      type: 'string'
      required: true

    name:
      type: 'string'
      required: true

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
