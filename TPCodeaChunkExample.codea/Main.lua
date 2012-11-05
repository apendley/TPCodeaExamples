-- pickle

tp = tp or {}

local _spriteSheetURL =
"https://raw.github.com/apendley/TPCodeaExamples/master/assets/chunk/SmallWorldSprites.lua"

function setup()
    -- uncomment this to re-download and save sprite sheet data
    --clearProjectData()
    
    -- attempt to grab sprite sheet from project data
    local sheet = pickle.load("SmallWorldSprites")
    
    if sheet then
        print("sprite sheet Found!")
        tp["SmallWorldSprites"] = sheet
        spriteSheet = tpBatch(tp["SmallWorldSprites"])        
    else
        print("Downloading sprite sheet...")
        http.request(_spriteSheetURL, function(data, status, headers)
            if status == 200 then
                local object = assert(loadstring(data))()
                tp["SmallWorldSprites"] = object
                pickle.dump(object, "SmallWorldSprites")
                spriteSheet = tpBatch(object)
                print("Sprite sheet data downloaded")
            else
                print("Failed to download sprite sheet data")
            end
        end)
    end
end

function draw()
    background(0)
    
    if not spriteSheet then return end
    
    local sprites = {
        "Base Large",
        "Beam",
        "Church",
        "Court",
        "Explosion"
    }
    
    local x = 0
    for i,spr in ipairs(sprites) do
        local w, h = spriteSheet:spriteSize(spr)
        spriteSheet:sprite(spr, x+w/2, HEIGHT/2)
        x = x + w
    end
    
    spriteSheet:draw()
end

