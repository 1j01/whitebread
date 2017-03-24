
remove = (item, {from: array})->
	index = array.indexOf(item)
	if index >= 0
		array.splice(index, 1)

value = (object, prop)->
	if typeof object[prop] is "function"
		return object[prop]()
	return object[prop]

describe_current_room = (room)->
	msg(value(game.current_room, "description"))


commands = [
	{
		name: "look around"
		regex: /^(?:l|look|look around|look around you|examine room|where am I\?*|where\?*)$/i
		action: describe_current_room
		# TODO/FIXME:
		# look at room
		# There's no room here.
		# check out the room
		# There's no the room here.
		# look around the room
		# There's no around the room here.
		# look around at the room
		# There's no around at the room here.
		# "examine room"/"look at room"/"check out the room" should work based on the "examine" verb applying to the current room
		# I guess rooms will need take a default take message...
		# "You can't take rooms." or "You try to take it all in, but you know you'll forget it anyways."
	}
	{
		name: "examine"
		regex: /^(?:x|examine|l|look at|look|check out) (.+)/i
		action: (object)->
			msg(value(object, "description"))
			# TODO: examine doorways
			# we could consider doorways be objects present in multiple rooms
			# or continue to consider them separately as objects between rooms
	}
	{
		name: "take"
		regex: /^(?:take|pick up|pick) (.+)/i
		action: (object, game)->
			if value(object, "takeable") is true
				if object in game.player.inventory
					msg("Most people want what they don't already have.")
					return
				else if object.quantity > 0 or object.quantity is undefined
					remove(object, from: game.current_room.objects)
					game.player.inventory.push(object)
					# if object.quantity?
					# 	object.quantity -= 1
					# 	copyof(object).quantity = 1
				# TODO: duplicate objects and such for taking things that have different quantities
				# also things like take two/all/some/etc. if need be
				else
					msg("object.quantity is #{object.quantity}")
			
			# NOTE: take_description can be a message for failing to take as well
			if object.take_description
				msg(value(object, "take_description"))
			else if object.takeable
				msg("Taken.")
			else
				msg("You can't take that.")
	}
	{
		name: "drop"
		regex: /^(?:drop|leave|put down|put) (.+)(?: down)?(?: here)?/i
		# TODO: "let go of x" / "stop carrying x" / "stop holding x" / "abandon x" / "set x down"
		# "leave x behind" works already although so does "drop x no wait don't"
		# we might also want to allow you to specify locations to put things with prepositions but we don't really need that yet
		# ("set x on the table" / "place x ontop of the table" / "leave x on the floor" / "drop x on[to] the ground" / "put x back where it was")
		action: (object, game)->
			remove(object, from: game.player.inventory)
			game.current_room.objects.push(object)
			msg(value(object, "drop_description") or "Dropped.")
	}
	{
		name: "view inventory"
		regex: /^(?:(?:view|review|open|check|look at|l|examine|x) )?(?:inventory|inv|i)$/i
		# TODO: "take inventory"
		# TODO: "What am I holding?" / "What am I carrying?" / "What do I have?" / "What's in my inventory?"
		# / "wut supplies 'n' stuff do i got on me" / "whUu7 item(s) do i am be most currently having possession of, LOL?"
		action: (game)->
			if game.player.inventory.length is 0
				msg("You don't have anything.")
			else
				# display_item = (item)->
				# 	"<li>#{item.name}</li>"
				# 
				# msg("<ul class=\"inventory\">" + game.player.inventory.map(display_item).join("") + "</ul>")
				display_item = (item)->
					"a #{item.name}"
				msg("You have #{game.player.inventory.map(display_item).join(", ")}.")
				# TODO: use lowercase names
				# TODO: custom descriptors e.g. "You have a hammer, some flowers, you have a carpet tucked under arm, and you're wearing some yellow galoshes."
				# "You have a hammer, some flowers, a carpet tucked under arm, and you're wearing some yellow galoshes."
				# "You have a hammer, some flowers, a pair of yellow galoshes, and you have a carpet tucked under arm."
	}
	
	# TODO: use, walk/go into/to / enter room name / door name
	# TODO: (flip/toggle/switch/activate/actuate/press/flick/hit) (on/off/on off/power) (switch/button) / turn on/off tv / turn tv on/off
	# TODO: unplug tv; smash tv; kick/punch tv; sit in front of/and watch/gaze into the tv/screen / keep watching / examine mcd's
	
	{
		name: "view help"
		regex: /^(?:(?:view|review|open|check|look at|l|examine|x|get) )?(?:help|\?)/i
		action: (object)->
			msg("""
				Basic commands: <ul>
					<li><b>Examine</b> or <b>x <i>object</i></b></li>
					<li><b>Pick up </b> or <b>take <i>object</i></b></li>
					<li><b>Put down</b> or <b>drop <i>object</i></b></li>
					<li><b>View inventory</b> or <b>inv</b> or <b>i</b></li>
				</ul>
				
				Movement commands: <b>n</b>, <b>s</b>, <b>e</b>, <b>w</b>, <b>nw</b>, <b>ne</b>, <b>sw</b>,<b> se</b> (or e.g. <b>Go north!</b>)
			""", auto_br: false)
	}
	
	{
		name: "hammertime"
		regex: /^(?:stop[!\.,]*(?: [\/\-])? )?(?:hammertime)/i
		action: (game)->
			msg("Can't touch this.")
	}
	
	# only for copying:
	{
		name: "do something with"
		regex: /^(?:do something with) (.+)/i
		action: (object, game)->
	}
	{
		name: "just do something"
		regex: /^(?:do something)/i
		action: (game)->
	}
]

