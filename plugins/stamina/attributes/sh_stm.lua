ATTRIBUTE.name = "Stamina"
ATTRIBUTE.desc = "Affects how fast you can run."
ATTRIBUTE.maxValue = 100

function ATTRIBUTE:onSetup(client, value)
	client:SetRunSpeed(nut.config.get("runSpeed") + value)
end