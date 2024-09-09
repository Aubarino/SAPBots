AddCSLuaFile()

local characterLimit = 126

local sapbotChatLogCount = 0
function SapLLMPersonalityGen(corruption)
    local toPickNam = "modern gamer"
    for nam,value in RandomPairs(_SapLLMPersonalConvert) do
        if (value >= 0.5) then
            if (corruption > value) then
                toPickNam = nam
                break
            end
        else
            if (corruption < value) then
                toPickNam = nam
                break
            end
        end
    end
    return(toPickNam)
end

function SapGenPrompt(sap,triggerString,triggerContext,notes,canVote) --gen the prompt to send
    local opinionsGen = ""
    local maxRange = 0
    for nam,opin in RandomPairs(sap.OpinionOnEnts) do
        if (maxRange > 32 || opinionsGen == nil || nam == nil || opin == nil || opin[1] == nil) then continue end --hard coded limit so opinions dont overflow, its random picked so there is high chance the ones looped over will be good enough
        opinionsGen = opinionsGen..nam..":"..opin[1]..","
        maxRange = maxRange + 1
    end
    local personalityGen = (
        "chill:"..sap.Sap_IPF_chill..",strict:"..sap.Sap_IPF_strict..",calm:"..sap.Sap_IPF_calm..",paranoid:"..sap.Sap_IPF_paranoid..
        ",innocence:"..sap.Sap_SM_innocence..",corruption:"..sap.Sap_SM_corruption..",openminded:"..sap.Sap_SM_openminded..",closeminded:"..sap.Sap_SM_closeminded)
    
        sapbotChatLogCount = #_Sapbot_ChatlogALL
    if (_Sapbot_ChatlogALL != nil) then
        triggerContext = triggerContext.." CHAT HISTORY OF YOU AND OTHERS:"
        for i = 0,-5, -1 do
            if !(sapbotChatLogCount - i < 1) then
                if (_Sapbot_ChatlogALL[sapbotChatLogCount - i] == nil) then continue end
                --print("chat from "..i.." ago :".._Sapbot_ChatlogALL[sapbotChatLogCount - i])
                triggerContext = triggerContext.." "..(i * -1).." message(s) ago ".._Sapbot_ChatlogALL[sapbotChatLogCount - i]..","
            end
        end
        triggerContext = triggerContext.." DO NOT DIRECTLY MIMICK PREVIOUS MESSAGES."
    end
    return(SapGenBasePrompt(sap.Sap_Name,triggerString,triggerContext,opinionsGen,personalityGen,sap.Stress,notes,canVote))
end

