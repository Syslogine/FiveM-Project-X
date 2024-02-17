local isJudge = false
local isPolice = false
local isMedic = false
local isDoctor = false
local isNews = false
local isDead = false
local isInstructorMode = false
local myJob = "unemployed"
local isHandcuffed = false
local isHandcuffedAndWalking = false
local hasOxygenTankOn = false
local gangNum = 0
local cuffStates = {}

rootMenuConfig =  {
    {
        id = "general",
        displayName = "General",
        icon = "#globe-europe",
        enableMenu = function()
            return not isDead
        end,
        subMenus = {"general:escort", "general:putinvehicle", "general:unseatnearest", "general:flipvehicle", "general:keysgive",  "general:emotes",  "general:checkvehicle", "general:askfortrain", "general:apartgivekey",  }
    },
    {
        id = "police-action",
        displayName = "Police Actions",
        icon = "#police-action",
        enableMenu = function()
            return (isPolice and not isDead)
        end,
        subMenus = {"general:putinvehicle", "general:escort", "medic:revive", "cuffs:remmask", "general:checktargetstates", "police:checkbank", "police:checklicenses", "cuffs:checkinventory", "police:gsr", "open:carmenu", "police:dnaswab", "police:runplate"}
    },
    {
        id = "police-vehicle",
        displayName = "Police Vehicle",
        icon = "#police-vehicle",
        enableMenu = function()
            return (isPolice and not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end,
        subMenus = {"general:unseatnearest", "police:runplate", "police:toggleradar"}
    },
    {
        id = "police-license",
        displayName = "License Actions",
        icon = "#license-general",
        enableMenu = function()
            return (isPolice and not isDead)
        end,
        subMenus = {"license:grantWeapon", "license:removeweapons" --[["license:granthunting", "license:removehunting", "license:grantfishing", "license:removefishing"]]}
    },
    {
        id = "panic",
        displayName = "Panic",
        icon = "#police-action-panic",
        functionName = "ethical-dispatch:panic",
        enableMenu = function()
            return (isPolice or isMedic and not isDead)
        end
    },
    {
        id = "policeDeadA",
        displayName = "10-13A",
        icon = "#police-dead",
        functionName = "police:tenThirteenA",
        enableMenu = function()
            return (isPolice and isDead)
        end
    },
    {
        id = "policeDeadB",
        displayName = "10-13B",
        icon = "#police-dead",
        functionName = "police:tenThirteenB",
        enableMenu = function()
            return (isPolice and isDead)
        end
    },
    {
        id = "emsDeadA",
        displayName = "10-14A",
        icon = "#ems-dead",
        functionName = "police:tenForteenA",
        enableMenu = function()
            return (isMedic and isDead)
        end
    },
    {
        id = "emsDeadB",
        displayName = "10-14B",
        icon = "#ems-dead",
        functionName = "police:tenForteenB",
        enableMenu = function()
            return (isMedic and isDead)
        end
    },
    {
        id = "k9",
        displayName = "K9",
        icon = "#k9",
        enableMenu = function()
            return (isPolice and not isDead)
        end,
        subMenus = {"k9:follow", "k9:vehicle",  "k9:sniffvehicle", "k9:huntfind", "k9:sit", "k9:stand", "k9:sniff", "k9:lay",  "k9:spawn", "k9:delete", }
    },
    {
        id = "animations",
        displayName = "Gait",
        icon = "#walking",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "animations:brave", --[["animations:hurry",]] "animations:business", "animations:tipsy", "animations:injured","animations:tough", "animations:default", "animations:hobo", "animations:money", "animations:swagger", "animations:shady", "animations:maneater", "animations:chichi", "animations:sassy", "animations:sad", "animations:posh", "animations:alien",
        
        --new
        "animations:arrogant","animations:casual","animations:casual2","animations:casual3","animations:casual4","animations:casual5","animations:casual6","animations:confident","animations:business2","animations:business3","animations:femme","animations:flee","animations:gangster","animations:gangster2","animations:gangster3","animations:gangster4","animations:gangster5","animations:heels","animations:heels2","animations:muscle",--[["animations:quick",]]"animations:wide","animations:scared", }
    },
    {
        id = "expressions",
        displayName = "Expressions",
        icon = "#expressions",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "expressions:normal", "expressions:drunk", "expressions:angry", "expressions:dumb", "expressions:electrocuted", "expressions:grumpy", "expressions:happy", "expressions:injured", "expressions:joyful", "expressions:mouthbreather", "expressions:oneeye", "expressions:shocked", "expressions:sleeping", "expressions:smug", "expressions:speculative", "expressions:stressed", "expressions:sulking", "expressions:weird", "expressions:weird2"}
    },
    {
        id = "blips",
        displayName = "Blips",
        icon = "#blips",
        enableMenu = function()
            return not isDead
        end,
        subMenus = { "blips:gasstations", "blips:trainstations", "blips:garages", "blips:barbershop", "blips:tattooshop"}
    },
    {
        id = "drivinginstructor",
        displayName = "Driving Instructor",
        icon = "#drivinginstructor",
        enableMenu = function()
            return (not isDead and isInstructorMode)
        end,
        subMenus = { "drivinginstructor:drivingtest", "drivinginstructor:submittest", }
    },
    {
        id = "judge-raid",
        displayName = "Judge Raid",
        icon = "#judge-raid",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = { "judge-raid:checkowner", "judge-raid:seizeall", "judge-raid:takecash", "judge-raid:takedm"}
    },
    {
        id = "judge-licenses",
        displayName = "Judge Licenses",
        icon = "#judge-licenses",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = { "police:checklicenses", "judge:grantDriver", "judge:grantBusiness", "judge:grantWeapon", "judge:grantHouse", "judge:grantBar", "judge:grantDA", "judge:removeDriver", "judge:removeBusiness", "judge:removeWeapon", "judge:removeHouse", "judge:removeBar", "judge:removeDA", "judge:denyWeapon", "judge:denyDriver", "judge:denyBusiness", "judge:denyHouse" }
    },
    {
        id = "judge-actions",
        displayName = "Judge Actions",
        icon = "#judge-actions",
        enableMenu = function()
            return (not isDead and isJudge)
        end,
        subMenus = { "police:cuff", "cuffs:uncuff", "general:escort", "police:frisk", "cuffs:checkinventory", "police:checkbank"}
    },
    {
        id = "da-actions",
        displayName = "DA Actions",
        icon = "#judge-actions",
        enableMenu = function()
            return (not isDead and exports["ethical-base"]:getModule("LocalPlayer"):getVar("job") == "district attorney")
        end,
        subMenus = { "police:cuff", "cuffs:uncuff", "general:escort", "police:frisk", "cuffs:checkinventory"}
    },
    {
        id = "cuff",
        displayName = "Cuff Actions",
        icon = "#cuffs",
        enableMenu = function()
            return (not isDead and not isHandcuffed and not isHandcuffedAndWalking and (exports["ethical-inventory"]:hasEnoughOfItem("cuffs",1,false) or isPolice))
        end,
        subMenus = { "cuffs:uncuff", "cuffs:remmask", "cuffs:unseat", "police:seat", "cuffs:checkphone" }
    },
    {
        id = "cuff",
        displayName = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "civ:cuffFromMenu",
        enableMenu = function()
            return (not isDead and not isHandcuffed and not isHandcuffedAndWalking and (exports["ethical-inventory"]:hasEnoughOfItem("cuffs",1,false) or isPolice))
        end
    },
    {
        id = "medic",
        displayName = "Medical",
        icon = "#medic",
        enableMenu = function()
            return (not isDead and isMedic)
        end,
        subMenus = {"medic:revive", "medic:heal", "medic:heal2", "general:escort", "general:putinvehicle", "general:unseatnearest", "open:carmenuems" }
    },
    {
        id = "doctor",
        displayName = "Doctor",
        icon = "#doctor",
        enableMenu = function()
            return (not isDead and isDoctor)
        end,
        subMenus = { "general:escort", "medic:revive", "medic:stomachpump", "general:checktargetstates", "medic:heal", "open:carmenuems" }
    },
    {
        id = "news",
        displayName = "News",
        icon = "#news",
        enableMenu = function()
            return (not isDead and isNews)
        end,
        subMenus = { "news:setCamera", "news:setMicrophone", "news:setBoom" }
    },
    {
        id = "vehicle",
        displayName = "Vehicle",
        icon = "#vehicle-options-vehicle",
        functionName = "veh:options",
        enableMenu = function()
            return (not isDead and IsPedInAnyVehicle(PlayerPedId(), false))
        end
    },

    {
        id = "impoundmenu",
        displayName = "Return Vehicle",
        icon = "#blips-garages",
        functionName = "returnVehicle",
        enableMenu = function()
            return (not isDead and isPolice or isMedic)
        end
    },

    {
        id = "enterrey",
        displayName = "Enter Recycle Center",
        icon = "#enter-general",
        functionName = "lmafo:enter",
         enableMenu = function()
             for _,d in ipairs(enterrecy_locations) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leaverey",
        displayName = "Leave Recycle Center",
        icon = "#leave-general",
        functionName = "lmafo:leave",
         enableMenu = function()
             for _,d in ipairs(leaverecy_locations) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "enter2",
        displayName = "Enter Courthouse",
        icon = "#enter-general",
        functionName = "apartments:enterjobcenter2",
         enableMenu = function()
             for _,d in ipairs(enter_locations2) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "enter3",
        displayName = "Enter Lawyer Officer",
        icon = "#enter-general",
        functionName = "apartments:enterjobcenter3",
         enableMenu = function()
             for _,d in ipairs(enter_locations3) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },
    

    {
        id = "enter4",
        displayName = "Enter Court Room",
        icon = "#enter-general",
        functionName = "apartments:enterjobcenter4",
         enableMenu = function()
             for _,d in ipairs(enter_locations4) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "enter5",
        displayName = "Lower Pillbox",
        icon = "#enter-general",
        functionName = "apartments:enterjobcenter5",
         enableMenu = function()
             for _,d in ipairs(enter_locations5) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "enter6",
        displayName = "Roof Top",
        icon = "#enter-general",
        functionName = "apartments:enterjobcenter6",
         enableMenu = function()
             for _,d in ipairs(enter_locations6) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "steal",
        displayName = "Rob Player",
        icon = "#enter-general",
        functionName = "police:stealrob",
         enableMenu = function()
            t, distance, closestPed = GetClosestPlayer()
            if not IsPedInAnyVehicle(PlayerPedId()) and distance ~= -1 and distance < 2 and ( IsEntityPlayingAnim(closestPed, "dead", "dead_a", 3) or IsEntityPlayingAnim(closestPed, "amb@code_human_cower_stand@male@base", "base", 3) or IsEntityPlayingAnim(closestPed, "amb@code_human_cower@male@base", "base", 3) or IsEntityPlayingAnim(closestPed, "random@arrests@busted", "idle_a", 3) or IsEntityPlayingAnim(closestPed, "mp_arresting", "idle", 3) or IsEntityPlayingAnim(closestPed, "random@mugging3", "handsup_standing_base", 3) or IsEntityPlayingAnim(closestPed, "missfbi5ig_22", "hands_up_anxious_scientist", 3) or IsEntityPlayingAnim(closestPed, "missfbi5ig_22", "hands_up_loop_scientist", 3) or IsEntityPlayingAnim(closestPed, "missminuteman_1ig_2", "handsup_base", 3) ) then
                return true
             end
             return false
         end
    },

    {
        id = "leave",
        displayName = "Leave Job Center",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter",
         enableMenu = function()
             for _,d in ipairs(leave_locations) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leave2",
        displayName = "Leave Courthouse",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter2",
         enableMenu = function()
             for _,d in ipairs(leave_locations2) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leave3",
        displayName = "Leave Lawyer Officer",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter3",
         enableMenu = function()
             for _,d in ipairs(leave_locations3) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leave4",
        displayName = "Leave Court Room",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter4",
         enableMenu = function()
             for _,d in ipairs(leave_locations4) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leave5",
        displayName = "Upper Pillbox",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter5",
         enableMenu = function()
             for _,d in ipairs(leave_locations5) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "leave6",
        displayName = "Main Pillbox",
        icon = "#leave-general",
        functionName = "apartments:leavejobcenter6",
         enableMenu = function()
             for _,d in ipairs(leave_locations6) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 2 and not isDead then
                     return true
                 end
             end
             return false
         end
    },

    {
        id = "train",
        displayName = "Request Train",
        icon = "#general-ask-for-train",
        functionName = "AskForTrain",
        enableMenu = function()
            for _,d in ipairs(trainstations) do
                if #(vector3(d[1],d[2],d[3]) - GetEntityCoords(PlayerPedId())) < 25 and not isDead then
                    return true
                end
            end
            return false
        end
    }, {
        id = "impound",
        displayName = "Impound Vehicle",
        icon = "#impound-vehicle",
        functionName = "impoundVehicle",
        enableMenu = function()
            if not isDead and myJob == "towtruck" and #(GetEntityCoords(PlayerPedId()) - vector3(549.47796630859, -55.197559356689, 71.069190979004)) < 10.599 then
                return true
            end
            return false
        end
    }, {
        id = "oxygentank",
        displayName = "Remove Oxygen Tank",
        icon = "#oxygen-mask",
        functionName = "RemoveOxyTank",
        enableMenu = function()
            return not isDead and hasOxygenTankOn
        end
    }, {
        id = "cocaine-status",
        displayName = "Request Status",
        icon = "#cocaine-status",
        functionName = "cocaine:currentStatusServer",
        enableMenu = function()
            if not isDead and gangNum == 2 and #(GetEntityCoords(PlayerPedId()) - vector3(1087.3937988281,-3194.2138671875,-38.993473052979)) < 0.5 then
                return true
            end
            return false
        end
    }, {
        id = "cocaine-crate",
        displayName = "Remove Crate",
        icon = "#cocaine-crate",
        functionName = "cocaine:methCrate",
        enableMenu = function()
            if not isDead and gangNum == 2 and #(GetEntityCoords(PlayerPedId()) - vector3(1087.3937988281,-3194.2138671875,-38.993473052979)) < 0.5 then
                return true
            end
            return false
        end
    }, {
        id = "mdt",
        displayName = "MDT",
        icon = "#mdt",
        functionName = "ethical-mdt:hotKeyOpen",
        enableMenu = function()
            return ((exports["ethical-base"]:getModule("LocalPlayer"):getVar("job") == "district attorney" or isPolice or isJudge or isMedic) and not isDead)
        end
    }



}

