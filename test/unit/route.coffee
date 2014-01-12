Route = require '../../src/router/route'

describe 'Routes - Unit', ->

  it 'should be able to match a route', (done) ->

    route = new Route 'yo', 'foo', 'bar'

    expect(route.test('yo')).to.equal true

    done()

  it 'should be able to match a route with params', (done) ->

    route = new Route 'yo/:id/ma', 'foo', 'bar'

    expect(route.test('yo/1/ma')).to.equal true

    done()
