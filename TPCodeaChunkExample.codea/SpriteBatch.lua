-- SpriteBatch
SpriteBatch = class()

-- customization: default sprite pack for TexturePacker atlases
local _defaultSpritePack = "Documents"

-- set to true to draw debug bounding boxes
local _debugDraw = false

-- create a "sprite sheet" with a single sprite.
local function _createWithSprite(sprite)
    local delim = string.find(sprite, ":")
    local pack, spr = string.sub(sprite, 1, delim-1), string.sub(sprite, delim+1, -1)
    local w, h = spriteSize(sprite)    
    
    return SpriteBatch({
        version = 0,
        texture = { name = spr, w = w, h = h },
        frames = {
            [spr] = {
                trimmed = false,
                rotated = false,
                sourceSize = {w = w, h = h},
                frameSize = {w = w, h = h},
                uvRect = {s = 0, t = 0, tw = 1, th = 1}
            }
        }
    }, sprite)
end

-- usage: batch = SpriteBatch(sheetData [,spritePack])
--        batch = SpriteBatch("Small World:Church")
function SpriteBatch:init(sheetData, spritePack)
    spritePack = spritePack or _defaultSpritePack
    
    self.mesh = mesh()
        
    if type(sheetData) == 'table' then
        self.mesh.texture = spritePack..":"..sheetData.texture.name    
    else
        self.mesh.texture = sheetData        
        sheetData = _createWithSprite(sheetData)
    end
    
    self.frames = sheetData.frames
    
    self.indices = {}
    self.nextSprite = 1
    self.spritesLastFrame = 0 
end

local function _drawBB(x, y, w, h)
    pushStyle()
    rectMode(spriteMode())
    fill(255, 255, 255, 64)
    rect(x, y, w, h)
    popStyle()
end

-- usage: identical to Codea's sprite() function:
--    batch:sprite(spriteName)
--    batch:sprite(spriteName, x, y)
--    batch:sprite(spriteName, x, y, w)
--    batch:sprite(spriteName, x, y, w, h)
--    batch:sprite(spriteName, x, y, s, t, tw, th)
--    batch:sprite(spriteName, x, y, s, t, tw, th, w)
--    batch:sprite(spriteName, x, y, s, t, tw, th, w, h)
function SpriteBatch:sprite(spriteName, x, y, s, t, tw, th, w, h)
    local frame = self.frames[spriteName]
    local rotated = frame.rotated    
    local sourceSize = frame.sourceSize
    local ow, oh = sourceSize.w, sourceSize.h    
    local size = frame.frameSize
    local fw, fh, uv = size.w, size.h
    
    -- defaults for x and y
    x, y = x or 0, y or 0
    
    -- swap fw and fh if frame is rotated
    if rotated then fw, fh = fh, fw end    
    
    -- parse s, t, u, v, w, h args
    if s == nil then
        uv = frame.uvRect
        w, h = fw, fh        
    elseif tw == nil then
        uv = frame.uvRect
        w, h = s, t        
    else
        local fuv = frame.uvRect
        uv = {s=fuv.s+(s*fuv.tw), t=fuv.t+(t*fuv.th), tw=tw*fuv.tw, th=th*fuv.th}
    end

    if not w then
        w, h = fw, fh
    else
        local nw = w
        local nh = h or oh*(nw/ow)
        ow, oh, w, h = nw, nh, fw*(nw/ow), fh*(nh/oh)        
    end

    -- add a new rect to our mesh if necessary
    local mesh, indices, idx = self.mesh, self.indices    
    if self.nextSprite > #indices then
        idx = mesh:addRect(0, 0, 0, 0, 0)
        table.insert(indices, idx)
    else
        idx = indices[self.nextSprite]
    end
    
    -- move to the next sprite index
    self.nextSprite = self.nextSprite + 1
    
    -- draw bounding box if debug draw is enabled
    if _debugDraw then
        _drawBB(x, y, ow, oh) 
    end
    
    -- use current sprite mode to determine sprite anchoring
    local mode = spriteMode()    
    if mode == CENTER then
        x, y = x-w*0.5, y-h*0.5
    else
        if frame.trimmed then
            x, y = x+(ow-w)*0.5, y+(oh-h)*0.5
        end
        
        if mode == CORNERS then
            if x > w then x, w = w, x end
            if y > h then y, h = h, y end
            w, h = w-x, h-y
        elseif mode == RADIUS then
            x, y, w, h = x-ow, y-oh, w*2, h*2
        end
    end
    
    -- use current model matrix to transform verts
    local m = modelMatrix()    
    local m1, m2, m5, m6, m13, m14 =
          m[1], m[2], m[5], m[6], m[13], m[14]
    
    -- pre-calculate transform data
    local x1, y1 = x+w, y+h    
    local m1x, m1x1 = m1*x, m1*x1
    local m5y, m5y1 = m5*y, m5*y1
    local m2x, m2x1 = m2*x, m2*x1
    local m6y, m6y1 = m6*y, m6*y1    

    -- create transformed verts
    local ax, ay = m1x+m5y1+m13, m2x+m6y1+m14
    local bx, by = m1x+m5y+m13, m2x+m6y+m14
    local cx, cy = m1x1+m5y+m13, m2x1+m6y+m14    
    local dx, dy = m1x1+m5y1+m13, m2x1+m6y1+m14
    
    -- rotate verts ccw if frame is rotated
    if rotated then
        ax, ay, bx, by, cx, cy, dx, dy =
        bx, by, cx, cy, dx, dy, ax, ay
    end
    
    -- submit the verts to the mesh
    local begin = (idx-1) * 6
    mesh:vertex(begin+1, ax, ay)
    mesh:vertex(begin+2, bx, by)
    mesh:vertex(begin+3, cx, cy)
    mesh:vertex(begin+4, ax, ay)
    mesh:vertex(begin+5, cx, cy)
    mesh:vertex(begin+6, dx, dy)   

    -- submit uv coords to the mesh
    mesh:setRectTex(idx, uv.s, uv.t, uv.tw, uv.th)
    
    -- submit vert colors to mesh from current tint()
    mesh:setRectColor(idx, tint())
end

function SpriteBatch:spriteSize(spriteName)
    local frame = self.frames[spriteName]
    local size = frame.sourceSize
    return size.w, size.h
end

function SpriteBatch:frameSize(spriteName)
    local frame = self.frames[spriteName]
    local size = frame.frameSize
    
    if frame.rotated then
        return size.h, size.w
    end
    
    return size.w, size.h
end

function SpriteBatch:spriteList()
    local t = {}
    
    for k in pairs(self.frames) do
        table.insert(t, k)
    end
    
    return t
end

function SpriteBatch:draw()
    local indices = self.indices
    
    -- zero out unused sprites
    for i = self.nextSprite, self.spritesLastFrame do
        self.mesh:setRect(indices[i], 0, 0, 0, 0, 0)
    end
    
    self.mesh:draw()
    
    -- reset for next frame
    self.spritesLastFrame = self.nextSprite - 1
    self.nextSprite = 1
end
