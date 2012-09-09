describe "JSLogger", ()->
  jslogger = require "../lib/jslogger"

  beforeEach ()->

  it "has a url pointing to jslogger.com", ()->
    expect(jslogger.url).toEqual("http://jslogger.com")

  it "has a port", ()->
    expect(jslogger.port).toEqual("6987")

  describe "log", ()->
    it "logs an error", ()->
      expect(jslogger.log()).toEqual("TODO")

  describe "event", ()->
    it "logs an event", ()->
      expect(jslogger.event()).toEqual("TODO")