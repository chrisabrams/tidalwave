Client = require('websocket').client
Router = require 'tidalwave-router'
Server = require '../../src/server/index'

describe 'Server - Functional', ->

  it 'should be able to set a route', (done) ->

    server = new Server
      port: 8000

    router = new Router
    server.use router

    router.on 'yo', (req, msg, conn) ->

    expect(router.routes).to.have.length 1

    server.shutdown ->

      done()

  it 'should fire route callback on match', (done) ->

    client = new Client
    server = new Server
      port: 8000

    router = new Router
    server.use router

    router.on 'yo', (req, msg, conn) ->

      expect(req).to.be.an 'object'
      expect(msg).to.be.an 'object'
      expect(conn).to.be.an 'object'

      server.shutdown ->

        done()

    client.on 'connect', (connection) ->
  
      connection.sendUTF JSON.stringify({route: 'yo'})

    client.connect 'ws://localhost:8000/', 'echo-protocol'
