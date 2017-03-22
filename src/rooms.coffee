
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
				name: "Vines"
				names: /Vines?/i
				description: "They look rather ordinary but are the wrong color of green."
				takeable: false
				take_description: "Now is not the time for gardening!"
			}
			{
				name: "Blossoms"
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
			You can see a <b>hammer</b>.
		"""
		exits: {
			south: "Antechamber"
		}
		objects: [
			{
				name: "Hammer"
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
				# TODO: if you drop these in a room without other boots you should be able to refer to them as just "boots"
				name: "Yellow Galoshes"
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
				name: "Snowshoes"
				names: /snowshoes|snow shoes|rackets/i
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
				names: /Television|TV|Telly/i
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
				names: /Bookshelf|Bookshelves/i
				description: """All of the titles and content of the books is just garbled nonsense. Or maybe you can't read, you aren't sure."""
				takeable: false
				take_description: """Knowledge is power, but you would need to read all of the books to be able to pick up the shelf, so what would be the point?"""
			}
			{
				name: "Toad Statuette"
				# names: /(?:Silver )?(?:Toad Statuette|Toad Statue|Toad|Amphibian)/i
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
					# NOTE: This'll be based on if you place things next to the toad
					# not just trying to take it repeatedly.
					desc = descriptions[@desc_index]
					# prepare the state for next time
					# NOTE: this could be cleaner with a function take() that returns a success bool and message together
					@desc_index = Math.min(@desc_index + 1, descriptions.length - 1)
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
		names: /(Domestic([\- ]looking)?) Door|/i
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

(global ? @).rooms = rooms
(global ? @).exits = exits
