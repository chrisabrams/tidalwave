Client = require('websocket').client
Router = require '../../src/router/index'
Server = require '../../src/server/index'

describe 'Server - Unit', ->

  it.skip 'should be able to route a message', (done) ->

    client = new Client

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      
      connection = request.accept 'echo-protocol', request.origin

      Routes = require '../misc/routes'
      router = new Router Routes, connection
      server.use router

      server.on 'dispatcher:dispatch', (route) ->

        expect(route).to.be.an 'object'
        expect(route.controller).to.be.a 'string'
        expect(route.action).to.be.a 'string'

        server.shutdown ->

          done()

    client.connect 'ws://localhost:8000/', 'echo-protocol'