newSubMenus = {
    ['general:emotes'] = {
        title = "Emotes",
        icon = "#general-emotes",
        functionName = "emotes:OpenMenu"
    },    
    ['general:keysgive'] = {
        title = "Give Key",
        icon = "#general-keys-give",
        functionName = "keys:give"
    },
    ['general:apartgivekey'] = {
        title = "Give Key",
        icon = "#general-apart-givekey",
        functionName = "apart:giveKey"
    },
    ['general:askfortrain'] = {
        title = "Request Train",
        icon = "#general-ask-for-train",
        functionName = "AskForTrain",
    },
    ['general:checkoverself'] = {
        title = "Examine Self",
        icon = "#general-check-over-self",
        functionName = "Evidence:CurrentDamageList"
    },
    ['general:checktargetstates'] = {
        title = "Examine Target",
        icon = "#general-check-over-target",
        functionName = "requestWounds"
    },
    ['general:checkvehicle'] = {
        title = "Examine Vehicle",
        icon = "#general-check-vehicle",
        functionName = "towgarage:annoyedBouce"
    },
    ['general:escort'] = {
        title = "Escort",
        icon = "#general-escort",
        functionName = "escortPlayer"
    },
    ['general:putinvehicle'] = {
        title = "Seat Vehicle",
        icon = "#general-put-in-veh",
        functionName = "police:forceEnter"
    },
    ['general:unseatnearest'] = {
        title = "Unseat Nearest",
        icon = "#general-unseat-nearest",
        functionName = "unseatPlayer"
    },    
    ['general:flipvehicle'] = {
        title = "Flip Vehicle",
        icon = "#general-flip-vehicle",
        functionName = "FlipVehicle"
    },
    
    ['animations:joy'] = {
        title = "Joy",
        icon = "#animation-joy",
        functionName = "AnimSet:Joy"
    },
    ['animations:sexy'] = {
        title = "Sexy",
        icon = "#animation-sexy",
        functionName = "AnimSet:Sexy"
    },
    ['animations:moon'] = {
        title = "Moon",
        icon = "#animation-moon",
        functionName = "AnimSet:Moon"
    },
    ['animations:tired'] = {
        title = "Tired",
        icon = "#animation-tired",
        functionName = "AnimSet:Tired"
    },
    ['animations:arrogant'] = {
        title = "Arrogant",
        icon = "#animation-arrogant",
        functionName = "AnimSet:Arrogant"
    },
    
    ['animations:casual'] = {
        title = "Casual",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual"
    },
    ['animations:casual2'] = {
        title = "Casual 2",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual2"
    },
    ['animations:casual3'] = {
        title = "Casual 3",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual3"
    },
    ['animations:casual4'] = {
        title = "Casual 4",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual4"
    },
    ['animations:casual5'] = {
        title = "Casual 5",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual5"
    },
    ['animations:casual6'] = {
        title = "Casual 6",
        icon = "#animation-casual",
        functionName = "AnimSet:Casual6"
    },
    ['animations:confident'] = {
        title = "Confident",
        icon = "#animation-confident",
        functionName = "AnimSet:Confident"
    },
    
    ['animations:business2'] = {
        title = "Business 2",
        icon = "#animation-business",
        functionName = "AnimSet:Business2"
    },
    ['animations:business3'] = {
        title = "Business 3",
        icon = "#animation-business",
        functionName = "AnimSet:Business3"
    },
    
    ['animations:femme'] = {
        title = "Femme",
        icon = "#animation-female",
        functionName = "AnimSet:Femme"
    },
    ['animations:flee'] = {
        title = "Flee",
        icon = "#animation-flee",
        functionName = "AnimSet:Flee"
    },
    ['animations:gangster'] = {
        title = "Gangster",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster"
    },
    ['animations:gangster2'] = {
        title = "Gangster 2",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster2"
    },
    ['animations:gangster3'] = {
        title = "Gangster 3",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster3"
    },
    ['animations:gangster4'] = {
        title = "Gangster 4",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster4"
    },
    ['animations:gangster5'] = {
        title = "Gangster 5",
        icon = "#animation-gangster",
        functionName = "AnimSet:Gangster5"
    },
    
    ['animations:heels'] = {
        title = "Heels",
        icon = "#animation-female",
        functionName = "AnimSet:Heels"
    },
    ['animations:heels2'] = {
        title = "Heels 2",
        icon = "#animation-female",
        functionName = "AnimSet:Heels2"
    },
    
    ['animations:hipster'] = {
        title = "Hipster",
        icon = "#animation-hipster",
        functionName = "AnimSet:Hipster"
    },
    ['animations:hiking'] = {
        title = "Hiking",
        icon = "#animation-hiking",
        functionName = "AnimSet:Hiking"
    },
    
    ['animations:jog'] = {
        title = "Jog",
        icon = "#animation-jog",
        functionName = "AnimSet:Jog"
    },
    
    ['animations:muscle'] = {
        title = "Muscle",
        icon = "#animation-tough",
        functionName = "AnimSet:Muscle"
    },
    
    -- ['animations:quick'] = {
    --     title = "Quick",
    --     icon = "#animation-quick",
    --     functionName = "AnimSet:Quick"
    -- },
    ['animations:wide'] = {
        title = "Wide",
        icon = "#animation-wide",
        functionName = "AnimSet:Wide"
    },
    ['animations:scared'] = {
        title = "Scared",
        icon = "#animation-scared",
        functionName = "AnimSet:Scared"
    },
    ['animations:guard'] = {
        title = "Guard",
        icon = "#animation-guard",
        functionName = "AnimSet:Guard"
    },
    ['animations:brave'] = {
        title = "Brave",
        icon = "#animation-brave",
        functionName = "AnimSet:Brave"
    },
    -- ['animations:hurry'] = {
    --     title = "Hurry",
    --     icon = "#animation-hurry",
    --     functionName = "AnimSet:Hurry"
    -- },
    ['animations:business'] = {
        title = "Business",
        icon = "#animation-business",
        functionName = "AnimSet:Business"
    },
    ['animations:tipsy'] = {
        title = "Tipsy",
        icon = "#animation-tipsy",
        functionName = "AnimSet:Tipsy"
    },
    ['animations:injured'] = {
        title = "Injured",
        icon = "#animation-injured",
        functionName = "AnimSet:Injured"
    },
    ['animations:tough'] = {
        title = "Tough",
        icon = "#animation-tough",
        functionName = "AnimSet:ToughGuy"
    },
    ['animations:sassy'] = {
        title = "Sassy",
        icon = "#animation-sassy",
        functionName = "AnimSet:Sassy"
    },
    ['animations:sad'] = {
        title = "Sad",
        icon = "#animation-sad",
        functionName = "AnimSet:Sad"
    },
    ['animations:posh'] = {
        title = "Posh",
        icon = "#animation-posh",
        functionName = "AnimSet:Posh"
    },
    ['animations:alien'] = {
        title = "Alien",
        icon = "#animation-alien",
        functionName = "AnimSet:Alien"
    },
    ['animations:nonchalant'] =
    {
        title = "Nonchalant",
        icon = "#animation-nonchalant",
        functionName = "AnimSet:NonChalant"
    },
    ['animations:hobo'] = {
        title = "Hobo",
        icon = "#animation-hobo",
        functionName = "AnimSet:Hobo"
    },
    ['animations:money'] = {
        title = "Money",
        icon = "#animation-money",
        functionName = "AnimSet:Money"
    },
    ['animations:swagger'] = {
        title = "Swagger",
        icon = "#animation-swagger",
        functionName = "AnimSet:Swagger"
    },
    ['animations:shady'] = {
        title = "Shady",
        icon = "#animation-shady",
        functionName = "AnimSet:Shady"
    },
    ['animations:maneater'] = {
        title = "Man Eater",
        icon = "#animation-maneater",
        functionName = "AnimSet:ManEater"
    },
    ['animations:chichi'] = {
        title = "ChiChi",
        icon = "#animation-chichi",
        functionName = "AnimSet:ChiChi"
    },
    ['animations:default'] = {
        title = "Default",
        icon = "#animation-default",
        functionName = "AnimSet:default"
    },

    ['k9:spawn'] = {
        title = "Summon",
        icon = "#k9-spawn",
        functionName = "K9:Create"
    },
    ['k9:delete'] = {
        title = "Dismiss",
        icon = "#k9-dismiss",
        functionName = "K9:Delete"
    },
    ['k9:follow'] = {
        title = "Follow",
        icon = "#k9-follow",
        functionName = "K9:Follow"
    },
    ['k9:vehicle'] = {
        title = "Get in/out",
        icon = "#k9-vehicle",
        functionName = "K9:Vehicle"
    },
    ['k9:sit'] = {
        title = "Sit",
        icon = "#k9-sit",
        functionName = "K9:Sit"
    },
    ['k9:lay'] = {
        title = "Lay",
        icon = "#k9-lay",
        functionName = "K9:Lay"
    },
    ['k9:stand'] = {
        title = "Stand",
        icon = "#k9-stand",
        functionName = "K9:Stand"
    },
    ['k9:sniff'] = {
        title = "Sniff Person",
        icon = "#k9-sniff",
        functionName = "K9:Sniff"
    },
    ['k9:sniffvehicle'] = {
        title = "Sniff Vehicle",
        icon = "#k9-sniff-vehicle",
        functionName = "sniffVehicle"
    },
    ['k9:huntfind'] = {
        title = "Hunt nearest",
        icon = "#k9-huntfind",
        functionName = "K9:Huntfind"
    },
    ['blips:gasstations'] = {
        title = "Gas Stations",
        icon = "#blips-gasstations",
        functionName = "CarPlayerHud:ToggleGas"
    },    
    ['blips:trainstations'] = {
        title = "Train Stations",
        icon = "#blips-trainstations",
        functionName = "Trains:ToggleTainsBlip"
    },
    ['blips:garages'] = {
        title = "Garages",
        icon = "#blips-garages",
        functionName = "Garages:ToggleGarageBlip"
    },
    ['blips:barbershop'] = {
        title = "Barber Shop",
        icon = "#blips-barbershop",
        functionName = "hairDresser:ToggleHair"
    },    
    ['blips:tattooshop'] = {
        title = "Tattoo Shop",
        icon = "#blips-tattooshop",
        functionName = "tattoo:ToggleTattoo"
    },
    ['drivinginstructor:drivingtest'] = {
        title = "Driving Test",
        icon = "#drivinginstructor-drivingtest",
        functionName = "drivingInstructor:testToggle"
    },
    ['drivinginstructor:submittest'] = {
        title = "Submit Test",
        icon = "#drivinginstructor-submittest",
        functionName = "drivingInstructor:submitTest"
    },
    ['judge-raid:checkowner'] = {
        title = "Check Owner",
        icon = "#judge-raid-check-owner",
        functionName = "appartment:CheckOwner"
    },
    ['judge-raid:seizeall'] = {
        title = "Seize All Content",
        icon = "#judge-raid-seize-all",
        functionName = "appartment:SeizeAll"
    },
    ['judge-raid:takecash'] = {
        title = "Take Cash",
        icon = "#judge-raid-take-cash",
        functionName = "appartment:TakeCash"
    },
    ['judge-raid:takedm'] = {
        title = "Take Marked Bills",
        icon = "#judge-raid-take-dm",
        functionName = "appartment:TakeDM"
    },
    ['cuffs:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "civ:cuffFromMenu"
    },
    ['cuffs:uncuff'] = {
        title = "Uncuff",
        icon = "#cuffs-uncuff",
        functionName = "police:uncuffMenu"
    },
    ['cuffs:remmask'] = {
        title = "Remove Mask Hat",
        icon = "#cuffs-remove-mask",
        functionName = "police:remmask"
    },
    ['cuffs:checkinventory'] = {
        title = "Search Person",
        icon = "#cuffs-check-inventory",
        functionName = "police:checkInventory"
    },
    ['cuffs:unseat'] = {
        title = "Unseat",
        icon = "#cuffs-unseat-player",
        functionName = "unseatPlayerCiv"
    },
    ['cuffs:checkphone'] = {
        title = "Read Phone",
        icon = "#cuffs-check-phone",
        functionName = "police:checkPhone"
    },
    ['medic:revive'] = {
        title = "Revive",
        icon = "#medic-revive",
        functionName = "revive"
    },
    ['medic:heal'] = {
        title = "Small Heal",
        icon = "#medic-heal",
        functionName = "ethical-ems:smallheal"
    },
    ['medic:heal2'] = {
        title = "Big Heal",
        icon = "#medic-heal",
        functionName = "ethical-ems:bigheal"
    },
    ['medic:stomachpump'] = {
        title = "Stomach pump",
        icon = "#medic-stomachpump",
        functionName = "ems:stomachpump"
    },
    ['police:cuff'] = {
        title = "Cuff",
        icon = "#cuffs-cuff",
        functionName = "police:cuffFromMenu"
    },
    ['police:checkbank'] = {
        title = "Check Bank",
        icon = "#police-check-bank",
        functionName = "police:checkBank"
    },
    ['police:checklicenses'] = {
        title = "Check Licenses",
        icon = "#police-check-licenses",
        functionName = "police:checkLicenses"
    },
    ['police:gsr'] = {
        title = "GSR Test",
        icon = "#police-action-gsr",
        functionName = "police:gsr"
    },
    ['open:carmenu'] = {
        title = "Car Menu",
        icon = "#police-action-carmenu",
        functionName = "open:carmenu"
    },
    ['open:carmenuems'] = {
        title = "Car Menu",
        icon = "#police-action-carmenu",
        functionName = "open:carmenuems"
    },
    ['police:dnaswab'] = {
        title = "DNA Swab",
        icon = "#police-action-dna-swab",
        functionName = "evidence:dnaSwab"
    },
    ['police:toggleradar'] = {
        title = "Toggle Radar",
        icon = "#police-vehicle-radar",
        functionName = "startSpeedo"
    },
    ['police:runplate'] = {
        title = "Run Plate",
        icon = "#police-vehicle-plate",
        functionName = "clientcheckLicensePlate"
    },

    ['judge:grantDriver'] = {
        title = "Grant Drivers",
        icon = "#judge-licenses-grant-drivers",
        functionName = "police:grantDriver"
    }, 
    ['judge:grantBusiness'] = {
        title = "Grant Business",
        icon = "#judge-licenses-grant-business",
        functionName = "police:grantBusiness"
    },  
    ['judge:grantHouse'] = {
        title = "Grant House",
        icon = "#judge-licenses-grant-house",
        functionName = "police:grantHouse"
    },
    ['judge:grantBar'] = {
        title = "Grant BAR",
        icon = "#judge-licenses-grant-bar",
        functionName = "police:grantBar"
    },
    ['judge:grantDA'] = {
        title = "Grant DA",
        icon = "#judge-licenses-grant-da",
        functionName = "police:grantDA"
    },
    ['judge:removeDriver'] = {
        title = "Remove Drivers",
        icon = "#judge-licenses-remove-drivers",
        functionName = "police:removeDriver"
    },
    ['judge:removeBusiness'] = {
        title = "Remove Business",
        icon = "#judge-licenses-remove-business",
        functionName = "police:removeBusiness"
    },
    ['judge:removeWeapon'] = {
        title = "Remove Weapon",
        icon = "#judge-licenses-remove-weapon",
        functionName = "police:removeweaponlicense"
    },
    ['judge:removeHouse'] = {
        title = "Remove House",
        icon = "#judge-licenses-remove-house",
        functionName = "police:removeHouse"
    },
    ['judge:removeBar'] = {
        title = "Remove BAR",
        icon = "#judge-licenses-remove-bar",
        functionName = "police:removeBar"
    },
    ['judge:removeDA'] = {
        title = "Remove DA",
        icon = "#judge-licenses-remove-da",
        functionName = "police:removeDA"
    },
    ['judge:denyWeapon'] = {
        title = "Deny Weapon",
        icon = "#judge-licenses-deny-weapon",
        functionName = "police:denyWeapon"
    },
    ['judge:denyDriver'] = {
        title = "Deny Drivers",
        icon = "#judge-licenses-deny-drivers",
        functionName = "police:denyDriver"
    },
    ['judge:denyBusiness'] = {
        title = "Deny Business",
        icon = "#judge-licenses-deny-business",
        functionName = "police:denyBusiness"
    },
    ['judge:denyHouse'] = {
        title = "Deny House",
        icon = "#judge-licenses-deny-house",
        functionName = "police:denyHouse"
    },
    ['news:setCamera'] = {
        title = "Camera",
        icon = "#news-job-news-camera",
        functionName = "camera:setCamera"
    },
    ['news:setMicrophone'] = {
        title = "Microphone",
        icon = "#news-job-news-microphone",
        functionName = "camera:setMic"
    },
    ['news:setBoom'] = {
        title = "Microphone Boom",
        icon = "#news-job-news-boom",
        functionName = "camera:setBoom"
    },
    ['weed:currentStatusServer'] = {
        title = "Request Status",
        icon = "#weed-cultivation-request-status",
        functionName = "weed:currentStatusServer"
    },   
    ['weed:weedCrate'] = {
        title = "Remove A Crate",
        icon = "#weed-cultivation-remove-a-crate",
        functionName = "weed:weedCrate"
    },
    ['cocaine:currentStatusServer'] = {
        title = "Request Status",
        icon = "#meth-manufacturing-request-status",
        functionName = "cocaine:currentStatusServer"
    },
    ['cocaine:methCrate'] = {
        title = "Remove A Crate",
        icon = "#meth-manufacturing-remove-a-crate",
        functionName = "cocaine:methCrate"
    },
    ["expressions:angry"] = {
        title="Angry",
        icon="#expressions-angry",
        functionName = "expressions",
        functionParameters =  { "mood_angry_1" }
    },
    ["expressions:drunk"] = {
        title="Drunk",
        icon="#expressions-drunk",
        functionName = "expressions",
        functionParameters =  { "mood_drunk_1" }
    },
    ["expressions:dumb"] = {
        title="Dumb",
        icon="#expressions-dumb",
        functionName = "expressions",
        functionParameters =  { "pose_injured_1" }
    },
    ["expressions:electrocuted"] = {
        title="Electrocuted",
        icon="#expressions-electrocuted",
        functionName = "expressions",
        functionParameters =  { "electrocuted_1" }
    },
    ["expressions:grumpy"] = {
        title="Grumpy",
        icon="#expressions-grumpy",
        functionName = "expressions", 
        functionParameters =  { "mood_drivefast_1" }
    },
    ["expressions:happy"] = {
        title="Happy",
        icon="#expressions-happy",
        functionName = "expressions",
        functionParameters =  { "mood_happy_1" }
    },
    ["expressions:injured"] = {
        title="Injured",
        icon="#expressions-injured",
        functionName = "expressions",
        functionParameters =  { "mood_injured_1" }
    },
    ["expressions:joyful"] = {
        title="Joyful",
        icon="#expressions-joyful",
        functionName = "expressions",
        functionParameters =  { "mood_dancing_low_1" }
    },
    ["expressions:mouthbreather"] = {
        title="Mouthbreather",
        icon="#expressions-mouthbreather",
        functionName = "expressions",
        functionParameters = { "smoking_hold_1" }
    },
    ["expressions:normal"]  = {
        title="Normal",
        icon="#expressions-normal",
        functionName = "expressions:clear"
    },
    ["expressions:oneeye"]  = {
        title="One Eye",
        icon="#expressions-oneeye",
        functionName = "expressions",
        functionParameters = { "pose_aiming_1" }
    },
    ["expressions:shocked"]  = {
        title="Shocked",
        icon="#expressions-shocked",
        functionName = "expressions",
        functionParameters = { "shocked_1" }
    },
    ["expressions:sleeping"]  = {
        title="Sleeping",
        icon="#expressions-sleeping",
        functionName = "expressions",
        functionParameters = { "dead_1" }
    },
    ["expressions:smug"]  = {
        title="Smug",
        icon="#expressions-smug",
        functionName = "expressions",
        functionParameters = { "mood_smug_1" }
    },
    ["expressions:speculative"]  = {
        title="Speculative",
        icon="#expressions-speculative",
        functionName = "expressions",
        functionParameters = { "mood_aiming_1" }
    },
    ["expressions:stressed"]  = {
        title="Stressed",
        icon="#expressions-stressed",
        functionName = "expressions",
        functionParameters = { "mood_stressed_1" }
    },
    ["expressions:sulking"]  = {
        title="Sulking",
        icon="#expressions-sulking",
        functionName = "expressions",
        functionParameters = { "mood_sulk_1" },
    },
    ["expressions:weird"]  = {
        title="Weird",
        icon="#expressions-weird",
        functionName = "expressions",
        functionParameters = { "effort_2" }
    },
    ["expressions:weird2"]  = {
        title="Weird 2",
        icon="#expressions-weird2",
        functionName = "expressions",
        functionParameters = { "effort_3" }
    },
    ["police:impoundsc"]  = {
        title="Impound Scuff",
        icon="#vehicle-options",
        functionName = "impoundsc",
    },

    ["police:impoundnormal"]  = {
        title="Return Vehicle",
        icon="#vehicle-options",
        functionName = "impoundVehicle",
    },

    ["police:impoundpolice"]  = {
        title="Impound Police $1500",
        icon="#vehicle-options",
        functionName = "fullimpoundVehicle",
    },

    ---------------------------------

    ["license:grantWeapon"]  = {
        title="Grant Weapon License",
        icon="#judge-licenses-grant-weapon",
        functionName = "police:giveweaponlicense",
    },
    ["license:removeweapons"]  = {
        title="Revoke Weapon License",
        icon="#judge-licenses-remove-weapon",
        functionName = "police:removeweaponlicense",
    },
    ["license:granthunting"]  = {
        title="Grant Hunting License",
        icon="#judge-licenses-grant-weapon",
        functionName = "police:givehuntinglicense",
    },
    ["license:removehunting"]  = {
        title="Revoke Hunting License",
        icon="#judge-licenses-remove-weapon",
        functionName = "police:removehuntinglicense",
    },
    ["license:grantfishing"]  = {
        title="Grant Fishing License",
        icon="#judge-licenses-grant-weapon",
        functionName = "police:givefishinglicense",
    },
    ["license:removefishing"]  = {
        title="Revoke Fishing License",
        icon="#judge-licenses-remove-weapon",
        functionName = "police:removeLicensesfish",
    }
}

