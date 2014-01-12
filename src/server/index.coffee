_               = require 'underscore'
EventEmitter    = require('events').EventEmitter
http            = require 'http'
WebSocketServer = require('websocket').server
util            = require 'util'

module.exports = class TidalWaveServer

  constructor: (options = {}) ->

    port = options.port or 8080

    httpServer = http.createServer((request, response) ->

      util.debug (new Date()) + " Received request for " + request.url
      response.writeHead 404
      response.end()
    )

    sockets = []
    httpServer.on 'connection', (socket) ->
      sockets.push socket

    httpServer.listen port, ->

      util.debug (new Date()) + " Server is listening on port: #{port}"

    wsServer = new WebSocketServer(
      httpServer: httpServer
      autoAcceptConnections: false
    )

    @emitter = new EventEmitter

    @on = (str, cb) =>

      @internalEvents = [
        'dispatcher:dispatch'
      ]

      # If an internal event is called
      if _.contains(@internalEvents, str)

        @emitter.on str, cb

      # It's a websocket event
      else

        wsServer.on str, cb

    @shutdown = (cb) ->

      @removeAllUsed()

      wsServer.shutDown()

      _.each sockets, (socket, index) ->
        socket.destroy()

      httpServer.close ->
        cb()

    return @

  originIsAllowed: (origin) ->

    true

  removeAllUsed: ->

    _.each @using, (obj, index) =>

      if typeof obj.destroy is 'function'

        obj.destroy =>

          delete @using[index]

    TidalWaveServer::using = []

  use: (obj) ->

    obj.emitter = @emitter

    @using.push obj

  using: []
