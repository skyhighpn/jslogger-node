/**
 * JSLogger module tracking example
 *
 * Run this example from console: node log.js
 */

// Instatiate a logger with your secret API key.
// You can get your key on http://jslogger.com/manage/#code.
var logger = require("../lib/jslogger")({key: "SECRET_KEY"});

// Log an error string
logger.log("I'm an error! Log me!");

// Log an error object
logger.log({auth: {error: "Sign up failed...", reason: "Bad credentials."}});

// Log an event string
logger.event("We got a new signup!");

// Log an event object
logger.event({auth: {action: "Sign up", username: "doomhz"}});

// You can set the 'track' to 'false' in development or testing mode
var track = typeof NODE_ENV !== "undefined" && NODE_ENV === "production" ? true : false;
var logger2 = require("../lib/jslogger")({key: "SECRET_KEY", track: track});

// The remote request will not be executed if track = false
logger2.log("Non trackable error in dev mode");
logger2.event("Non trackable event in dev mode");