RegisterNetEvent("menu:setCuffState")
AddEventHandler("menu:setCuffState", function(pTargetId, pState)
    cuffStates[pTargetId] = pState
end)


RegisterNetEvent("isJudge")
AddEventHandler("isJudge", function()
    isJudge = true
end)

RegisterNetEvent("isJudgeOff")
AddEventHandler("isJudgeOff", function()
    isJudge = false
end)

RegisterNetEvent("ethical-jobmanager:playerBecameJob")
AddEventHandler("ethical-jobmanager:playerBecameJob", function(job, name, notify)
    if isMedic and job ~= "ems" then isMedic = false end
    if isPolice and job ~= "police" then isPolice = false end
    if isDoctor and job ~= "doctor" then isDoctor = false end
    if isNews and job ~= "news" then isNews = false end
    if job == "police" then isPolice = true end
    if job == "ems" then isMedic = true end
    if job == "news" then isNews = true end
    if job == "doctor" then isDoctor = true end
    myJob = job
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)

RegisterNetEvent("drivingInstructor:instructorToggle")
AddEventHandler("drivingInstructor:instructorToggle", function(mode)
    if myJob == "driving instructor" then
        isInstructorMode = mode
    end
end)

RegisterNetEvent("police:currentHandCuffedState")
AddEventHandler("police:currentHandCuffedState", function(pIsHandcuffed, pIsHandcuffedAndWalking)
    isHandcuffedAndWalking = pIsHandcuffedAndWalking
    isHandcuffed = pIsHandcuffed
end)

