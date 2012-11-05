-- TPExample

function setup()
    spriteSheet = tpBatch(tp.SmallWorldSprites)
end


function draw()
    background(0)
    
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

