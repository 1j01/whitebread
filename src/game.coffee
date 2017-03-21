
remove = (item, {from: array})->
	#console.log "remove", item, "from", array
	index = array.indexOf(item)
	if index >= 0
		array.splice(index, 1)

describe_current_room = (room)->
	desc = player.current_room.description
	# TODO: handle all these function-or-value things in one place (probably msg)
	if typeof desc is "function"
		msg(desc())
	else
		msg(desc)

commands = [
	{
		name: "look around"
		regex: /^(?:l|look|look around|look around you|examine room|where am I\?*|where\?*)$/i
		action: describe_current_room
	}
	{
		name: "examine"
		regex: /^(?:x|examine|l|look at|look|check out) (.+)/i
		action: (object)->
			msg(object.description)
			# TODO: examine exits
	}
	{
		name: "take"
		regex: /^(?:take|pick up|pick) (.+)/i
		action: (object)->
			if object.takeable is true
				
				if object in player.inventory
					#msg("You've already taken #{if object.nam}")
					#msg("You're holding #{if object.name.sdfgsf then "them" else "it"}")
					#msg("Already in your inventory.")
					msg("Most people want what they don't already have.")
					return
				else if object.quantity > 0 or object.quantity is undefined
					remove(object, from: player.current_room.objects)
					player.inventory.push(object)
					object.quantity -= 1
				
				# TODO: duplicate objects and such for taking things of a different quantities
				# also things like take two/all/some/etc. if need be
			
			if typeof object.take_description is "function"
				msg(object.take_description())
			else if object.take_description
				msg(object.take_description)
			else if object.takeable
				msg("Taken.")
			else
				msg("You can't take that.")
	}
	{
		name: "drop"
		regex: /^(?:drop|leave|put down|put) (.+)(?: down)(?: here)?/i
		action: (object)->
			# FIXME
			remove(object, from: player.inventory)
			#array = player.inventory
			#index = array.indexOf(object)
			#array.splice(index, 1)
			player.current_room.objects.push(object) unless object.destroy_on_drop is true
			msg(object.drop_description or "Dropped.")
	}
	{
		name: "view inventory"
		regex: /^(?:(?:view|review|open|check|look at|l|examine|x) )?(?:inventory|inv|i)$/i
		action: ->
			if player.inventory.length is 0
				msg("You don't have anything.")
			else
				#msg(player.inventory.join(", "))
				display_item = (item)->
					console.log item
					"<li>#{item.name}</li>"
				msg(player.inventory.map(display_item).join(""))
	}
	
	# TODO: use, walk/go into/to / enter room name / door name
	# TODO: hammertime
	
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
	
	# only for copying:
	{
		name: "boogie with it"
		regex: /^(?:boogie with) (.+)/i
		action: (object)->
	}
	{
		name: "just dance"
		regex: /^(?:dance)/i
		action: (object)->
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
	
	for exit in exits
		if exit.between[0] is room.name and exit.direction_name is direction_name
			found_exit = exit
			exit_to_room_name = exit.between[1]
		else if exit.between[1] is room.name and exit.direction_name is oposite_of_direction(direction_name)
			found_exit = exit
			exit_to_room_name = exit.between[0]
	
	{found_exit, exit_to_room_name}

for direction_name, {dx, dy} of directions
	do (direction_name, dx, dy)->
		abbr = direction_abbreviations[direction_name]
		commands.push {
			name: "go #{direction_name}"
			regex: new RegExp("^(?:go? ?|continue )?(?:a?head(ing)? )?(?:to(?: the)? )?(?:#{abbr}|#{direction_name})(?:-?(?:wards?|ways))?$", "i")
			action: ->
				{found_exit, exit_to_room_name} = find_exit(player.current_room, direction_name)
				
				if found_exit
					if found_exit.locked
						console.log "not letting you thru", found_exit
						msg(found_exit.locked_description or "The door is locked.")
					else
						for room in rooms
							if room.name is exit_to_room_name
								console.log "letting you thru", found_exit
								player.current_room = room
								describe_current_room()
				else
					msg("You can't go that way.")
		}

rooms = [
	{
		name: "Antechamber"
		description: """
			You are in the antechamber.
			The antechamber is a small, hexagonal room. Roman <b>columns</b> at each corner prop up a low, vaulted ceiling. <b>Vines</b> sprout from ornate <b>flowerpots</b> and climb up the walls, filling the room with greenery, and making it feel even smaller than it is. Each vine sports strangely geometric <b>blossoms</b>.
			A regal wood and stone door leads north. To the south is the emergency exit.
		"""
		exits: {
			north: "Ordinary Room"
		}
		objects: [
			{
				names: /Flowerpots?|pots/i
				description: "Each flowerpot is the vissage of a different terrible beast. Vines spring from their gaping maws."
				takeable: false
				take_description: "The flowerpots are a little too scary to get close to."
			}
			{
				names: /Columns?/i
				description: "Although difficult to see through the folliage, you can make out some of the elaborate reliefs. There is one of a strange fish-headed serpant that winds over all of them. Somehow it seems to have a head and tail wherever you look, yet its body makes a continous circuit of the room."
				takeable: false
				take_description: "Then what would hold up the ceiling?"
			}
			{
				names: /Vines?/i
				description: "They look rather ordinary but are the wrong color of green."
				takeable: false
				take_description: "Now is not the time for gardening!"
			}
			{
				names: /Blossoms?|Flowers?/i
				description: "There are several colors of flowers, each type having rather unnatural shapes. The aqua ones have perfectly triangular petals, the yellow ones have only a single spherical petal, and the lime ones have fern-like-fractal petals."
				takeable: true
				# TODO: take multiple
				quantity: Infinity
				take_description: "You pick some flowers."
				take_more_description: "You pick some more flowers."
				destroy_on_drop: true
				drop_description: "He loves me, he loves me not, he loves me..."
			}
			#{
				#names: /Emergency exit|South exit/i
				#description: "This door is for emergency use only."
				#takeable: false
				#take_description: ""
				#locked: true
				#direction_name: "south"
				#destination: ""
			#}
			#{
				#names: /Regal Door|North exit/i
				#description: "This door is for emergency use only."
				#takeable: false
				#take_description: ""
				#locked: false
				#direction_name: "north"
				#destination: "Ordinary Room"
			#}
		]
	}
	{
		name: "Ordinary Room"
		description: """
			You are in an ordinary room.
			A startlingly ordinary room. Four white walls, white ceiling, white floor. 
			There are some doors. A domestic-looking door leads north. A door of white plastic leads east. A regal wood and stone door leads south. A soft yellow door leads west.
		"""
		exits: {
			south: "Antechamber"
		}
		objects: [
			{
				names: /hammer/i
				description: "A single cast of iron, in the shape of a hammer. Most of the weight is in the handle so it's not very good. It is rather sloppily painted purple."
				takeable: true
				take_description: "Hammers are useful, so..."
			}
		]
	}
	{
		name: "Mudroom"
		description: """
			You are in a mudroom.
			The mudroom has clay tile floors covered in <b>bootprints</b>. A number of <b>shelves</b> line the walls for storing coats and boots. The air is pleasantly warm. Piles and piles of discarded outerwear fill the room. It is quite cozy and welcoming. 
			A simple door leads further north. The front door leads south.
		"""
		exits: {
			north: "living room"
		}
		objects: [
			{
				names: /pile of boots|boot pile|all the boots/i
				description: """There are boots for every kind of bad weather. If you wanted, you could probably find something in your size. Just skimming, you can see some <b>yellow galoshes</b> and <b>snowshoes</b> that look about right."""
				takeable: false
				take_description: "You only have two feet."
			}
			{
				names: /^boots$/i
				description: """There are boots for every kind of bad weather. If you wanted, you could probably find something in your size. Just skimming, you can see some <b>yellow galoshes</b> and <b>snowshoes</b> that look about right."""
				takeable: false
				take_description: "Which boots? So many to choose from."
			}
			{
				names: /galoshes|yellow galoshes|yellow boots/i
				description: """
					Yellow rubber boots.
					<i>+75% Moisture Resistance
					+1 Endurance
					-1 Agility</i>
				"""
				takeable: true
				take_description: ""
				drop_description: "Silly boots."
			}
			{
				names: /snowshoes|snow shoes/i
				description: """Really inconvenient shoes for really inconvenient weather.
				"""
				takeable: true
				take_description: ""
				drop_description: "Bye snowshoes."
			}
			{
				names: /bootprints?|footprints?|prints/i
				description: """There are prints of every shape, size, and shoe. It looks like a lot of people have taken off their muddy shoes in here. There are even some deer tracks..
				"""
				takeable: false
				take_description: "You would need some plaster."
				drop_description: ""
			}
			{
				names: /shelves/i
				description: """None of the boots or coats seem to have actually made it to the shelves."""
				takeable: false
				take_description: "You can't, because they have some walls stuck to them."
				drop_description: ""
			}
		]
	}
	{
		name: "Living Room"
		description: ->
			if @already_described
				once_text = ""
			else
				@already_described = true
				once_text = "It seems to be very recently occupied, and you have a sudden feeling you are intruding."
			
			"""
				You are in a living room.
				A wide open room with a nice warm <b>fireplace</b>. #{once_text} Several <b>bookshelves</b> carved from the trunks of large trees line the room. The center of the room is taken up by a glass <b>coffee table</b> and a <b>carpet</b>. A <b>television</b> is set in one corner, and a <b>piano</b> in the other.
				Two open archways lead elsewhere. A wide archway leads north. A medium archway leads east. A simple door leads south.	
			"""
		exits: {
			
		}
		objects: [
			{
				# TODO: names should probably be an array
				# we can generate a regexp from that and use the first item as the canonical name
				name: "Coffee Table"
				names: /Coffee Table|Table/i
				description: """The coffee table is empty except for an ashtray with a single <b>cigarette</b> in it. It is still smoking."""
				takeable: false
				take_description: """It seems to be nailed down."""
			}
			{
				name: "Carpet"
				names: /Carpet|Rug/i
				description: """The patterns remind you of an eyed hawk-moth: beautiful and vaguely threatening. It is made of mousepad foam."""
				takeable: true
				take_description: """You roll the carpet up and tuck it under your arm."""
			}
			{
				name: "Fireplace"
				names: /Fireplace|Firepit/i
				description: """Despite the warmth radiating out from it, there is no fire. A silver <b>toad statuette</b> sits in the middle of its brick home."""
				takeable: false
				take_description: "No."
			}
			{
				name: "Television"
				names: /Television|TV/i
				description: """The screen shows a barren wasteland. The sky is dark, but the ground is lit as if it were day. A McDonald's stands alone on the perfectly flat, brown, plane that stretches on forever. <span class="rec">[REC]</span> blinks in and out in the top right corner. There is an <b>on off switch</b>."""
				takeable: false
				take_description: """The wire is connected directly to the wall. There's no way to take the TV without rendering it useless."""
				subobjects: [
					{
						name: "on off switch"
						names: /On[ /]Off Switch|Switch|On[ /]Off Button|Power Button/i
						description: """The switch holds supreme power over the television."""
						takeable: false
						take_description: """Maybe take the whole TV?"""
					}
				]
			}
			{
				name: "Piano"
				names: /Piano/i
				description: """Besides being bright red, it is a perfectly ordinary piano."""
				takeable: true
				take_description: """You pick up the piano and put it snugly into your shirt pocket."""
			}
			{
				name: "Bookshelf"
				names: /Bookshelf/i
				description: """All of the titles and content of the books is just garbled nonsense. Or maybe you can't read, you aren't sure."""
				takeable: false
				take_description: """Knowledge is power, but you would need to read all of the books to be able to pick up the shelf, so what would be the point?"""
			}
			{
				name: "Toad Statuette"
				names: /Toad Statuette|Toad Statue|Toad|Amphibian/i
				description: """The polished silver amphibian sits proud, smiling at its lot in life."""
				takeable: false
				desc_index: 0
				take_description: ->
					descriptions = [
						"The toad is radiating heat too intense to touch!"
						"The toad is radiating heat too intense to touch."
						"The toad is too <i>unpleasantly warm</i> to take."
						"The toad warms your heart, because you put it in your breast pocket."
					]
					# NOTE: This isn't supposed to just be a linear progression
					# it'll be based on if you place things next to it
					desc = descriptions[@desc_index++]
					if @desc_index >= descriptions.length - 1
						@takeable = true
					desc
			}
		]
	}
	{
		name: "Storage Room"
		description: """
			Y R U HERE
			The sotarg roomtm  for all your storage bleeds
		"""
		exits: {
			
		}
		objects: [
			
		]
	}
	
	{
		name: "Next Room"
		description: """
			
		"""
		exits: {
			
		}
		objects: [
			
		]
	}
]

###
Future Objects (and Object Format)
###
future_objects = [
	{
		names: /Mirror/i
		description: """Since no objects (yourself included) are reflected in it, the mirror serves mainly to make the room appear much larger than it is."""
		takeable: false
		take_description: """The mirror is an entire wall, you cannot carry it."""
	}
	{
		names: /Step Ladder|Ladder/i
		description: """It's a really friendly looking ladder."""
		takeable: false
		take_description: """Ye dare not take it, lest ye spill the salt."""
	}
	{
		names: /Salt/i
		description: """Spilling salt is normally pretty bad, but this salt is even worse."""
		takeable: false
		take_description: """There is no way to reach it without risking knocking it over."""
	}
	{
		names: /Black Cat/i
		description: """There is not a black cat. It's missing."""
		takeable: false
		take_description: """Picking up random cats is a bad idea."""
	}
	{
		names: /The Mother/i
		description: """She has a long, teardrop shaped head and neck, squat body and short legs, and four long, spindly arms. Her skin is greyish pink, and she isn’t wearing anything except jewelry. With two of her hands the mother tends to something that is <b>approximately a baby</b>, while with another she tends a <b>frying pan</b>."""
		takeable: false
		take_description: """Lewd."""
	}
	{
		names: /Broken Television/i
		description: """The television is now lifeless. Its shattered screen bears glass teeth, trapped in an enternal, silent scream."""
		takeable: true
		take_description: """desc"""
	}
	
	# object format (for copying)
	{
		names: /Object_RegExp/i
		description: """desc"""
		takeable: false
		take_description: """desc"""
	}
	# door format (for copying)
	{
		names: /Object_RegExp/i
		description: """desc"""
		takeable: false
		take_description: """desc"""
		
		locked: false
		between: ["From_Room", "To_Room"]
		direction_name: ""
	}
]

exits = [
	{
		names: /Emergency exit/i
		description: "This door is for emergency use only."
		takeable: false # TODO :)
		take_description: "" # TODO
		locked: true
		locked_description: "This door is for emergency use only. It is not an emergency." # TODO
		between: ["Antechamber", "Storage Room"]
		direction_name: "south"
	}
	{
		names: /Regal Door/i
		description: ""
		takeable: false
		take_description: "" # TODO?
		locked: false
		between: ["Antechamber", "Ordinary Room"]
		direction_name: "north"
	}
	{
		names: /Domestic([\- ]looking)? Door|/i
		description: ""
		takeable: false
		take_description: "" # TODO?
		locked: false
		between: ["Ordinary Room", "Mudroom"]
		direction_name: "north"
	}
	{
		names: /Simple Door/i
		description: ""
		takeable: false
		take_description: "" # TODO?
		locked: false
		between: ["Mudroom", "Living Room"]
		direction_name: "north"
	}
	# exit format
	{
		names: /Name_RegExp/i
		description: ""
		takeable: false
		take_description: ""
		locked: false
		between: ["From_Room", "To_Room"]
		direction_name: ""
	}
]

player = {
	current_room: rooms[0]
	inventory: []
}

describe_current_room()


find_object_by_name = (room, object_name)->
	found_object = null
	for object in room.objects.concat(player.inventory)
		if object_name.match(object.names)
			found_object = object
		else if object.subobjects
			for object in object.subobjects
				if object_name.match(object.names)
					found_object = object
	found_object

@interpret = (input)->
	
	found_command = false
	
	for command in commands
		match = input.match(command.regex)
		if match?
			found_command = true
			
			object_name = match[1]
			if object_name?
				found_object = find_object_by_name(player.current_room, object_name)
				if found_object
					command.action(found_object)
				else
					if object_name.match(/^(wall|floor|ceiling|.*(door|exit))s?$/i)
						msg("You can't #{command.name} the #{object_name}.")
					else if object_name.match(/^(stuff|things|everything|it|them)s?$/i)
						msg("Be a little more specific.")
					else if object_name.match(/^nothing/)
						if command.name is "examine"
							msg("You close your eyes for a moment.")
						else
							msg("You #{command.name} nothing. Nothing happens.")
					else if object_name.replace(/[tsc]h/g, "x").match(/[qwrtpsdfghjklzxcvbnm]{3}/)
						msg("There's no gibberish here.")
					else
						if object_name.match /s$/i
							msg("There are no #{object_name.replace(/some /i, "")} here.")
						else
							msg("There's no #{object_name} here.")
			else
				command.action()
			# there was a matching command, so
			break # don't match any more commands
	
	unless found_command
		if input.replace(/[tsc]h/g, "x").replace(/(gg|tt|pp|bb|ff|bb|zz)[lr]/g, "$1").match(/[qwrtpsdfghjklzxcvbnm]{3}/)
			msg("Gibberish.")
		else if input.match(/\?$/)
			msg("I can't answer your questions.")
		else if input.match(/^(hm|that's interesting\.*|okay\.*)$/)
			msg("Indeed.")
		else if input.match(/^(go nowhere)$/)
			# TODO: should there be a single go command that matches anything and then parses directions or room or exit names?
			msg("You stay where you are.")
		else if input.match(/^(do nothing)$/)
			msg("You do nothing. Nothing happens.")
		else
			msg("???")
