
if require?
	require("./commands.coffee")
	require("./rooms.coffee")

is_probably_gibberish = (input)->
	# FIXME: "birds"/"words"/"forwards" etc. considered gibberish
	# as well as "acupuncture", "country", "birthday", "right", "hands", "commands"...
	input.replace(/[tsc]h/g, "x").replace(/(gg|tt|pp|bb|ff|bb|zz)[lr]/g, "$1").match(/[qwrtpsdfghjklzxcvbnm]{3}/)

# @player = {
# 	current_room: rooms[0]
# 	inventory: []
# }

class Game
	constructor: ->
		@player = {
			inventory: []
		}
		@current_room = rooms[0]
	
	start: ->
		describe_current_room()
	
	# TODO: this should be a method of Room
	find_object_by_name: (room, object_name)->
		found_object = null
		for object in room.objects.concat(@player.inventory)
			if object_name.match(object.names)
				found_object = object
			else if object.subobjects
				for object in object.subobjects
					if object_name.match(object.names)
						found_object = object
		found_object
	
	interpret: (input)=>
		input = input.trim()
		
		found_command = false
		
		for command in commands
			match = input.match(command.regex)
			if match?
				found_command = true
				
				object_name = match[1]
				if object_name?
					found_object = @find_object_by_name(@current_room, object_name)
					if found_object
						command.action(found_object, game)
					else
						if object_name.match(/^(wall|floor|ceiling|.*(door|exit))s?$/i)
							# TODO: examine doors and such
							msg("You can't #{command.name} the #{object_name}.")
							# The floor is the floor is the floor is the floor. (It's the floor.)
							# The ceiling's the ceiling you see, you see?
							# The walls are the walls are all walls that are wally.
							# The doors tho, they'll set you free!
							# The doors are the entrances, the exits, the... yeah. Doors.
						else if object_name.match(/^(stuff|things|everything|it|them)s?$/i)
							# TODO: maybe allow "take it"/"take" after examining something
							# maybe just "take it"
							msg("Be a little more specific.")
						else if object_name.match(/^nothing/)
							if command.name is "examine"
								msg("You close your eyes for a moment.")
							else
								msg("You #{command.name} nothing. Nothing happens.")
						else if is_probably_gibberish(object_name)
							msg("There's no gibberish here.")
						else
							if object_name.match /s$/i
								msg("There are no #{object_name.replace(/some /i, "")} here.")
							else
								# FIXME: > examine the thing "There's no the thing here."
								# also TODO: handle misspellings somehow?
								msg("There's no #{object_name} here.")
				else
					command.action(game)
				# there was a matching command, so
				break # don't match any more commands
		
		unless found_command
			if is_probably_gibberish(input)
				msg("Gibberish.")
			else if input.match(/\?$/)
				msg("I can't answer your questions.")
				# I don't know. It is a conundrum. It's hard to say. How should I know? I am not an oracle.
				# I'm not at liberty to say. Ask me later. That's a good question -- or a bad one, I don't know.
				# 42. If I have 5 apples, and I give you 3 oranges, how many teeth does a canary have?
			else if input.match(/^(hm|um|okay|k|yeah|(?:that's )?(?:interesting|weird)|that just happened)\.*$/i)
				# TODO: "hmmm... um, okay, so like.. that just happened!?? mkay" or not, y'know, maybe don't handle that
				msg("Indeed.")
			else if input.match(/^(go nowhere|stay(?: (?:put|(?:right )?t?here|where you are))?)$/i)
				msg("You stay where you are.")
			else if input.match(/^(do nothing)$/i)
				msg("You do nothing. Nothing happens.")
			else
				msg("???")

(global ? @).Game = Game
