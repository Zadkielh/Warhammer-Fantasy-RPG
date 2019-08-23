ITEM.name = "A Crown"
ITEM.category = "Currency"
ITEM.desc = "A large medical kit capable of more healing."
ITEM.model = "models/zadkiel/coinpurse/coin.mdl"
ITEM.price = 0
ITEM.functions.Use = {
	sound = "items/medshot4.wav",
	onRun = function(item)
		item.player:getChar():giveMoney(1)
	end
}
ITEM.iconCam = {
	pos = Vector(320.89279174805, 269.75708007813, 194.73707580566),
	ang = Angle(25, 220, 0),
	fov = 0.58823529411765,
}
