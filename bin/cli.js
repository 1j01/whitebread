#!/usr/bin/env node

var argv = require("minimist")(process.argv.slice(2))

if (argv.version || argv.v) {
	console.log(`v${require("../package.json").version}`);
}else if (argv.usage || argv.help || argv.h || argv._.length === 0) {
	console.log(`
A surreal text adventure game.

Usage: whitebread

Options:
  -h, --help       Print usage information and exit.
  -v, --version    Print version number and exit.
`);
}else{
	console.log("euh?");
}
