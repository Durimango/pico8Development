function _init()

    palt(0,false)
    palt(11,true)
    _initplayer()
end

function _update()
    _move()

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
    print(plr.speed,cam.X,cam.Y)

    
    spr(16, 32, 15)
    spr(plr.sp,plr.X, plr.Y, 2,2, plr.flipX, plr.flipY)

end


function _initplayer()

--player object--

    plr = {
        X=0,
        Y=0,
        flipX = false,
        flipY = false,
        sp=32,
        speed = 1,
        maxSpeed = 1
    }

end

--movement inputs--

function _move()

    if (btn(0) and btn(2) or btn(3)) then
        plr.speed = sqrt(2)/2
    elseif (btn(1) and btn(2) or btn(3)) then
        plr.speed = sqrt(2)/2
    else
        plr.speed = plr.maxSpeed
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