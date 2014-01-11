_               = require 'underscore'
events          = require 'events'
http            = require 'http'
WebSocketServer = require('websocket').server
util            = require 'util'

module.exports = class TidalWaveServer

  constructor: (options = {}) ->

    port = options.port or 8080

    httpServer = http.createServer((request, response) ->
      #console.log (new Date()) + " Received request for " + request.url
      response.writeHead 404
      response.end()
    )

    httpServer.listen port, ->
      console.log (new Date()) + " Server is listening on port: #{port}"

    wsServer = new WebSocketServer(
      httpServer: httpServer
      autoAcceptConnections: false
    )

    @on = (args...) ->
      wsServer.on args...

    @shutdown = (cb) ->
      wsServer.shutDown()

      to = setTimeout(->
        cb()
        clearTimeout to
      , 1000)

    #events.EventEmitter.call @
    #util.inherits @, events.EventEmitter

  originIsAllowed: (origin) ->

    true
