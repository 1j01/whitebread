#!/usr/bin/env node

require("coffee-script/register");
// var Game = require("../src/Game.coffee");
require("../src/commands.coffee");
require("../src/rooms.coffee");
require("../src/game.coffee");

var argv = require("minimist")(process.argv.slice(2))
// var repl = require("repl");

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
		console.log(html_content);
	};
	// repl.start({
	// 	prompt: "> ",
	// 	eval: function myEval(cmd, context, filename, callback) {
	// 		callback(null, game.interpret(cmd));
	// 	}
	// });

	process.stdin.resume();
	process.stdin.setEncoding("utf8");

	process.stdin.on("data", function (input) {
		if (input === "quit\n") {
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
