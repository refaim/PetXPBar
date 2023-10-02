---@class PetXPFrame: Frame
---@field bar TextStatusBar
local frame = CreateFrame("Frame", nil)

local function createInterface()
	if frame.bar ~= nil then
		return
	end

	local widthIndent = PetFrameManaBar:GetWidth() * 0.1
	---@type TextStatusBar
	local bar = CreateFrame("StatusBar", "PetXPBar", PetFrame, "TextStatusBar")
	bar:SetWidth(PetFrameManaBar:GetWidth() - 2 * widthIndent)
	bar:SetHeight(6)
	bar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
	bar:SetStatusBarColor(255, 0, 255)
	bar:ClearAllPoints()
	bar:SetPoint("TOPLEFT", PetFrameManaBar, "BOTTOMLEFT", widthIndent, -3)

	local background = bar:CreateTexture(nil, "BACKGROUND")
	background:SetAllPoints(bar)
	background:SetVertexColor(0, 0, 0, 0.5)

	local borderAspectRatio = 120 / 18
	local border = bar:CreateTexture(nil, "OVERLAY")
	border:SetWidth(bar:GetWidth() * 1.2)
	border:SetHeight(border:GetWidth() / borderAspectRatio)
	border:SetTexture([[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]])
	border:SetPoint("TOPLEFT", -1 * 0.1 * border:GetWidth(), 0)
	border:SetTexCoord(0.0234375, 0.6875, 1.0, 0.0)

	frame.bar = bar
end

---@return boolean
local function updateVisibility()
	local hasPetInterface, isHunterPet = HasPetUI()
	local visible = hasPetInterface == 1 and isHunterPet == 1
	if visible then
		frame.bar:Show()
	else
		frame.bar:Hide()
	end
	return visible
end

local function update()
	createInterface()
	if updateVisibility() then
		local curExperience, maxExperience = GetPetExperience()
		frame.bar:SetMinMaxValues(0, maxExperience)
		frame.bar:SetValue(curExperience)
	end
end

frame:SetScript("OnEvent", function()
	update()
end)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UNIT_PET")
frame:RegisterEvent("UNIT_PET_EXPERIENCE")
