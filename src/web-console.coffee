
@msg = (html_content, options)->
	if typeof html_content isnt "string"
		throw new TypeError("expected string (html content) as first argument to msg()")
	
	unless options?.auto_br is no
		html_content = html_content.replace(/\n/g, "<br>")
	
	con.logHTML(html_content)

@game = new Game

con = new SimpleConsole
	handleCommand: (input)->
		game.interpret(input)
	placeholder: "Enter commands",
	autofocus: true,
	storageID: "whitebread"

document.body.appendChild(con.element)
con.handleUncaughtErrors()

game.start()