RegisterNetEvent("menu:hasOxygenTank")
AddEventHandler("menu:hasOxygenTank", function(pHasOxygenTank)
    hasOxygenTankOn = pHasOxygenTank
end)

RegisterNetEvent('enablegangmember')
AddEventHandler('enablegangmember', function(pGangNum)
    gangNum = pGangNum
end)

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local closestPed = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply, 0)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        for index,value in ipairs(players) do
            local target = GetPlayerPed(value)
            if(target ~= ply) then
                local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
                local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
                if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
                    closestPlayer = value
                    closestPed = target
                    closestDistance = distance
                end
            end
        end
        return closestPlayer, closestDistance, closestPed
    end
end

trainstations = {
    {-547.34057617188,-1286.1752929688,25.3059978411511},
    {-892.66284179688,-2322.5168457031,-13.246466636658},
    {-1100.2299804688,-2724.037109375,-8.3086919784546},
    {-1071.4924316406,-2713.189453125,-8.9240007400513},
    {-875.61907958984,-2319.8686523438,-13.241264343262},
    {-536.62890625,-1285.0009765625,25.301458358765},
    {270.09558105469,-1209.9177246094,37.465930938721},
    {-287.13568115234,-327.40936279297,8.5491418838501},
    {-821.34295654297,-132.45257568359,18.436864852905},
    {-1359.9794921875,-465.32354736328,13.531299591064},
    {-498.96591186523,-680.65930175781,10.295949935913},
    {-217.97073364258,-1032.1605224609,28.724565505981},
    {113.90325164795,-1729.9976806641,28.453630447388},
    {117.33223724365,-1721.9318847656,28.527353286743},
    {-209.84713745117,-1037.2414550781,28.722997665405},
    {-499.3971862793,-665.58514404297,10.295639038086},
    {-1344.5224609375,-462.10494995117,13.531820297241},
    {-806.85192871094,-141.39852905273,18.436403274536},
    {-302.21514892578,-327.28854370117,8.5495929718018},
    {262.01733398438,-1198.6135253906,37.448017120361},
--  {2072.4086914063,1569.0856933594,76.712524414063},
    {664.93090820313,-997.59942626953,22.261747360229},
    {190.62687683105,-1956.8131103516,19.520135879517},
--  {2611.0278320313,1675.3806152344,26.578210830688},
    {2615.3901367188,2934.8666992188,39.312232971191},
    {2885.5346679688,4862.0146484375,62.551517486572},
    {47.061096191406,6280.8969726563,31.580261230469},
    {2002.3624267578,3619.8029785156,38.568252563477},
    {2609.7016601563,2937.11328125,39.418235778809}
}

