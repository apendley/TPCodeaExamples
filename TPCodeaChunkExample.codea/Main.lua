-- TPCodeaChunkExample

local _frameDataURL =
"https://raw.github.com/apendley/TPCodeaExamples/master/assets/chunk/SmallWorldSprites.lua"

local function createBatchRenderer(object)
    spriteSheet = tpBatch(object)
end

function setup()
    -- uncomment this to force download and save of frame data
    --clearProjectData()
    
    -- attempt to grab frame data from project data
    local frameData = pickle.load("SmallWorldSprites")
    
    if frameData then
        print("Frame data found!")
        createBatchRenderer(frameData)
    else
        print("Downloading frame data...")
        http.request(_frameDataURL, function(data, status, headers)
            if status == 200 then
                local object = assert(loadstring(data))()
                pickle.dump(object, "SmallWorldSprites")
                createBatchRenderer(object)
                print("Frame data downloaded")
            else
                print("Failed to download frame data")
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