directions = {
	north: {dx: 0, dy: +1}
	south: {dx: 0, dy: -1}
	east: {dx: +1, dy: 0}
	west: {dx: -1, dy: 0}
	northeast: {dx: +1, dy: +1}
	southeast: {dx: +1, dy: -1}
	northwest: {dx: -1, dy: +1}
	southwest: {dx: -1, dy: -1}
}
direction_abbreviations = {
	north: "n"
	south: "s"
	east: "e"
	west: "w"
	northeast: "ne"
	southeast: "se"
	northwest: "nw"
	southwest: "sw"
}
oposite_of_direction = (direction_name)->
	direction = directions[direction_name]
	for other_direction, {dx, dy} of directions
		if (
			dx is -direction.dx and
			dy is -direction.dy
		)
			return other_direction

find_exit = (room, direction_name)->
	found_exit = null
	
	for doorway in doorways
		if doorway.between[0] is room.name and doorway.direction_name is direction_name
			found_exit = doorway
			exit_to_room_name = doorway.between[1]
		else if doorway.between[1] is room.name and doorway.direction_name is oposite_of_direction(direction_name)
			found_exit = doorway
			exit_to_room_name = doorway.between[0]
	
	{found_exit, exit_to_room_name}

for direction_name, {dx, dy} of directions
	do (direction_name, dx, dy)->
		abbr = direction_abbreviations[direction_name]
		commands.push {
			name: "go #{direction_name}"
			regex: new RegExp("^(?:go? ?|continue )?(?:a?head(ing)? )?(?:to(?: the)? )?(?:#{abbr}|#{direction_name})(?:-?(?:wards?|ways))?$", "i")
			action: (game)->
				{found_exit, exit_to_room_name} = find_exit(game.current_room, direction_name)
				
				if found_exit
					if found_exit.locked
						msg(value(found_exit, "locked_description") or "The door is locked.")
					else
						for room in rooms
							if room.name is exit_to_room_name
								game.current_room = room
								describe_current_room()
				else
					msg("You can't go that way.")
		}

(global ? @).describe_current_room = describe_current_room
(global ? @).commands = commands

