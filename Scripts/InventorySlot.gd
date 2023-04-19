extends Button

# imports
onready var itemTextureImage : TextureRect = $TextureRect
onready var quantityText : RichTextLabel = $QuantityText
signal transferSlotToMouse(inventorySlotslotID, inventorySlotitemTexture, inventorySlotitemQuantity, inventorySlotitemName, inventorySlotisStackable)

# variables defining items
var slotID : int
var itemTexture : String
var itemQuantity : int
var isStackable : bool
var itemName : String = ""

func _physics_process(delta):
	
	itemTextureImage.texture = load(itemTexture)
	quantityText.text = str(itemQuantity)

func _on_InventorySlot_pressed():
	emit_signal("transferSlotToMouse", slotID, itemTexture, itemQuantity,itemName, isStackable)
	print(slotID)
	
	if Inventory.mouseHolding == true and Inventory.mouseitemQuantity >= 1 and (Inventory.mouseitemName == itemName or itemName == ""):
		if Inventory.mouseitemName == itemName and isStackable == true:
		
			itemTexture = Inventory.mouseitemTexture
			itemQuantity = Inventory.mouseitemQuantity + itemQuantity
			isStackable = Inventory.mouseisStackable
			itemName = Inventory.mouseitemName
			
			
			Inventory.mouseitemTexture = ""
			Inventory.mouseitemQuantity = 0
			Inventory.mouseisStackable = false
			Inventory.mouseitemName = ""
			itemTextureImage.texture = load(itemTexture)
			Inventory.mouseHolding = false
			
			Inventory.mouseTextureRect.texture = null
		elif Inventory.mouseitemName == itemName and isStackable == false:
			pass
		else:
			itemTexture = Inventory.mouseitemTexture
			itemQuantity = Inventory.mouseitemQuantity
			isStackable = Inventory.mouseisStackable
			itemName = Inventory.mouseitemName
			
			
			Inventory.mouseitemTexture = ""
			Inventory.mouseitemQuantity = 0
			Inventory.mouseisStackable = false
			Inventory.mouseitemName = ""
			itemTextureImage.texture = load(itemTexture)
			Inventory.mouseHolding = false
			
			Inventory.mouseTextureRect.texture = null
		
	elif Inventory.mouseHolding == false and Inventory.mouseitemQuantity == 0 and itemQuantity > 0:
		Inventory.mouseHolding = true
		Inventory.mouseitemTexture = itemTexture
		Inventory.mouseitemQuantity = itemQuantity
		Inventory.mouseisStackable = isStackable
		Inventory.mouseitemName = itemName
		
		itemTexture = ""
		itemQuantity = 0
		isStackable = false
		itemName = ""
		
		


func _on_InventorySlot_button_down():
	pass # Replace with function body.


func _on_InventorySlot_button_up():
	pass

