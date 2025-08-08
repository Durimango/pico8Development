--contains all functions that are initialized, updated, and drawn to the screen

function _init()
--object oriented programming global table reference - do NOT remove or change
    global=_ENV
--changing transparency for green screen
    palt(0,false)
    palt(11,true)
--player initializer
    plr = {}
    setmetatable(plr,{
    __index=plrs
    })
--camera initializer
    cam = {}
    setmetatable(cam,{
    __index=cams
    })
--equipment initializer
    equip={}
    setmetatable(equip,{
    __index=equipment
    })

--fish debugger
    fishTest={X=10,Y=10,}
    setmetatable(fishTest,{
    __index=fish
    })
--fish table
    fishes = {fishTest}

end

function _update()
--player updater
    plr:update()
--camera updater
    cam:update()
--equipment updater
    equip:update()

--fish spawner
    _fishSpawner()

--fish table update
    for fish in all(fishes) do
        fish:update()
        fish:destructor()
    end

--debug updater
    echo()
    echo_tbl(fishes[1])
end

function _draw()
--clear screen to light blue every frame
    cls(12)

--camera draw (must draw first)
    cam:draw()

--fish table draw
    for fish in all(fishes) do
        fish:draw()
    end

--player draw
    _drawOrder()


    
--debugging
    --print(plr, cam.X, cam.Y)
    print_echoes()
end