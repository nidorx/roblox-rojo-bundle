--[[
   In this directory should be the Meshes that are mandatory for the correct functioning of the system.

   In Roblox, it is not possible to define the MeshId of a MeshPart via script. One solution to this is to use
   a Part and within it a SpecialMesh, however, SpecialMesh does not accept the use of common Textures (children),
   just TextureId, which makes it impossible to create everything via Scripts.

   Any script that needs a specific Mesh, must use this directory to house the object.
   The script should also pop an error if the MeshRequired does not exist
]]

local Meshes = game.ReplicatedStorage:WaitForChild('Meshes')

local function GetMesh(name, clone)
    local mesh = Meshes:FindFirstChild(name)
    if not mesh then
        error('Mesh "'..name..'" was not found!')
    end
    if clone then
        mesh = mesh:Clone()
    end
    return mesh
end

return GetMesh