function SapGenBasePrompt(name,trigger,context,opinions,personality,stress,notes,canVote)
    local sapGenExtra = ""
    if (canVote) then --makes them able to vote
        if (sapVoteActive) then
            local usernameVote = sapVoteInfo.sapVoteUser
            if (usernameVote == name) then usernameVote = "YOU!" end
            sapGenExtra = 'VOTES : (vote kick going on against '..sapVoteInfo.sapVoteUser..', with yes:'..sapVoteInfo.sapVoteYes..' no:'..sapVoteInfo.sapVoteYes..' ADD THIS EXACT MESSAGE OF "[VVG::*yes]" OR "[VVG::*no]" TO YOUR OUTPUT TO VOTE!)'
        else
            --print("vote kick in prompt!")
            sapGenExtra = 'VOTES : (No vote kick active, YOU CAN CAST A VOTE BY DOING THIS EXACT FORMAT "[VVG::*NAME]" WITH "NAME" BEING THE USER, IN YOUR CHAT MESSAGE)'
        end
    end
    return(
        [[YOU ARE THE API OF A GMOD ADDON's FAKE PLAYER BOTS.
        YOUR OUTPUT MUST BE A SHORT STRING OF YOUR CHAT RESPONSE IN UNDER ]]..characterLimit..[[ CHARACTERS, YOUR OPINION OUTPUT CAN BE OVER THE CHARACTER LIMIT.
        INCLUDE FORMATTED OPINION MODIFICATIONS IN THIS FORMAT "(]]..opinions..[[)", BUT ONLY INCLUDE WHAT OPINIONS YOU WANT TO CHANGE, NOT IN THE NORMAL CHAT MESSAGE PART!
        EXAMPLE "RESPONSE (TARGET ENTITY:CHANGED OPINION) [something extra if available]"
        YOU ARE NOT A ASSISTANT, YOU ARE A SAP BOT FAKE PLAYER, YOU THINK YOU ARE REAL.
        YOU WILL ACT EXACTLY ACCORDING TO YOUR PROVIDED PERSONALITY AND DATA, ONLY RESPOND IN THIS FORMAT!
        You will be given your opinions of entities, lower means you are attacking them or fleeing.
        Personality values have a min of -1 and max of 1, lots of corruption value means they are a toxic gamer who swears a lot and is nasty, innocence is the opposite.
        The closer the Stress value to 1, the more likely you are attacking or fleeing currently.
        You will also be given context for the chat event trigger.

        You are provided...

        YOUR NAME : (]]..name..[[)
        TRIGGER : (]]..trigger..[[)
        PERSONALITY : (]]..personality..[[)
        CHARACTER NOTES : (]]..notes..[[)
        DO NOT MENTION Possible Chaotic Inspiration, Do not directly mimick 'Possible Chaotic Inspiration' or the topics within it, as it is nonsensical.
        TRIGGER CONTEXT : (]]..context..[[)
        OPINIONS : (]]..opinions..[[)
        STRESS : (]]..stress..[[)
        ]]..sapGenExtra
    )
end

local char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
end

local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end

local urlencode = function(url)
    if url == nil then
        return
    end
    url = url:gsub("[\n\r]+", " ")
    url = url:gsub(" ", "+")
    url = url:gsub("%%(%x%x)", hex_to_char)
    return url
end
local function decodeUrlExtra(url) --scuffed nightmare lol, have fun looking at this, whoever found their way into the ai net lua file
    return url:gsub("%%(%x%x)", function(hex)
        return string.char(tonumber(hex, 16))
    end):gsub("\\u(%x%x%x%x)", function(unicode)
        return utf8.char(tonumber(unicode, 16))
    end)
end
local function urldecode(url)
    if url == nil then
        return
    end
    url = url:gsub("+", " ")
    url = url:gsub("%%(%x%x)", hex_to_char)
    return decodeUrlExtra(url)
end

sapAINetQueue = {}
local sapAINetQueueAmt = 0
local promptTemp = ""
local nextPromptTime = 0
sapAiNetWaitTime = 0

function queueAINetPromptForSapSay(sap,triggerString,triggerContext,notes,canVote)
    if (sapAINetQueue == nil) then sapAINetQueueAmt = 0 else
        sapAINetQueueAmt = #sapAINetQueue
    end
    promptTemp = SapGenPrompt(sap,triggerString,triggerContext,notes,canVote)
    if (sapAINetQueueAmt < 10) then
        table.insert(sapAINetQueue,{
            ["prompt"] = promptTemp,
            ["sap"] = sap.Sap_Name
        })
    else
        --print("sapAINetQueueAmt over 10 hard limit, skipping prompt")
    end
    processAINetChat()
end

