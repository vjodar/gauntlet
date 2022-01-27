Walls={}

function Walls:load()
    self.wallsTable={}

    if gameMap.layers["WallsObj"] then
        for k, obj in pairs(gameMap.layers["WallsObj"].objects) do 
            local wall=world:newBSGRectangleCollider(obj.x,obj.y,obj.width,obj.height,3)
            wall:setType('static')
            table.insert(self.wallsTable,wall)
        end
    end
end

function Walls:update() end
function Walls:draw() end 