enter_locations = {
	{172.78, -26.89, 68.35},
}

enter_locations2 = {
    {232.85275268555,-411.33627319336,48.10107421875},
}

enter_locations3 = {
    {237.75823974609,-413.1428527832,48.10107421875},
}

enter_locations4 = {
    {249.0989074707,-364.82638549805,-44.151611328125},
}

enter_locations5 = {
    {332.29449462891,-595.71429443359,43.282104492188},
}

enter_locations6 = {
    {330.40878295898,-601.16046142578,43.282104492188},
    {344.33407592773,-586.33843994141,28.791259765625},
}

leave_locations = {
	{-1389.412, -475.6651, 72.04217},
}

leave_locations2 = {
    {269.03735351563,-371.78900146484,-44.151611328125},
}

leave_locations3 = {
    {224.9010925293,-419.55163574219,-118.20654296875},
}

leave_locations4 = {
    {313.21319580078,-1611.3099365234,-66.7978515625},
}

leave_locations5 = {
    {345.62637329102,-582.55383300781,28.791259765625},
    {341.38021850586,-581.03735351562,28.791259765625},
}

leave_locations6 = {
    {338.61099243164,-583.81976318359,74.15087890625},
}

enterrecy_locations = {
	{746.91430664062,-1399.3055419922,26.617553710938},
}

