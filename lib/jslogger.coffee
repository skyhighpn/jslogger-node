querystring = require "querystring"
http        = require "http"

class JSLogger
  
  host: "jslogger.com"

  port: 80

  key: null

  track: true

  constructor: (options)->
    @key   = options.key or @key
    @host   = options.host or @host
    @port   = options.port or @port
    @track = if typeof options.track isnt "undefined" then options.track else @track

  log: (data)->
    @logDataByType("log", data)

  event: (data)->
    @logDataByType("event", data)

  logDataByType: (type, data)->
    url = @getUrl(type)
    params = @serialize(data, "dump")
    @sendData(url, params)

  getUrl: (action)->
    "/#{action}"

  serialize: (obj, prefix = "dump")->
    obj          = if typeof obj isnt "string" then JSON.stringify(obj) else obj
    data         = {}
    data.key     = @key
    data[prefix] = obj
    querystring.stringify(data)

  sendData: (url, postData)->
    if @track
      postOptions =
        host: @host
        port: @port
        path: url
        method: "POST"
        headers:
          "Content-Type": "application/x-www-form-urlencoded"
          "Content-Length": postData.length
          "Referer": "app:#{@key}"
      postReq = http.request postOptions, (res)->
        res.setEncoding("utf8")
        res.on "data", (chunk)->          
          console.log("JSLogger response: #{chunk}") if process.env.NODE_ENV isnt "production"
      postReq.on "error", (e)->
        console.log("JSLogger problem with request: #{e.message}")
      postReq.write(postData)
      postReq.end()

module.exports = exports = (options)->
  new JSLogger(options)
