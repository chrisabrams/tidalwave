chai      = require 'chai'
sinonChai = require 'sinon-chai'

chai.use sinonChai

global.sinon  = require 'sinon'
global.assert = chai.assert
global.expect = chai.expect
