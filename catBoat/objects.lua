--all classes

class=setmetatable({
    hitBox={},
    sp=nil,
    X=0,
    Y=0,

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
    X=-72,
    Y=-72,
    flipX = false,
    speedModifier = 1,
    speed = 1,
    maxSpeed = 1,
    position = 0,
    state = 0,
    inventory = 0,
    gridX=-72,
    gridY=-72,


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

--player direction logic
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

--grid logic
        if abs(flr(X))-8 == abs(gridX) then
            gridX=flr(X)
        end
        if abs(flr(Y))-8 == abs(gridY) then
            gridX=flr(Y)
        end

    end,

    draw=function(_ENV)
        --rect(hitBox[1],hitBox[3],hitBox[2],hitBox[4], 8)
        spr(sp,X,Y,2,2,flipX,false)
        
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
            --rect(hitBox[1],hitBox[3],hitBox[2],hitBox[4], 8)
            spr(sp,X,Y,1,1,flipX, false)
        end
    end
}

fish=class:constructor({

    sp=16,
    action = false,
    kill = false,
    amount=ceil(rnd(3)),

    update=function(_ENV)
--hitbox updater
        hitBox = {X-1,X+8,Y-1,Y+8}

        if equip.state==1 and _collisionDetection(equip.hitBox, hitBox)==true then
            plr.state = 1
            popup.state = 1
            if btnp(5) then
                amount-=1
            end
        elseif equip.state==0 and _collisionDetection(equip.hitBox, hitBox)==false then
            plr.state = 0
            popup.state = 0
        end

        if flr(X)+200==flr(plr.X) or flr(Y)+200==flr(plr.Y) or flr(X)-200==flr(plr.X) or flr(Y)-200==flr(plr.Y) then
            kill=true
        end

        if amount == 0 then
            plr.state=0
            popup.state=0
            kill=true
        end
    end,

    draw=function(_ENV)
        --rect(hitBox[1],hitBox[3],hitBox[2],hitBox[4], 8)
        spr(sp,X,Y)
    end,

    destructor=function(_ENV)
        if kill == true then
            del(fishes, _ENV)
        end
    end
})

popup=class:constructor({
    cursorY=0,
    cursorFlip=false,
    cursorSpeed=1,
    state=0,
    catchBarY=0,

    update=function(_ENV)

        X=plr.X+18
        Y=plr.Y-4

        if state==0 then
            if equip.state==1 then
                cursorY=Y+1
                catchBarY=ceil(rnd(21))+Y
            end
        elseif state==1 then
            if btnp(5) and cursorY>=catchBarY and cursorY<=catchBarY+1 and plr.inventory<10 then
                plr.inventory+=1
                sfx(2)
            elseif btnp(5) then
                catchBarY=ceil(rnd(21))+Y
                sfx(3)
            end

            if cursorFlip == false then
                cursorY+=cursorSpeed
            elseif cursorFlip == true then
                cursorY-=cursorSpeed
            end

            if cursorY<=Y+1 then
                cursorFlip=false
            elseif cursorY>=Y+22 then
                cursorFlip=true
            end
        end
        
    end,

    draw=function(_ENV)
        if state==1 then
--popup
            rectfill(X+1,Y+1,X+6,Y+22,13)
            line(X+1,Y,X+6,Y,0)
            line(X+1,Y+23,X+6,Y+23,0)
            line(X,Y+1,X,Y+22,0)
            line(X+7,Y+1,X+7,Y+22,0)
--catchbar
            rectfill(X+1,catchBarY,X+6,catchBarY+1,10)

--cursor
            line(X+1,cursorY,X+6,cursorY,8)
        end
    end,

})

ui=class:constructor({
    gold=0,

    update=function(_ENV)
        X=cam.X
        Y=cam.Y
        X1=X+127
        Y1=Y+6
        Y2=Y+9
        fish=plr.inventory
    end,

    draw=function(_ENV)
        fillp(▒)
        rectfill(X,Y1,X1,Y2,1)
        fillp()
        rectfill(X,Y,X1,Y1,1)

        print("fish:"..fish,cam.X+100,cam.Y+1,6)
        print("gold:"..gold,cam.X+1,cam.Y+1,6)
    end
})

shore=class:constructor({
    tiles = {11,12,13},
    kill = false,
    sp=11,
    xPos={},
    yPos={},

    init=function(_ENV)
        sp=rnd(tiles)
        hitBox = {X-1,X+8,Y-1,Y+8}
    end,

    update=function(_ENV)
        if plr.X+plr.Y>=-130 and plr.X+plr.Y<0 then
            
        end
    end,

    draw=function(_ENV)
        spr(sp,X,Y)
    end,

    destructor=function(_ENV)
        if kill == true then
            del(shoreLine, _ENV)
        end
    end
})

--all premade objects from those classes

