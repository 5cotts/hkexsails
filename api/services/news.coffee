Promise = require 'bluebird'
moment = require 'moment'
existed = new Error 'existed'

module.exports =
  get: (dtStart = moment()) ->
    hkex = require('hkex')
      lang: 'ch'
      dtStart: dtStart

    page = ->
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
            return page()
        .catch (err) ->
          if err == existed
            return Promise.resolve()
          Promise.reject err

    page()