local processAiNetOffset = 0
function processAINetChat()
    if (sapAINetQueueAmt < 1) then return end
    if (CurTime() > nextPromptTime) then
        processAiNetOffset = 0
        nextPromptTime = CurTime() + 2
        --PrintTable(sapAINetQueue)
        if (_SAPBOTSNAMES != nil && sapAINetQueue != nil && sapAINetQueueAmt != nil && sapAINetQueue[sapAINetQueueAmt] != nil && sapAINetQueue[sapAINetQueueAmt]["sap"] != nil) then
            while (_SAPBOTSNAMES[sapAINetQueue[sapAINetQueueAmt]["sap"]] == nil && sapAINetQueueAmt > 0) do
                --print("removed for ("..sapAINetQueue[sapAINetQueueAmt]["sap"]..")")
                table.remove(sapAINetQueue,sapAINetQueueAmt)
                sapAINetQueueAmt = #sapAINetQueue
                if !(_SAPBOTSNAMES != nil && sapAINetQueue != nil && sapAINetQueueAmt != nil && sapAINetQueue[sapAINetQueueAmt] != nil && sapAINetQueue[sapAINetQueueAmt]["sap"] != nil) then break end
            end
            if (sapAINetQueue != nil && sapAINetQueue[sapAINetQueueAmt] != nil && sapAINetQueue[sapAINetQueueAmt]["prompt"] != nil && sapAINetQueue[sapAINetQueueAmt] != nil && sapAINetQueue[sapAINetQueueAmt]["sap"] != nil) then
                sapSendPrompt(sapAINetQueue[sapAINetQueueAmt]["prompt"],sapAINetQueue[sapAINetQueueAmt]["sap"])
                table.remove(sapAINetQueue,sapAINetQueueAmt)
            end
        end
    end
end

local function getTimeout(str)
    if (str:match("Please try again in (%d+%.?%d*)ms") == nil) then
        return (str:match("Please try again in (%d+%.?%d*)s"))
    else
        return (str:match("Please try again in (%d+%.?%d*)ms") * 0.001)
    end
end