leaverecy_locations = {
	{997.4598, -3091.976, -38.99984},
}

RegisterNetEvent('apartments:enterjobcenter2')
AddEventHandler('apartments:enterjobcenter2', function()
  DoScreenFadeOut(1)
  SetEntityCoords(PlayerPedId(), 269.03735351563,-371.78900146484,-44.151611328125)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter2')
AddEventHandler('apartments:leavejobcenter2', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),232.8659362793,-411.38900756836,48.10107421875)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:enterjobcenter3')
AddEventHandler('apartments:enterjobcenter3', function()
  DoScreenFadeOut(1)
  SetEntityCoords(PlayerPedId(),224.69010925293,-419.36703491211,-118.20654296875)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter3')
AddEventHandler('apartments:leavejobcenter3', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),237.75823974609,-413.1428527832,48.10107421875)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:enterjobcenter4')
AddEventHandler('apartments:enterjobcenter4', function()
  DoScreenFadeOut(1)
  SetEntityCoords(PlayerPedId(),313.21319580078,-1611.3099365234,-66.7978515625)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter4')
AddEventHandler('apartments:leavejobcenter4', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),249.08572387695,-364.70770263672,-44.151611328125)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:enterjobcenter5')
AddEventHandler('apartments:enterjobcenter5', function()
  DoScreenFadeOut(1)
  SetEntityCoords(PlayerPedId(),345.62637329102,-582.55383300781,28.791259765625)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter5')
AddEventHandler('apartments:leavejobcenter5', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),332.29449462891,-595.71429443359,43.282104492188)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:enterjobcenter6')
AddEventHandler('apartments:enterjobcenter6', function()
  DoScreenFadeOut(1)
  SetEntityCoords(PlayerPedId(),338.61099243164,-583.81976318359,74.15087890625)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('apartments:leavejobcenter6')
AddEventHandler('apartments:leavejobcenter6', function()
  DoScreenFadeOut(1)
  Citizen.Wait(100)
  SetEntityCoords(PlayerPedId(),330.40878295898,-601.16046142578,43.282104492188)
  DoScreenFadeIn(1000)
  Citizen.Wait(1000)
end)

RegisterNetEvent('ems:spawnshitheli')
AddEventHandler('ems:spawnshitheli', function()
    if exports["isPed"]:isPed("myJob") == 'ems' then
	    local vehicle = veh
	    local veh = GetVehiclePedIsUsing(ped)

	    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))

	    FreezeEntityPosition(ped,false)
	    RequestModel('emsair')
	    while not HasModelLoaded('emsair') do
		    Citizen.Wait(0)
	    end
	    personalvehicle = CreateVehicle('emsair',351.0725402832, -588.01318359375, 74.15087890625, 252.2834777832,true,false)
	    SetModelAsNoLongerNeeded('emsair')

	    SetVehicleOnGroundProperly(personalvehicle)

	    local plate = GetVehicleNumberPlateText(personalvehicle)
	    local id = NetworkGetNetworkIdFromEntity(personalvehicle)
	    SetNetworkIdCanMigrate(id, true)
	    Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
	    TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
	    SetEntityVisible(ped,true)			
	    TriggerEvent("keys:addNew",personalvehicle, plate)
    else
    end
