Stubble = require("stubble")

describe "JSLogger", ()->
  request =
    on: jasmine.createSpy("http.request.on").andReturn ()->
    write: jasmine.createSpy("http.request.write").andReturn ()->
    end: jasmine.createSpy("http.request.end").andReturn ()->
  httpModule =
    request: jasmine.createSpy("http.request").andReturn(request)
  stub = new Stubble
    http: httpModule
  
  jslogger = stub.require(__dirname + "/../lib/jslogger")
    key: "SECRET_KEY"

  it "has a host pointing to jslogger.com", ()->
    expect(jslogger.host).toEqual("jslogger.com")

  it "has a port", ()->
    expect(jslogger.port).toEqual(80)

  it "assigns the given secret key", ()->
    expect(jslogger.key).toEqual("SECRET_KEY")

  it "tracks data by default", ()->
    expect(jslogger.track).toEqual(true)

  describe "log", ()->
    it "logs an error", ()->
      spyOn(jslogger, "logDataByType")
      jslogger.log("my_data")
      expect(jslogger.logDataByType).toHaveBeenCalledWith("log", "my_data")

  describe "event", ()->
    it "logs an event", ()->
      spyOn(jslogger, "logDataByType")
      jslogger.event("my_data")
      expect(jslogger.logDataByType).toHaveBeenCalledWith("event", "my_data")

  describe "logDataByType", ()->
    it "sends the data to the url by type", ()->
      spyOn(jslogger, "sendData")
      jslogger.logDataByType("type", "my_data")
      expect(jslogger.sendData).toHaveBeenCalledWith("/type", "key=SECRET_KEY&dump=my_data")

  describe "getUrl", ()->
    it "returns the url by the given action", ()->
      expect(jslogger.getUrl("action")).toEqual("/action")

  describe "serialize", ()->
    it "returns the serialized given data and the API key", ()->
      expect(jslogger.serialize("my_data")).toEqual("key=SECRET_KEY&dump=my_data")

    it "returns the serialized given JSON objects and the API key", ()->
      expect(jslogger.serialize({my: "data"})).toEqual("key=SECRET_KEY&dump=%7B%22my%22%3A%22data%22%7D")

  describe "sendData", ()->
    postOptions = undefined

    beforeEach ()->
      postOptions =
        host: jslogger.host
        port: jslogger.port
        path: "url"
        method: "POST"
        headers:
          "Content-Type": "application/x-www-form-urlencoded"
          "Content-Length": "post_data".length
          "Referer": "app:#{jslogger.key}"

    it "creates a request with the post options and a callback", ()->
      jslogger.sendData("url", "post_data")
      expect(httpModule.request).toHaveBeenCalledWith(postOptions, jasmine.any(Function))

    it "binds an error callback to the request", ()->
      jslogger.sendData("url", "post_data")
      expect(request.on).toHaveBeenCalledWith("error", jasmine.any(Function))

    it "writes the data to the request", ()->
      jslogger.sendData("url", "post_data")
      expect(request.write).toHaveBeenCalledWith("post_data")

    it "ends the request", ()->
      jslogger.sendData("url", "post_data")
      expect(request.end).toHaveBeenCalled()
