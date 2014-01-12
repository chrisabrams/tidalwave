Route = require './route'

module.exports = class TidalWaveRouter

  constructor: (Routes, connection) ->

    @connection = connection

    @

  match: (pattern, target, data) ->

    [controller, action] = target.split('#')

    route = new Route pattern, controller, action, data

    @routes.push route

    return route

  routes: []
