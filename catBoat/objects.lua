--all classes

class=setmetatable({
    hitBox={},
    sp=nil,
    X=nil,
    Y=nil,

    constructor=function(_ENV, tbl)
    tbl=tbl or {}
    setmetatable(tbl,{
        __index=_ENV
    })
    return tbl
    end,

    destructor=function(_ENV, tbl)
        del(tbl, _ENV)
    end,

    update=function(_ENV)
    end,

    draw=function(_ENV)
    end,

    drawHitBox=function(_ENV)
        rect(hitBox[1],hitBox[2],hitBox[3],hitBox[4], 8)
    end
},{__index=_ENV})

plrs=class:constructor{
    sp=32,
    X=0,
    Y=0,
    flipX = false,
    speedModifier = 1,
    speed = 1,
    maxSpeed = 1,
    position = 0,
    state = 0,


    update=function(_ENV)
--all movement logic
        if state==0 then
            if (btn(0) and btn(2) or btn(0) and btn(3)) then
                speed = sqrt(2)/2 * maxSpeed * speedModifier
            elseif (btn(1) and btn(2) or btn(1) and btn(3)) then
                speed = sqrt(2)/2 * maxSpeed * speedModifier
            else
                speed = maxSpeed * speedModifier
            end

            if (not btn(1) and btn(0)) then
                flipX=true
                X-=speed
            elseif (not btn(0) and btn(1)) then
                flipX=false
                X+=speed
            end
            
            if (not btn(3) and btn(2)) then
                sp=34
                Y-=speed
            elseif (not btn(2) and btn(3)) then
                sp=32
                Y+=speed
            end
        end

--player positon logic
        if (sp == 32 and flipX == false) then
            position = 3
        elseif (sp == 32 and flipX == true) then
            position = 2
        elseif (sp == 34 and flipX == true) then
            position = 1
        elseif (sp == 34 and flipX == false) then
            position = 0
        end

--hitbox updater
        hitBox = {X+2,X+13,Y+9,Y+15}

    end,

    draw=function(_ENV)
        --rect(hitBox[1],hitBox[3],hitBox[2],hitBox[4], 8)
        spr(sp,X,Y,2,2,flipX,flipY)
    end,
}

cams=class:constructor{

    update=function(_ENV)
        X=plr.X-55
        Y=plr.Y-55
    end,

    draw=function(_ENV)
        camera(X,Y)
    end
}

equipment=class:constructor{
    sp=36,
    flipX = false,
    flipY = false,
    state = 0,

    update=function(_ENV)
--turn on equipment and reduce speed
        if (state==0 and btnp(4)) then
            state=1
            plr.speedModifier = .5
        elseif (state==1 and btnp(4)) then
            state = 0
            plr.speedModifier = 1
        end

--updating cast position
        if(plr.position==0)then
            X=plr.X+11
            Y=plr.Y+12
            flipX=false
            sp=36
        elseif(plr.position==1)then
            X=plr.X+10
            Y=plr.Y+4
            flipX=false
            sp=37
        elseif(plr.position==2)then
            X=plr.X-2
            Y=plr.Y+4
            flipX=true
            sp=37
        elseif(plr.position==3)then
            X=plr.X+-2
            Y=plr.Y+12
            flipX=true
            sp=36
        end

--hitbox updater
        hitBox = {X,X+7,Y,Y+7}
    end,

    draw=function (_ENV)
        if (state==1) then
            rect(hitBox[1],hitBox[3],hitBox[2],hitBox[4], 8)
            spr(sp,X,Y,1,1,flipX, flipY)
        end
    end
}

fish=class:constructor({

    sp=16,
    action = false,
    kill = false,

    update=function(_ENV)
--hitbox updater
        hitBox = {X-1,X+8,Y-1,Y+8}

        if equip.state==1 and _collisionDetection(equip.hitBox, hitBox)==true then
            _miniGame()
        elseif equip.state==0 and _collisionDetection(equip.hitBox, hitBox)==false then
            plr.state = 0
        end

        if flr(X)+200==flr(plr.X) or flr(Y)+200==flr(plr.Y) or flr(X)-200==flr(plr.X) or flr(Y)-200==flr(plr.Y) then
            kill = true
        end
    end,

    draw=function(_ENV)
        rect(hitBox[1],hitBox[3],hitBox[2],hitBox[4], 8)
        spr(sp,X,Y)
    end,

    destructor=function(_ENV)
        if kill == true then
            del(fishes, _ENV)
        end
    end
})

--all premade objects from those classes

