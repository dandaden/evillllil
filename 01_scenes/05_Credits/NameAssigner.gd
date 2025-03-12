extends VBoxContainer

const name_prefab = preload("res://01_scenes/05_Credits/PatronName.tscn")
var name_instance
var i = - 1

enum TIER{SEPERATOR, TEAM, INVESTOR, BOARD}

var names = [
	["KomDog", TIER.TEAM], 
	["Oskenso", TIER.TEAM], 
	["", TIER.SEPERATOR], 
	["Superiorfox TM", TIER.BOARD], 
	["KuRiePenguin", TIER.BOARD], 
	["Qualske", TIER.BOARD], 
	["", TIER.SEPERATOR], 
	["Beurremine", TIER.INVESTOR], 
	["Protossman", TIER.INVESTOR], 
	["Jotie Tamaro", TIER.INVESTOR], 
	["Tama Shinrin", TIER.INVESTOR], 
	["Foxar Wolfen", TIER.INVESTOR], 
	["quikmaths", TIER.INVESTOR], 
	["Jace", TIER.INVESTOR], 
	["Papi the Harpy", TIER.INVESTOR]
]

func load_names():
	$RunName.start()

func _on_RunName_timeout():
	i += 1

	if i >= names.size():
		$RunName.stop()
		return

	
	name_instance = name_prefab.instance()
	add_child(name_instance)
	name_instance.animate_in()
	name_instance.set_text(names[i][0])
	if names[i][1] == TIER.INVESTOR:
		name_instance.set_tag("Investor", Color("#E74C3C"))
	elif names[i][1] == TIER.BOARD:
		name_instance.set_tag("Board Member", Color("#F1C40F"))
	elif names[i][1] == TIER.TEAM:
		name_instance.set_tag("Team Member", Color("#FF6188"))
	elif names[i][1] == TIER.SEPERATOR:
		name_instance.modulate = Color("#FFFFFF")


		
		


	

