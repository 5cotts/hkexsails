Promise = require 'bluebird'
moment = require 'moment'
hkex = require('hkex')
  lang: 'ch'
  dtStart: moment().subtract 4, 'd'

describe 'models', ->

  it 'create record', ->
    existed = new Error 'existed'
    get = ->
      hkex
        .then (data) ->
          result = Promise.mapSeries data.models, (info) ->
            sails.models.news
              .findOne info
              .then (record) ->
                if record?
                  return Promise.reject existed
                sails.models.news
                  .create info
                  .toPromise() 
          Promise.all [data, result]
        .then (processed) ->
          [data, result] = processed
          if data.hasNext
            data.models = []
            hkex = data.$fetch()
            return get()
        .catch (err) ->
          if err == existed
            return Promise.resolve()
          Promise.reject err

    get()

  it 'im connection', ->
    sails.models.news
      .create
        title: '內幕消息'
        releasedAt: new Date()
