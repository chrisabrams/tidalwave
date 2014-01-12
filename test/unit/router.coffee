Router = require '../../src/router/index'

describe 'Router - Unit', ->

  it.skip 'should be able to initialize', (done) ->

    router = new Router
      connection: {}

    expect(router).to.be.an 'object'
    expect(router.connection).to.be.an 'object'
    expect(router.route).to.be.a 'function'

    done()
