function _drawOrder()

    if (plr.position == 0 or plr.position == 3) then
        plr:draw()
        equip:draw()
    elseif (plr.position==1 or plr.position==2) then
        equip:draw()
        plr:draw()
    end
end

function _fishSpawner()

    fishRandSign = {-1,1}


    while #fishes < 15 do

--potential locations for a fish in the Y axis
        fishY = {
            cam.Y-8-(flr(rnd(101))),
            cam.Y+127+(flr(rnd(101))),
            plr.Y+(rnd(fishRandSign)*flr(rnd(101))),
            plr.Y+(rnd(fishRandSign)*flr(rnd(101)))
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

        add(fishes, fish:constructor({
        Y=fishGenY,
        X=fishGenX
        }))
    end
end

function _collisionDetection(collidingBox, receivingBox)
--defining the boxes X and Y variables
    X1 = collidingBox[1]
    Y1 = collidingBox[3]
    X2 = collidingBox[2]
    Y2 = collidingBox[4]

    X3 = receivingBox[1]
    Y3 = receivingBox[3]
    X4 = receivingBox[2]
    Y4 = receivingBox[4]

    if ((mid(X1,X3,X4)==X1 and mid(Y1,Y3,Y4)==Y1) or
        (mid(X2,X3,X4)==X2 and mid(Y1,Y3,Y4)==Y1) or
        (mid(X1,X3,X4)==X1 and mid(Y2,Y3,Y4)==Y2) or 
        (mid(X2,X3,X4)==X2 and mid(Y2,Y3,Y4)==Y2)) then
        return true
    else
        return false
    end
end

function _miniGame()
    plr.state = 1
end