end)


RegisterNetEvent('police:spawnshitheli')
AddEventHandler('police:spawnshitheli', function()
    if exports["isPed"]:isPed("myJob") == 'police' then
	    local vehicle = veh
	    local veh = GetVehiclePedIsUsing(ped)

	    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))

	    FreezeEntityPosition(ped,false)
	    RequestModel('maverick2')
	    while not HasModelLoaded('maverick2') do
		    Citizen.Wait(0)
	    end
	    personalvehicle = CreateVehicle('maverick2',449.39340209961, -981.16485595703, 43.686401367188, 87.874015808105,true,false)
	    SetModelAsNoLongerNeeded('maverick2')

	    SetVehicleOnGroundProperly(personalvehicle)

	    local plate = GetVehicleNumberPlateText(personalvehicle)
	    local id = NetworkGetNetworkIdFromEntity(personalvehicle)
	    SetNetworkIdCanMigrate(id, true)
	    Citizen.InvokeNative(0x629BFA74418D6239,Citizen.PointerValueIntInitialized(personalvehicle))
	    TaskWarpPedIntoVehicle(PlayerPedId(),personalvehicle,-1)
	    SetEntityVisible(ped,true)			
	    TriggerEvent("keys:addNew",personalvehicle, plate)
    else
    end
end)
