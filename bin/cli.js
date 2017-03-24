#!/usr/bin/env node

require("coffee-script/register");
require("../src/commands.coffee");
require("../src/rooms.coffee");
require("../src/game.coffee");

var chalk = require("chalk");
var argv = require("minimist")(process.argv.slice(2))

if (argv.version || argv.v) {
	console.log(`v${require("../package.json").version}`);
} else if (argv.usage || argv.help || argv.h) {
	console.log(`
A surreal text adventure game.

Usage: whitebread

Options:
  -h, --help       Print usage information and exit.
  -v, --version    Print version number and exit.
`);
} else {
	var game = new Game;
	global.game = game;
	global.msg = function(html_content){
		// TODO: handle help text and the TV's "[REC]" (ideally blinking)
		// could use htmlparser
		var output = html_content
			.replace(/<b>([^\/]*)<\/b>/gi, (m, text)=> chalk.bold.magenta(text))
			.replace(/<i>([^\/]*)<\/i>/gi, (m, text)=> chalk.italic.gray(text));
		console.log(output);
	};

	process.stdin.resume();
	process.stdin.setEncoding("utf8");

	process.stdin.on("data", function (input) {
		if (input.trim() === "quit") {
			process.exit();
		} else {
			try {
				game.interpret(input);
			} catch(err) {
				console.error(err);
			}
			process.stdout.write("> ");
		}
	});

	game.start();
	process.stdout.write("> ");
}
