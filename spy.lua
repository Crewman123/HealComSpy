VER = "v1.0"

libCHC = LibStub("LibHealComm-4.0", true)

local HealComm = select(2, ...)
local playersInfo = {};

function Spy_onload(mainFrame)
	mainFrame:RegisterEvent("ADDON_LOADED");
	mainFrame:RegisterEvent("PLAYER_LOGIN");

	mainFrame:SetScript("OnEvent", function(self, event, arg1, ...) Spy_OnEvent(event,arg1); end);

	SlashCmdList["LHCS"] = Spy_slash;
	SLASH_LHCS1 = "/hcs";
end

function Spy_OnEvent(event, arg1)
	if event == "ADDON_LOADED" then
		if arg1 == "HealCommSpy" then
			DEFAULT_CHAT_FRAME:AddMessage("Lib Heal Comm spy "..VER.." is loaded", 1.0 , 1.0 , 0.0);
			DEFAULT_CHAT_FRAME:AddMessage("type '/hcs' for spy info '/hcs clear' to clear spy info", 1.0 , 1.0 , 0.0);
		end
	elseif( event == "PLAYER_LOGIN" ) then
		libCHC.RegisterCallback(HealComm, "HealComm_HealStarted", "HealComm_HealUpdated")
		libCHC.RegisterCallback(HealComm, "HealComm_HealDelayed", "HealComm_HealUpdated")
		libCHC.RegisterCallback(HealComm, "HealComm_HealUpdated", "HealComm_HealUpdated")
	end	
end

function HealComm:HealComm_HealUpdated(event, casterGUID, spellID, healType, endTime, ...)

	local group = {
	"player",
	"party1",
	"party2",
	"party3",
	"party4",
	"raid1",
	"raid2",
	"raid3",
	"raid4",
	"raid5",
	"raid6",
	"raid7",
	"raid8",
	"raid9",
	"raid10",
	"raid11",
	"raid12",
	"raid13",
	"raid14",
	"raid15",
	"raid16",
	"raid17",
	"raid18",
	"raid19",
	"raid20",
	"raid21",
	"raid22",
	"raid23",
	"raid24",
	"raid25",
	"raid26",
	"raid27",
	"raid28",
	"raid29",
	"raid30",
	"raid31",
	"raid32",
	"raid33",
	"raid34",
	"raid35",
	"raid36",
	"raid37",
	"raid38",
	"raid39",
	"raid40",
	}

	for i=1, table.getn(group) do
		local unit = group[i];
		if UnitGUID(unit) == casterGUID then
			local name = GetSpellInfo(spellID);
			playersInfo[UnitName(unit)] = name;
		elseif UnitName(unit) ~=nil and playersInfo[UnitName(unit)] == nil then
			localizedClass, englishClass, classIndex = UnitClass(unit);
			if classIndex == 2 or classIndex == 5 or classIndex == 11 then
				playersInfo[UnitName(unit)] = "<NA>"
			end
		end
	end
end

function Spy_slash(msg)
	if msg == "clear" then
		playersInfo = {};
	else
		HealComm:HealComm_HealUpdated(nil,1,1);
		GetStatusText();
	end
end

function GetStatusText()
	local ret = "";
	for k,v in pairs(playersInfo) do
		DEFAULT_CHAT_FRAME:AddMessage(k..": "..v, 1.0 , 1.0 , 0.0);
	end
	return ret;
end
