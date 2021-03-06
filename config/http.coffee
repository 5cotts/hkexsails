csp = require 'helmet-csp'

module.exports =
  http:
    middleware:
      csp: (req, res, next) ->
        host = req.headers['x-forwarded-host'] || req.headers['host']
        src = [
          "'self'"
          "http://#{host}"
          "https://#{host}"
        ]
        ret = csp
          directives:
            defaultSrc: src
            styleSrc: ["'unsafe-inline'"].concat src
            scriptSrc: [
                "'unsafe-inline'"
                "'unsafe-eval'"
              ].concat src
        ret req, res, next
      order: [
        'bodyParser'
        'compress'
        'csp'
        'router'
        'www'
        'favicon'
        '404'
        '500'
      ]
