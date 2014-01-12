# Taken from Backbone.Router.
escapeRegExp   = /[\-{}\[\]+?.,\\\^$|#\s]/g
optionalRegExp = /\((.*?)\)/g
paramRegExp    = /(?::|\*)(\w+)/g

module.exports = class Route

  constructor: (pattern, controller, action, options) ->

    @action     = action
    @controller = controller
    @pattern    = pattern
    @options    = options or {}

    @name = @controller + '#' + @action

    @allParams = []
    @requiredParams = []
    @optionalParams = []

    @createRegExp()

    @

  createRegExp: ->
    pattern = @pattern

    pattern = pattern.replace(escapeRegExp, '\\$&')

    @replaceParams pattern, (match, param) =>
      @allParams.push param

    pattern = pattern.replace optionalRegExp, @parseOptionalPortion

    pattern = @replaceParams pattern, (match, param) =>
      @requiredParams.push param
      @paramCapturePattern match

    @regExp = ///^#{pattern}(?=\/?(\?|$))///

  extractParams: (path) ->
    params = {}

    matches = @regExp.exec path

    for match, index in matches.slice(1)
      paramName = if @allParams.length then @allParams[index] else index
      params[paramName] = match

    params

  handler: ->

    # call dispatcher

  paramCapturePattern: (param) ->
    if param.charAt(0) is ':'

      '([^\/\?]+)'
    else

      '(.*?)'

  replaceParams: (s, callback) =>

    s.replace paramRegExp, callback

  test: (path) ->

    matched = @regExp.test path
    return false unless matched

    true

  testConstraints: (params) ->

    constraints = @options.constraints
    if constraints
      for own name, constraint of constraints
        return false unless constraint.test params[name]

    true

  testParams: (params) ->

    for paramName in @requiredParams
      return false if params[paramName] is undefined

    @testConstraints params
