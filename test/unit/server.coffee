Server = require '../../src/server/index'

describe 'Server', ->

  it 'should be able to initialize', (done) ->

    server = new Server
      port: 8000

    expect(server).to.be.an 'object'

    server.shutdown ->

      done()

  it 'should be able to accept a connection', (done) ->
    @timeout 10000

    ###
    server = new Server

    server.emit = sinon.spy()

    server.emit('foo')

    expect(server.emit).to.have.been.called
    ###

    server = new Server
      port: 8001

    server.on "request", (request) ->
      
      connection = request.accept("echo-protocol", request.origin)
      
      expect(connection).to.be.an 'object'

      done()