--FUCK THIS, FUCK IT, FUCK MY LAST ATTEMPT, FUCK BRUTE FORCING IT, EW EW
-- function sapSendPrompt(prompt,sap)
--     local formattedPrompt = urlencode(prompt)
--     --print("prompt:"..formattedPrompt)
--     HTTP( {
--         failed = function( reason )
--             --print( "HTTP request failed", reason )
--         end,
--         success = function( code, body, headers )
--             --print( "HTTP request succeeded", code, body, headers )
--             print(body)
--             if (sap != nil) then
--                 sap:SapTrueSay(extractLogString(body),0,true)
--             else
--                 print("AI queue got, but sap bot is nil?")
--             end
--         end,
--         method = "GET",
--         url = [[https://chatgptfree.ai/wp-admin/admin-ajax.php?post_id=6&url=https%3A%2F%2Fchatgptfree.ai&action=wpaicg_chat_shortcode_message&message=]]..formattedPrompt..[[%0A&bot_id=0&chatbot_identity=shortcode&wpaicg_chat_client_id=H6XriHGCiW&wpaicg_chat_history=%5B%22Human%3A+]]..formattedPrompt..[[%22%5D]]
--     } )

--     --string.match("Hello Stackoverflow guys", [["data":"(%a+)","log":]])
-- end

--sendPrompt("YOU ARE AN API FOR A GMOD ADDON THAT ADDS FAKE PLAYERS, YOU ARE TYPING AN IDLE MESSAGE IN CHAT IN UNDER 128 CHARACTERS",nil)

function numsInStringToInt(stringIn)
    stringIn = stringIn:gsub("%d+%.?%d*", function(match)
        return math.floor(tonumber(match))
    end)
    return(stringIn)
end

function processOutPrompt(tableIn)
    --PrintTable(tableIn)
    if (tableIn["error"] != nil) then
        local timeoutVal = getTimeout(tableIn["error"]["message"])
        if (timeoutVal != nil) then
            sapAiNetWaitTime = (CurTime() + 0.1 + getTimeout(tableIn["error"]["message"]))
            --print("cooldown time of Ai net : "..(sapAiNetWaitTime - CurTime()).." seconds.")
        end
        return("error: "..tableIn["error"]["type"].." "..tableIn["error"]["message"])
    end
    if (tableIn["choices"] == nil) then
        return("error no choices for AI prompt out")
    end
    --print("test with "..tableIn["choices"][1]["message"]["content"])
    return(tableIn["choices"][1]["message"]["content"])
end

local tosayTemp = ""
local sapEntity = nil

function sapAiNetOpinionChange(inString,sapent)
    if (inString == nil || sapent == nil) then return end
    local tbl = {}
    for match in inString:gmatch("([^,]+)") do
        table.insert(tbl, match)
    end

    for _, v in ipairs(tbl) do
        local name, num = v:match("([^:]+):([^,]+)")
        if (name != nil && num != nil) then
            if name and num then
                sapent.OpinionOnEnts[name] = {tonumber(num),CurTime()}
            end
        end
    end
    if (#tbl > 0) then
        print(sapent.Sap_Name.." changed opinions via AI Net")
    end
end

function sapProcessPromptExtras(stringIn,sapent)
    if (sapent == nil) then return(stringIn) end
    local voteName = stringIn:match("%[VVG::(%a+)%]")
    if voteName then
        voteName = voteName:gsub("%*", "")
        if (SERVER) then
            if (voteName == "yes") then
                sapent.Fun_VotekickedAlready = true
                sapVoteYes()
                net.Start("sapVoteYes")
                net.Broadcast()
            elseif (voteName == "no") then
                sapent.Fun_VotekickedAlready = true
                sapVoteNo()
                net.Start("sapVoteNo")
                net.Broadcast()
            else
                sapent.Fun_VotekickedAlready = true
                sapVoteKickStart(voteName)
            end
        end
    end
    stringIn = (stringIn:gsub("%[[VVG::%a+]", "")):gsub("%*", "")
    
    return(stringIn)
end

function sapSendPrompt(prompt,sap)
    if (CLIENT) then return end
    local formattedPrompt = prompt
    --print("DOING!!!!!!!!!!!!!!!!!")
    --print("prompt:"..formattedPrompt)
    if (sapAiNetWaitTime <= CurTime()) then
        HTTP( {
            failed = function(reason)
                print("AI HTTP request failed, try running the version of gmod that is good with HTTP stuff if you are not already.", reason)
            end,
            success = function(code, body, headers)
                sapEntity = nil
                --print("looking for "..sap)
                sapEntity = _SAPBOTSNAMES[sap]
                
                if (sapEntity != nil) then
                    --print("SapAINet valid entity SapTrueSay status : "..tostring(sapEntity.SapTrueSay == nil))
                    tosayTemp = processOutPrompt(util.JSONToTable(body))
                    if (sapAiNetWaitTime > CurTime()) then
                        print("cannot say message due to cooldown of ai net for "..(sapAiNetWaitTime - CurTime()).." seconds.")
                    else
                        tosayTemp = tosayTemp:gsub('"', '')
                        sapAiNetOpinionChange(tosayTemp:match("%(([^)]+)%)"),sapEntity)
                        tosayTemp = sapProcessPromptExtras(tosayTemp:gsub("%b()", ""),sapEntity)
                        --print("to say : "..tosayTemp)
                        SapTrueSay(sapEntity,tosayTemp,0,true)
                    end
                else
                    print("AI queue got, but sap bot is nil?, this will resolve eventually")
                end
            end,
            method = "POST",
            headers = {
                ["Authorization"] = "Bearer " .. SAPAINETKEY,
                ["Content-Type"] = "application/json"
            },
            body = numsInStringToInt(util.TableToJSON({
                ["model"] = "llama3-70b-8192",
                ["messages"] = {{
                    ["role"] = "system",
                    ["content"] = prompt
                }},
                ["max_tokens"] = 64,
                ["temperature"] = 0.5
            })),
            url = "https://api.groq.com/openai/v1/chat/completions"
        })
    else
        print("Cannot AI queue send prompt, due to cooldown of ai net for "..(sapAiNetWaitTime - CurTime()).." seconds.")
    end
end