_     = require 'underscore'
Route = require './route'
util  = require 'util'

module.exports = class TidalWaveRouter

  constructor: (routes, connection) ->

    @listenForRouteRequest connection

    routes @match

    @

  findMatch: (path) ->

    match = null

    for route in @routes

      if route.test path

        match = route

        break

    return match

  listenForRouteRequest: (connection) ->

    if typeof connection.on is 'function'

      connection.on 'message', (message) =>

        if message.type is 'utf8'

          obj   = JSON.parse message.utf8Data
          route = obj.route
          match = @findMatch(route)

          if route and match
            util.debug "Route matched: #{match.name}"

            @emitter.emit 'dispatcher:dispatch', match

  match: (pattern, target, data) =>

    [controller, action] = target.split('#')

    route = new Route pattern, controller, action, data

    @routes.push route

    return route

  routes: []

  # It's really lame that Javascript classes shares the same prototype array by reference
  destroy: (cb) ->

    TidalWaveRouter::routes = []

    cb()
