jslogger-node
=============

[![Build Status](https://secure.travis-ci.org/jslogger/jslogger-node.png)](http://travis-ci.org/jslogger/jslogger-node)

NodeJS module for JSLogger

## Installation

    $ npm install jslogger

## Documentation

Instatiate a logger with your secret API key. You can get your key on http://jslogger.com/manage/#code.
```javascript
var logger = require("jslogger")({key: "SECRET_KEY"});
```

Log an error string
```javascript
logger.log("I'm an error! Log me!");
```

Log an error object
```javascript
logger.log({auth: {error: "Sign up failed...", reason: "Bad credentials."}});
```

Log an event string
```javascript
logger.event("We got a new signup!");
```

Log an event object
```javascript
logger.event({auth: {action: "Sign up", username: "doomhz"}});
```

You can set the `track` to `false` in development or testing mode
```javascript
var track = process.env.NODE_ENV === "production" ? true : false;
var logger2 = require("jslogger")({key: "SECRET_KEY", track: track});
```

The remote request will not be executed when `track` option is `false`
```javascript
logger2.log("Non trackable error in dev mode");
logger2.event("Non trackable event in dev mode");
```