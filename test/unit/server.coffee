Client = require('websocket').client
Server = require '../../src/server/index'

describe 'Server - Unit', ->

  it 'should be able to initialize and shut down', (done) ->

    server = new Server
      port: 8000

    expect(server).to.be.an 'object'

    server.shutdown ->

      done()

  it 'should be able to listen for a request', (done) ->

    client = new Client

    server = new Server
      port: 8000

    server.on 'request', (request) ->

      expect(request).to.be.an 'object'

      server.shutdown ->

        done()

    client.connect 'ws://localhost:8000/', 'echo-protocol'

  it 'should be able to accept a connection', (done) ->

    client = new Client

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      
      connection = request.accept 'echo-protocol', request.origin
      
      expect(connection).to.be.an 'object'

      server.shutdown ->

        done()

    client.connect 'ws://localhost:8000/', 'echo-protocol'

  it 'should be able to receive a message', (done) ->

    client = new Client

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      
      connection = request.accept 'echo-protocol', request.origin

      connection.on 'message', (message) ->
        
        expect(message).to.be.an 'object'
        expect(message.type).to.equal 'utf8'
        expect(message.utf8Data).to.equal 'yo'

        server.shutdown ->

          done()

    client.on 'connect', (connection) ->

      connection.sendUTF 'yo'

    client.connect 'ws://localhost:8000/', 'echo-protocol'

  it 'should be able to send a message', (done) ->

    client = new Client

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      
      connection = request.accept 'echo-protocol', request.origin

      connection.sendUTF 'yo'

    client.on 'connect', (connection) ->

      connection.on 'message', (message) ->
        
        expect(message).to.be.an 'object'
        expect(message.type).to.equal 'utf8'
        expect(message.utf8Data).to.equal 'yo'

        server.shutdown ->

          done()

    client.connect 'ws://localhost:8000/', 'echo-protocol'

  it 'should be able to listen for a client close a connection', (done) ->

    client = new Client

    server = new Server
      port: 8000

    server.on 'request', (request) ->
      
      connection = request.accept 'echo-protocol', request.origin

      connection.on 'close', (reasonCode, description) ->

        server.shutdown ->

          done()

      connection.close()

    client.connect 'ws://localhost:8000/', 'echo-protocol'

  it 'should be able to use an object', (done) ->

    server = new Server
      port: 8000

    obj = new Object

    server.use obj

    expect(server.using).to.have.length 1

    server.shutdown ->

      done()

  it 'should be able to remove all used objects', (done) ->

    server = new Server
      port: 8000

    obj = new Object

    server.use obj

    server.removeAllUsed()

    expect(server.using).to.have.length 0

    server.shutdown ->

      done()
