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
    fishTest={X=-55,Y=-55,}
    setmetatable(fishTest,{
    __index=fish
    })
--fish table
    fishes = {fishTest}

--original shoreline(come back to this)
    -- originalShore={X,Y}
    -- setmetatable(originalShore,{
    -- __index=shore
    -- })
    -- originalShore:init()
--shoreline table (come back to this)
    --shoreLine = {originalShore}

end

function _update()
--player updater
    plr:update()
--camera updater
    cam:update()
--equipment updater
    equip:update()
--popup updater
    popup:update()
--ui updater
    ui:update()
--shore updater
    shore:update()

--fish spawner
    _fishSpawner()

--fish table update
    for fish in all(fishes) do
        fish:update()
        fish:destructor()
    end
--shoreLine table update (come back to this)
    -- for shore in all(shoreLine) do
    --     shore:update()
    --     shore:destructor()
    -- end

--debug updater
    --echo(stat(1))
    echo(plr.Y)
    echo_tbl()
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
--shore table draw (come back to this)
    -- for shore in all(shoreLine) do
    --     shore:draw()
    -- end
    shore:draw()
    

--player draw
    _drawOrder()

    popup:draw()

    ui:draw()
    
--debugging
    --print(plr, cam.X, cam.Y)
    print_echoes()
end