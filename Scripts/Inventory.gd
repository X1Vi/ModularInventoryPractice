extends Control

# saves
var save_path = "res://save/inventory.json"
var inventory_save :Array  = []


#imports
var random = RandomNumberGenerator.new()
onready var mouseTextureRect : TextureRect = $mouseTextureRect
onready var mouseQuantityText : RichTextLabel = $mouseTextureRect/mouseItemCount

# for shifting from one slot to another
var mouseHolding : bool
var mouseitemTexture : String
var mouseitemQuantity : int
var mouseisStackable : bool
var mouseitemName : String
var mouseslotID : int
var holdingAItem : bool

# rearranging
var reArrangedItems = {		}	
var checkReArrangedItems = {}


# for assembling inventory slots
var slotsLimit = 20
onready var gridContainer  = $VScrollBar/GridContainer
var inventorySlotSceneReference = load("res://Scenes/InventorySlot.tscn")

# items in game
var healthPotion : Dictionary = {
	"name": "healthPotion",
	"isStackable" : true,
	"itemTexture" : "res://assets/16x16/potion_01a.png"
}

var sword : Dictionary = {
	"name": "sword",
	"isStackable" : false,
	"itemTexture" : "res://assets/16x16/sword_02a.png"
}

var shard : Dictionary = {
	"name" : "shard",
	"isStackable": true,
	"itemTexture": "res://assets/16x16/shard_01g.png"
}

var all_items_dictionary : Dictionary = {
	"healthPotion": healthPotion,
	"sword" : sword,
	"shard" : shard
}

var all_items_array : Array = [
	healthPotion, sword, shard
]


func _ready():
	var forMarkingEachSlotID = 0
	for slot in slotsLimit:
		var t_inventorySlot = inventorySlotSceneReference.instance()
		t_inventorySlot.connect("transferSlotToMouse", self, "_on_slot_pressed")
		t_inventorySlot.slotID = forMarkingEachSlotID
		gridContainer.add_child(t_inventorySlot)
		forMarkingEachSlotID += 1
	loadTheSaveInventory()
	
		
func loadTheSaveInventory():
	load_from_file()
	if inventory_save.size() > 0:		
		var slots  = gridContainer.get_children()
		var index = 0
		print(inventory_save.size())
		for slot in slots:
			if index < inventory_save.size():
				slot.itemName = inventory_save[index].itemName
				slot.itemTexture = inventory_save[index].itemTexture
				slot.itemQuantity = inventory_save[index].itemQuantity
				slot.isStackable = inventory_save[index].isStackable
				index = index + 1	
	
	
func _physics_process(delta):
	printMouseQuantity()
	mouseTextureFollowMouse()
	switchMouseTexture()


func _on_GenerateRandomItems_pressed():
	var inventory_slots = gridContainer.get_children()
	for slot in inventory_slots:
		var random_int = randi() % 3
		var random_bool = random_int < 2
		
		if random_bool == true:
			var min_value = 0
			var max_value = 2
			var selectThisItem = random.randi_range(min_value, max_value)
			#slotID : int
			#itemTexture : Texture
			#itemQuantity : int	
			#isStackable : bool
			#itemName : String
			
			slot.itemName = all_items_array[selectThisItem].name
			slot.itemTexture = str(all_items_array[selectThisItem].itemTexture)
			slot.isStackable = all_items_array[selectThisItem].isStackable
			slot.itemQuantity = selectThisItem + 1

func switchMouseTexture():
	if mouseHolding == true:
		mouseTextureRect.texture = load(mouseitemTexture)
					
					
		

		
		
func mouseTextureFollowMouse():
	var t_y = get_local_mouse_position().y
	var t_x = get_local_mouse_position().x + 20
	var t_texture_vector = Vector2(t_x,t_y)
	mouseTextureRect.set_position(t_texture_vector)

# debug
func printMouseInventory():
	print("mouse holding", mouseHolding)
	#print(mouseitemTexture)
	#print(mouseitemQuantity)
	#print(mouseisStackable)
	#print(mouseitemName)
	#print(mouseslotID)
	#print(holdingAItem) 


func _on_Timer_timeout():
	printMouseInventory()


func save_to_file():
	var file = File.new()
	file.open(save_path, File.WRITE)
	file.store_string(to_json(inventory_save))
	file.close()

func load_from_file():
	var file = File.new()
	if file.file_exists(save_path):
		file.open(save_path, File.READ)
		var json_string = file.get_as_text()
		inventory_save = parse_json(json_string)
		file.close()


func _on_save_button_pressed():
	var slots = gridContainer.get_children()
	inventory_save = []  # clear the inventory_save array before adding new items
	for slot in slots:
		var item_data = {
			"slotID" : slot.slotID,
			"itemTexture" : slot.itemTexture,
			"itemQuantity" : slot.itemQuantity,
			"isStackable":  slot.isStackable,
			"itemName" : slot.itemName
		}
		inventory_save.append(item_data)
	save_to_file()
	print(inventory_save)
	
	
	


func _on_re_arrange_pressed():
		var get_items = {
			
		}
		
		var slots = gridContainer.get_children()
		for slot in slots:
			if get_items.has(slot.itemName) == false:
				get_items[slot.itemName] = {
					"itemName" : slot.itemName,
					"itemQuantity" : slot.itemQuantity,
					"itemTexture" : slot.itemTexture,
					"isStackable" : slot.isStackable	
				}
			elif get_items.has(slot.itemName) == true and slot.isStackable == true:
				get_items[slot.itemName].itemQuantity += slot.itemQuantity
			else:
				get_items[str(slot.itemName) + " " + str(slot.slotID)] = {
					"itemName" : slot.itemName,
					"itemQuantity" : slot.itemQuantity,
					"itemTexture" : slot.itemTexture,
					"isStackable" : slot.isStackable
				}
				
		for slot in slots:
			slot.itemName = ""
			slot.itemQuantity = 0
			slot.itemTexture = ""
			slot.isStackable = false
		
		var index : int = 0
		for itemKeys in get_items:
			slots[index].itemName = get_items[itemKeys].itemName
			slots[index].itemQuantity = get_items[itemKeys].itemQuantity
			slots[index].itemTexture = get_items[itemKeys].itemTexture
			slots[index].isStackable = get_items[itemKeys].isStackable
			index = index + 1
		print(get_items)
		
	
			
		
		
	  

func _on_load_pressed():
	loadTheSaveInventory()
	
func printMouseQuantity():
	if mouseitemQuantity > 0:
		mouseQuantityText.text = str(mouseitemQuantity)
	else:
		mouseQuantityText.text = ""

func _on_slot_pressed(inventorySlotslotID, inventorySlotitemTexture, inventorySlotitemQuantity, inventorySlotitemName, inventorySlotisStackable):
	print("Working")
	print("inventorySlotID " + str(inventorySlotslotID) )
