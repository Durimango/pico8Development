---------------------------debugging----------
-- echoes collection
echoes = {}

-- store a value to be printed
function echo(val)
  add(echoes,tostr(val))
end

-- print all echoes
-- ...opt: c (text color, default: latest)
-- ...opt: x,y (print coords)
function print_echoes(c, x, y)
	local cx, cy, cc = cam.X, cam.Y, 0  --pen_x, pen_y, pen_color

	--set text position and color
	cursor(x or cx, y or cy, c or cc)
	for i=1,#echoes do
		print(tostr(echoes[i]))
	end

	--erase all echoes
	echoes = {}
end
-------------------------------------------------

-- optional: label (header caption)
function echo_tbl(tbl, label)
	if type(tbl) == "table" then
		add(echoes,"--")
		add(echoes,"[ " .. (label or "unlabeled") .. " ]")
		add(echoes,"")
		--
		for k,v in pairs(tbl) do
			add(echoes,("+ " .. k .. ": " .. tostr(v)))
		end
		--
		add(echoes,"--")
	end
end



function _init()

    palt(0,false)
    palt(11,true)
    _initPlayer()
    _initEquipment()

--fish table
    fishes = {}
end

function _update()
    _move()
    _updateEquipment()
    _updatePlrPosition()
    _updateCastPosition()
    _castEquipment()
    _fishSpawner()

--fish culling
    --foreach(fishes, _fishDeleter)

--fish table update
    for fish in all(fishes) do
        fish:update()
        if fish.kill == true then
            fish:delete()
        end
    end

    --camera object--

    cam = {
        X=plr.X-55,
        Y=plr.Y-55
    }

    echo_tbl(fishes[1])
end

function _draw()
    cls(12)
    camera(cam.X,cam.Y)
    
    --fish table update
    for fish in all(fishes) do
        fish:draw()
    end

    --spr(16, 32, 15)
    _drawOrder()
    
--debugging
    --print(debugger.X, cam.X, cam.Y)
    print_echoes()
end


function _initPlayer()

--player object--

    plr = {
        sp=32,
        X=0,
        Y=0,
        flipX = false,
        flipY = false,
        speedModifier = 1,
        speed = 1,
        maxSpeed = 1,
        position = 0
    }

--camera object--

    cam = {
        X=plr.X-55,
        Y=plr.Y-55
    }

end

function _initEquipment()

    equipment = {
        sp=36,
        X=plr.X+11,
        Y=plr.Y+12,
        draw = false,
        flipX = false,
        flipY = false
    }

end

function _updateEquipment()
    equipment.X = plr.X+11
    equipment.Y = plr.Y+12
end

--movement inputs--

function _move()

    if (btn(0) and btn(2) or btn(0) and btn(3)) then
        plr.speed = sqrt(2)/2 * plr.maxSpeed * plr.speedModifier
    elseif (btn(1) and btn(2) or btn(1) and btn(3)) then
        plr.speed = sqrt(2)/2 * plr.maxSpeed * plr.speedModifier
    else
        plr.speed = plr.maxSpeed * plr.speedModifier
    end

    if (not btn(1) and btn(0)) then
        plr.flipX=true
        plr.X-=plr.speed
    elseif (not btn(0) and btn(1)) then
        plr.flipX=false
        plr.X+=plr.speed
    end
    
    if (not btn(3) and btn(2)) then
        plr.sp=34
        plr.Y-=plr.speed
    elseif (not btn(2) and btn(3)) then
        plr.sp=32
        plr.Y+=plr.speed
    end

end

function _castEquipment()
    if (equipment.draw==false and btnp(4)) then
        equipment.draw=true
        plr.speedModifier = .5
    elseif (equipment.draw == true and btnp(4)) then
        equipment.draw = false
        plr.speedModifier = 1
    end
end

function _drawEquipment()
    if (equipment.draw==true) then
        spr(equipment.sp,equipment.X, equipment.Y,1,1, equipment.flipX, equipment.flipY)
    end
end

function _drawOrder()

    if (plr.position == 0 or plr.position == 3) then
       spr(plr.sp,plr.X, plr.Y, 2,2, plr.flipX, plr.flipY)
       _drawEquipment()
    elseif (plr.position==1 or plr.position==2) then
        _drawEquipment()
        spr(plr.sp,plr.X, plr.Y, 2,2, plr.flipX, plr.flipY)
    end


end

function _updatePlrPosition()
    if (plr.sp == 32 and plr.flipX == false) then
        plr.position = 3
    elseif (plr.sp == 32 and plr.flipX == true) then
        plr.position = 2
    elseif (plr.sp == 34 and plr.flipX == true) then
        plr.position = 1
    elseif (plr.sp == 34 and plr.flipX == false) then
        plr.position = 0
    end
end

function _updateCastPosition()
    if(plr.position==0)then
        equipment.X=plr.X+11
        equipment.Y=plr.Y+12
        equipment.flipX=false
        equipment.sp=36
    elseif(plr.position==1)then
        equipment.X=plr.X+10
        equipment.Y=plr.Y+4
        equipment.flipX=false
        equipment.sp=37
    elseif(plr.position==2)then
        equipment.X=plr.X-2
        equipment.Y=plr.Y+4
        equipment.flipX=true
        equipment.sp=37
    elseif(plr.position==3)then
        equipment.X=plr.X+-2
        equipment.Y=plr.Y+12
        equipment.flipX=true
        equipment.sp=36
    end
end

function _miniGame()
    if(fish.action==true)then
        
    end
end

function _fishSpawner()

    fishRandSign = {-1,1}


    while #fishes < 15 do

--potential locations for a fish in the Y axis
        fishY = {
            cam.Y-8-(flr(rnd(101))), cam.Y+127+(flr(rnd(101))), plr.Y+(rnd(fishRandSign)*flr(rnd(101))), plr.Y+(rnd(fishRandSign)*flr(rnd(101)))
        }

        fishGenY = rnd(fishY)

--potential locations for a fish in the X axis
        fishX = {
            cam.X-8-(flr(rnd(101))), cam.X+127+(flr(rnd(101)))
        }

        fishXOther = plr.X+(rnd(fishRandSign)*flr(rnd(101)))
        
        if(fishGenY == fishY[1] or fishGenY == fishY[2])then
            fishGenX = fishXOther
        else
            fishGenX = rnd(fishX)
        end

        add(fishes, fish:new({
        Y=fishGenY,
        X=fishGenX
        }))
    end
end

function _fishDeleter()
    i=1
    deli(fishes, i)
    i+=1
    if(i>#fishes)then
        i=1
    end
   
end

--fish object and constructor

fish = {
    sp=16,
    X=nil,
    Y=nil,
    action = false,
    delete = false,

    new=function(self,tbl)
        tbl=tbl or {}
        setmetatable(tbl,{
            __index=self
        })
        return tbl
    end,

    update=function(self)
        
        if equipment.draw==true and equipment.X >= self.X and equipment.X <= self.X+8 and equipment.Y >= self.Y and equipment.Y <= self.Y+8 then
            self.action = true
        else
            self.action = false
        end

        if flr(self.X)+200==flr(plr.X) or flr(self.Y)+200==flr(plr.Y) or flr(self.X)-200==flr(plr.X) or flr(self.Y)-200==flr(plr.Y) then
            self.kill = true
        end
    end,

    draw=function(self)
        spr(self.sp,self.X,self.Y)
    end,

    delete=function(self)
            del(fishes, self)
    end
        }