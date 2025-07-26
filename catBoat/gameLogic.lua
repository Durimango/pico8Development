function _init()

    palt(0,false)
    palt(11,true)
    _initPlayer()
    _initEquipment()
end

function _update()
    _move()
    _updateEquipment()
    _updatePlrPosition()
    _updateCastPosition()
    _castEquipment()

    --camera object--

    cam = {
        X=plr.X-55,
        Y=plr.Y-55
    }
end

function _draw()
    cls(12)
    camera(cam.X,cam.Y)

    --print debugger--
    print(stat(7),cam.X,cam.Y)

    
    spr(16, 32, 15)
    _drawOrder()
    

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

end