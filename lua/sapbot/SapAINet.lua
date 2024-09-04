AddCSLuaFile()

local characterLimit = 126

local promptGenBase = [[YOU ARE A API for the chat interactions of some player bots in a garry's mod addon.
YOUR OUTPUT MUST BE A SHORT STRING OF YOUR CHAT RESPONSE IN UNDER ]]..characterLimit..[[ CHARACTERS, YOUR OPINION OUTPUT CAN BE OVER THE CHARACTER LIMIT THOUGH.
FORMATT YOUR OPINION MODIFICATIONS AS DEFINED BELOW! FOLLOW THESE EXACTLY! BE SIMPLE AND QUICK!
YOU ARE NOT CHAT GPT, YOU ARE A SAP BOT FAKE PLAYER THAT THINKS THEY ARE REAL,
YOU WILL ACT EXACTLY ACCORDING TO YOUR PROVIDED DATA, AND ONLY RESPOND IN THIS FORMAT!!!
You will be given your opinions of entities, lower means you either are attacking them or fleeing.
Personality values have a min of -1 and max of 1, lots of corruption value means they are a toxic gamer who swears a lot and is nasty, innocence is the opposite.
The closer the Stress value to 1, the more likely you are attacking or fleeing currently.
You will also be given context for the chat event trigger.
You may also include modifications to your opinions in your output, an example being : "[aub:1,combine_soldier:-1]".

You are provided...

YOUR NAME : bobby
TRIGGER : Idle chat
TRIGGER CONTEXT : replying to "aub: bobby sucks lol, he never attacks us at all"
OPINIONS : [aub:2,combine_solider:-1]
PERSONALITY : [corruption:0.5,innocense:1,openminded:0,closeminded:1,chill:-1,paranoid:1]
STRESS : 0.1
NOTES : swear a lot! you swear lots! you talk in mostly nasty words]]

function SapGenPrompt(sap,triggerString,triggerContext,notes) --gen the prompt to send
    local opinionsGen = ""
    local maxRange = 0
    for nam,opin in RandomPairs(sap.OpinionOnEnts) do
        if (maxRange > 32) then continue end --hard coded limit so opinions dont overflow, its random picked so there is high chance the ones looped over will be good enough
        opinionsGen = opinionsGen..nam..":"..opin[1]..","
        maxRange = maxRange + 1
    end
    local personalityGen = (
        "chill:"..sap.Sap_IPF_chill..",strict:"..sap.Sap_IPF_strict..",calm:"..sap.Sap_IPF_calm..",paranoid:"..sap.Sap_IPF_paranoid..
        ",innocence:"..sap.Sap_SM_innocence..",corruption:"..sap.Sap_SM_corruption..",openminded:"..sap.Sap_SM_openminded..",closeminded:"..sap.Sap_SM_closeminded)
    return(SapGenBasePrompt(sap.Sap_Name,triggerString,triggerContext,opinionsGen,personalityGen,sap.Stress,notes))
end

function SapGenBasePrompt(name,trigger,context,opinions,personality,stress,notes)
    return(
        [[YOU ARE A API for the chat interactions of some player bots in a garry's mod addon.
        YOUR OUTPUT MUST BE A SHORT STRING OF YOUR CHAT RESPONSE IN UNDER ]]..characterLimit..[[ CHARACTERS, YOUR OPINION OUTPUT CAN BE OVER THE CHARACTER LIMIT THOUGH.
        FORMATT YOUR OPINION MODIFICATIONS AS DEFINED BELOW! FOLLOW THESE EXACTLY! BE SIMPLE AND QUICK!
        YOU ARE NOT CHAT GPT, YOU ARE A SAP BOT FAKE PLAYER THAT THINKS THEY ARE REAL,
        YOU WILL ACT EXACTLY ACCORDING TO YOUR PROVIDED DATA, AND ONLY RESPOND IN THIS FORMAT!!!
        You will be given your opinions of entities, lower means you either are attacking them or fleeing.
        Personality values have a min of -1 and max of 1, lots of corruption value means they are a toxic gamer who swears a lot and is nasty, innocence is the opposite.
        The closer the Stress value to 1, the more likely you are attacking or fleeing currently.
        You will also be given context for the chat event trigger.
        You may also include modifications to your opinions in your output, an example being : "(]]..opinions..[[)".

        You are provided...

        YOUR NAME : (]]..name..[[)
        TRIGGER : (]]..trigger..[[)
        TRIGGER CONTEXT : (]]..context..[[)
        OPINIONS : (]]..opinions..[[)
        PERSONALITY : (]]..personality..[[)
        STRESS : (]]..stress..[[)
        NOTES : (]]..notes..")"
    )
end

local char_to_hex = function(c)
    return string.format("%%%02X", string.byte(c))
end

-- local function urlencode(url)
-- if url == nil then
--     return
-- end
-- url = url:gsub("\n", "\r\n")
-- url = url:gsub("([^%w ])", char_to_hex)
-- url = url:gsub(" ", "+")
-- return url
-- end

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

function extractLogString(input)
    local startIdx, endIdx = input:find('"data":"')
    if startIdx then
        local nextStartIdx = input:find('"log":false', endIdx)
        if nextStartIdx then
            return urldecode(string.sub(input,startIdx + 8,nextStartIdx - 3))
        end
    end
    return "error"
end

function queueAINetPromptForSapSay(sap,triggerString,triggerContext,notes)
    sendPrompt(SapGenPrompt(sap,triggerString,triggerContext,notes),sap)
end

function sendPrompt(prompt,sap) --i fucking give up
    local formattedPrompt = urlencode(prompt)
    --print("prompt:"..formattedPrompt)
    HTTP( {
        failed = function( reason )
            --print( "HTTP request failed", reason )
        end,
        success = function( code, body, headers )
            --print( "HTTP request succeeded", code, body, headers )
            print(body)
            if (sap != nil) then
                sap:TrueSay(extractLogString(body),0,true)
            else
                print("AI queue got, but sap bot is nil?")
            end
        end,
        method = "GET",
        url = [[https://chatgptfree.ai/wp-admin/admin-ajax.php?post_id=6&url=https%3A%2F%2Fchatgptfree.ai&action=wpaicg_chat_shortcode_message&message=]]..formattedPrompt..[[%0A&bot_id=0&chatbot_identity=shortcode&wpaicg_chat_client_id=H6XriHGCiW&wpaicg_chat_history=%5B%22Human%3A+]]..formattedPrompt..[[%22%5D]]
    } )

    --string.match("Hello Stackoverflow guys", [["data":"(%a+)","log":]])
end

-- local glemath = {}
--         for word in line:gmatch("%S+") do --grab all the words
--             table.insert(glemath,word)
--         end