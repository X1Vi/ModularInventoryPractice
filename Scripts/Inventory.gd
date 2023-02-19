extends Control


#imports
var random = RandomNumberGenerator.new()
onready var mouseTextureRect : TextureRect = $mouseTextureRect

# for shifting from one slot to another
var mouseHolding : bool
var mouseitemTexture : String
var mouseitemQuantity : int
var mouseisStackable : bool
var mouseitemName : String
var mouseslotID : int
var holdingAItem : bool



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
		

func _physics_process(delta):
	print(get_global_mouse_position())
	print(get_local_mouse_position())
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
