_               = require 'underscore'
events          = require 'events'
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

    @on = (args...) ->
      wsServer.on args...

    @shutdown = (cb) ->

      @removeAllUsed()

      wsServer.shutDown()

      _.each sockets, (socket, index) ->
        socket.destroy()

      httpServer.close ->
        cb()

    return @

    #events.EventEmitter.call @
    #util.inherits @, events.EventEmitter

  originIsAllowed: (origin) ->

    true

  removeAllUsed: ->

    _.each @using, (obj, index) =>
      delete @using[index]

    @using = []

  use: (obj) ->
    @using.push obj

  using: []
