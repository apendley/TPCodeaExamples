-- tpBatch
tpBatch = class()

-- customization: default sprite pack for TexturePacker atlases
local _defaultSpritePack = "Documents"

-- set to true to draw debug bounding boxes
local _debugDraw = false

-- usage: batch = tpBatch(atlasData [,spritePack])
function tpBatch:init(atlasData, spritePack)
    spritePack = spritePack or _defaultSpritePack
    
    self.mesh = mesh()
    self.mesh.texture = spritePack..":"..atlasData.texture.name
    self.frames = atlasData.frames
    
    self.indices = {}
    self.nextSprite = 1
    self.spritesLastFrame = 0 
end

local function _drawBB(self, x, y, w, h)
    pushStyle()
    rectMode(spriteMode())
    fill(255, 255, 255, 128)
    rect(x, y, w, h)
    popStyle()
end

-- usage: batch:sprite(spriteName)
--        batch:sprite(spriteName, x, y)
--        batch:sprite(spriteName, x, y, w)
--        batch:sprite(spriteName, x, y, w, h)
function tpBatch:sprite(spriteName, x, y, w, h)
    local frame = self.frames[spriteName]
    local rotated = frame.rotated    
    local sourceSize = frame.sourceSize
    local ow, oh = sourceSize.w, sourceSize.h    
    local size = frame.frameSize
    local fw, fh = size.w, size.h
    
    x, y = x or 0, y or 0
    
    if rotated then fw, fh = fh, fw end    
    
    -- modify scale based on presence/absense of w/h parameters
    if not w then 
        w, h = fw, fh 
    else 
        if h then
            local nw, nh = w, h
            ow, oh, w, h = nw, nh, fw*(nw/ow), fh*(nh/oh)
        else
            local origWidth, nw = ow, w
            local nh = oh * (nw/origWidth)
            ow, oh, w, h = nw, nh, fw*(nw/ow), fh*(nh/oh)
        end
    end

    -- create a new rect in our mesh if we need one
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
        _drawBB(self, x, y, ow, oh) 
    end
    
    -- use current sprite mode to determine sprite anchoring
    local mode = spriteMode()    
    if mode == CENTER then
        x = x - w*0.5
        y = y - h*0.5        
    else
        if frame.trimmed then
            x = x + (ow-w) * 0.5
            y = y + (oh-h) * 0.5
        end
        
        if mode == CORNERS then
            if x > w then x, w = w, x end
            if y > h then y, h = h, y end
            w = w - x
            h = h - y    
        elseif mode == RADIUS then
            x = x - ow
            y = y - oh
            w = w * 2
            h = h * 2        
        end
    end
    
    -- use current model matrix to transform verts
    local m = modelMatrix()    
    local m1, m2, m5, m6, m13, m14 = m[1], m[2], m[5], m[6], m[13], m[14]
    
    -- transform verts
    local x1, y1 = x+w, y+h    
    local m1x, m1x1 = m1*x, m1*x1
    local m5y, m5y1 = m5*y, m5*y1
    local m2x, m2x1 = m2*x, m2*x1
    local m6y, m6y1 = m6*y, m6*y1    

    local ax, ay = m1x+m5y+m13, m2x+m6y+m14
    local bx, by = m1x+m5y1+m13, m2x+m6y1+m14
    local cx, cy = m1x1+m5y1+m13, m2x1+m6y1+m14
    local dx, dy = m1x1+m5y+m13, m2x1+m6y+m14

    local verts
    if rotated 
        then verts = {{ax, ay}, {dx, dy}, {cx, cy}, {bx, by}}
        else verts = {{bx, by}, {ax, ay}, {dx, dy}, {cx, cy}} 
    end
    
    -- assign transformed verts to mesh
    local first, v = (idx - 1) * 6 + 1
    v = verts[1]  mesh:vertex(first+0, v[1], v[2]) 
    v = verts[2]  mesh:vertex(first+1, v[1], v[2])
    v = verts[3]  mesh:vertex(first+2, v[1], v[2])
    v = verts[1]  mesh:vertex(first+3, v[1], v[2])
    v = verts[3]  mesh:vertex(first+4, v[1], v[2])
    v = verts[4]  mesh:vertex(first+5, v[1], v[2])    
    
    -- set up uv coords
    local uv = frame.uvRect
    mesh:setRectTex(idx, uv.s, uv.t, uv.tw, uv.th)
    
    -- set up vert colors from tint()
    mesh:setRectColor(idx, tint())
end

function tpBatch:spriteSize(spriteName)
    local frame = self.frames[spriteName]
    local size = frame.sourceSize
    return size.w, size.h
end

function tpBatch:frameSize(spriteName)
    local frame = self.frames[spriteName]
    local size = frame.frameSize
    
    if frame.rotated then
        return size.h, size.w
    end
    
    return size.w, size.h
end

function tpBatch:draw()
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
