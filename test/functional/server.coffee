Client = require 'tidalwave-client'
Router = require 'tidalwave-router'
Server = require '../../src/server/index'

describe 'Server - Functional', ->

  it 'should fire route callback on match', (done) ->

    client = new Client
      port: 8000

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      connection = request.accept 'echo-protocol', request.origin

      router = new Router connection, request
      server.use router

      router.on 'yo', (pkg, conn, req) ->

        expect(pkg).to.be.an 'object'
        expect(conn).to.be.an 'object'
        expect(req).to.be.an 'object'

        server.shutdown ->

          done()

    client.on 'connect', (connection) ->

      router = new Router connection
  
      router.dispatch 'yo', {}

    client.connect()

  it 'should receive a data package', (done) ->

    client = new Client
      port: 8000

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      connection = request.accept 'echo-protocol', request.origin

      router = new Router connection, request
      server.use router

      router.on 'yo', (pkg, conn, req) ->

        expect(pkg).to.be.an 'object'
        expect(pkg.name).to.equal 'Chris'

        server.shutdown ->

          done()

    client.on 'connect', (connection) ->
  
      router = new Router connection
  
      router.dispatch 'yo', {name: 'Chris'}

    client.connect()

  it 'should dispatch', (done) ->

    client = new Client
      port: 8000

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      connection = request.accept 'echo-protocol', request.origin

      router = new Router connection, request
      server.use router

      client.on 'connect', (connection) ->

        router.connection.sendUTF = sinon.spy()

        router.dispatch 'whatup', {}

        expect(router.connection.sendUTF).to.be.called

        server.shutdown ->

          done()

    client.connect()
