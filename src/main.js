
document.body.classList.add("dark");

var msg = function(html, options){
	if(typeof html != "string"){
		throw new TypeError("msg() first argument must be a string (html)");
	}
	if(options && options.auto_br === false){
		return con.logHTML(html);
	}else{
		return con.logHTML(html.replace(/\n/g, "<br>"));
	}
};

var con = new SimpleConsole({
	// XXX: extra function because text/coffeescript not yet loaded
	handleCommand: function(input){
		interpret(input);
	},
	placeholder: "Enter commands",
	autofocus: true,
	storageID: "whitebread"
});
document.body.appendChild(con.element);
con.handleUncaughtErrors();
