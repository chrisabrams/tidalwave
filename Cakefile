{exec} = require "child_process"

REPORTER = "spec"

task "test", "all tests", ->

  exec "NODE_ENV=test
    ./node_modules/.bin/mocha
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --require coffee-script
    --require test/helper.coffee
    --colors
    --growl
    test/functional/**.coffee test/unit/**.coffee
  ", (err, output) ->

    throw err if err
    console.log output

task "single", "all tests", ->

  exec "NODE_ENV=test
    ./node_modules/.bin/mocha
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --require coffee-script
    --require test/helper.coffee
    --colors
    --growl
    test/functional/server.coffee
  ", (err, output) ->

    throw err if err
    console.log output

task "functional", "functional tests", ->

  exec "NODE_ENV=test
    ./node_modules/.bin/mocha
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --require coffee-script
    --require test/helper.coffee
    --colors
    --growl
    test/functional/**.coffee
  ", (err, output) ->

    throw err if err
    console.log output

task "unit", "unit tests", ->

  exec "NODE_ENV=test
    ./node_modules/.bin/mocha
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --require coffee-script
    --require test/helper.coffee
    --colors
    --growl
    test/unit/**.coffee
  ", (err, output) ->

    throw err if err
    console.log output
