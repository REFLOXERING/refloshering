getgenv().Time = 0.7

-- Accessories
getgenv().Torso     = {89452708599014}
getgenv().RightArm  = {78068104707834}
getgenv().LeftArm   = {70399446316955}
getgenv().RightLeg  = {107831809204196}
getgenv().LeftLeg   = {137076952997340}

-- Hair Mesh Configuration
getgenv().HairMeshes = {
    {MeshId = "rbxassetid://122420182381471", Offset = Vector3.new(0, -1.18, 0.28)}, -- Special higher hair
    {MeshId = "rbxassetid://124616337236968", Offset = Vector3.new(0, -0.19, 0.28)},
    {MeshId = "rbxassetid://83881065971318", Offset = Vector3.new(0, -0.19, 0.28)},
    {MeshId = "rbxassetid://130779357951282", Offset = Vector3.new(0, -0.19, 0.28)},
}
getgenv().HairTextureId = "rbxassetid://6752759709"
getgenv().HairScale = Vector3.new(0.95, 0.95, 0.95)

-- Leg Accessories Offset for pants alignment
getgenv().LegOffset = CFrame.new(0, -0.15, 0) -- <-- Change this for pants fine-tune per leg


local function weldParts(part0, part1, c0, c1)
    local weld = Instance.new("Weld")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.C0 = c0 or CFrame.new()
    weld.C1 = c1 or CFrame.new()
    weld.Parent = part0
    return weld
end

local function findAttachment(rootPart, name)
    for _, desc in ipairs(rootPart:GetDescendants()) do
        if desc:IsA("Attachment") and desc.Name == name then
            return desc
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart, offsetCFrame)
    local accessory = game:GetObjects("rbxassetid://" .. accessoryId)[1]
    if not accessory then return end

    accessory.Parent = workspace
    local handle = accessory:FindFirstChild("Handle")
    if handle then
        handle.CanCollide = false
        local accAttach = handle:FindFirstChildOfClass("Attachment")
        local parentAttach = accAttach and findAttachment(parentPart, accAttach.Name)
        if parentAttach then
            local c0 = parentAttach.CFrame * (offsetCFrame or CFrame.new())
            weldParts(parentPart, handle, c0, accAttach.CFrame)
        else
            local ap = accessory:FindFirstChild("AttachmentPoint")
            local fallbackC0 = (offsetCFrame or CFrame.new()) * CFrame.new(0, 0.5, 0)
            if ap then
                weldParts(parentPart, handle, fallbackC0, ap.CFrame)
            else
                weldParts(parentPart, handle, fallbackC0, CFrame.new())
            end
        end
    end
    accessory.Parent = game.Players.LocalPlayer.Character
end

local function addHairMeshes(character)
    local head = character:FindFirstChild("Head")
    if not head then return end

    for _, hair in ipairs(getgenv().HairMeshes) do
        local part = Instance.new("Part")
        part.Name = "CustomHair"
        part.Size = Vector3.new(1, 1, 1)
        part.Anchored = false
        part.CanCollide = false
        part.Transparency = 0
        part.Color = Color3.new(0, 0, 0)
        part.Parent = character

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = hair.MeshId
        mesh.TextureId = getgenv().HairTextureId
        mesh.Scale = getgenv().HairScale
        mesh.Parent = part

        local attachment = head:FindFirstChild("HairAttachment") or head:FindFirstChild("HatAttachment")
        if attachment then
            weldParts(head, part, attachment.CFrame * CFrame.new(hair.Offset), CFrame.new())
        else
            weldParts(head, part, CFrame.new(0, 0.5, 0) * CFrame.new(hair.Offset), CFrame.new())
        end
    end
end

local function loadAccessories(character)
    -- Remove all existing accessories
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child.Name == "CustomHair" then
            child:Destroy()
        end
    end

    -- Torso
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if torso then
        for _, id in ipairs(getgenv().Torso) do
            addAccessoryToCharacter(id, torso)
        end
    end

    -- Right Arm
    local rArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
    if rArm then
        for _, id in ipairs(getgenv().RightArm) do
            addAccessoryToCharacter(id, rArm)
        end
    end

    -- Left Arm
    local lArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")
    if lArm then
        for _, id in ipairs(getgenv().LeftArm) do
            addAccessoryToCharacter(id, lArm)
        end
    end

    -- Right Leg (pants layering)
    local rLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")
    if rLeg then
        for _, id in ipairs(getgenv().RightLeg) do
            addAccessoryToCharacter(id, rLeg, getgenv().LegOffset)
        end
    end

    -- Left Leg (pants layering)
    local lLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
    if lLeg then
        for _, id in ipairs(getgenv().LeftLeg) do
            addAccessoryToCharacter(id, lLeg, getgenv().LegOffset)
        end
    end

    -- Custom Hair Meshes
    addHairMeshes(character)
end

local function loadClothing()
    local char = game.Players.LocalPlayer.Character
    pcall(function() char.Pants:Destroy() end)
    pcall(function() char.Shirt:Destroy() end)

    local pants = Instance.new("Pants")
    pants.Parent = char
    pants.PantsTemplate = 'rbxassetid://6139818848'
    pants.Name = 'Pants'

    local shirt = Instance.new("Shirt")
    shirt.Parent = char
    shirt.ShirtTemplate = 'rbxassetid://10879148718'
    shirt.Name = 'Shirt'
end

local function changeFace(character)
    local head = character:FindFirstChild("Head")
    if head then
        local oldFace = head:FindFirstChildWhichIsA("Decal")
        if oldFace then
            oldFace:Destroy()
        end

        local newFace = Instance.new("Decal")
        newFace.Name = "face"
        newFace.Texture = "rbxassetid://78728386579541"
        newFace.Face = Enum.NormalId.Front
        newFace.Parent = head
    end
end

-- Shoe Mesh + Texture Configuration
local leftShoeMeshId = "rbxassetid://116743324871022"
local rightShoeMeshId = "rbxassetid://135284268484200"
local shoeTextureId = "rbxassetid://13414088598"

-- Optional: Adjust position and scale
local shoeScale = Vector3.new(1, 1, 1)  -- Make this smaller if oversized
local leftShoeOffset = Vector3.new(0, 0, 0)  -- X, Y, Z offset
local rightShoeOffset = Vector3.new(0, 0, 0)

local function addLayeredShoes(character)
    local leftLeg = character:FindFirstChild("LeftLowerLeg") or character:FindFirstChild("Left Leg")
    local rightLeg = character:FindFirstChild("RightLowerLeg") or character:FindFirstChild("Right Leg")
    if not (leftLeg and rightLeg) then return end

    local function createShoe(meshId, offset, parentPart)
        local accessory = Instance.new("Accessory")
        accessory.Name = "ShoeAccessory"

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 1, 1)
        handle.Transparency = 1
        handle.Anchored = false
        handle.CanCollide = false
        handle.Parent = accessory

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = meshId
        mesh.TextureId = shoeTextureId
        mesh.Scale = shoeScale
        mesh.Parent = handle

        local weld = Instance.new("Weld")
        weld.Part0 = parentPart
        weld.Part1 = handle
        weld.C0 = CFrame.new(offset)
        weld.Parent = handle

        accessory.Parent = character
    end

    createShoe(leftShoeMeshId, leftShoeOffset, leftLeg)
    createShoe(rightShoeMeshId, rightShoeOffset, rightLeg)
end

local layeredTShirtPositionOffset = Vector3.new(0, 0, 0) -- Adjust Position (X, Y, Z)
local layeredTShirtRotationOffset = Vector3.new(0, 0, math.rad(120)) -- Rotate 120 degrees around Z axis

local function addLayeredTShirt(character)
    local torso = character:FindFirstChild("Torso")
    if not torso then return end

    local accessory = Instance.new("Accessory")
    accessory.Name = "LayeredTShirt"

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Transparency = 1
    handle.Anchored = false
    handle.CanCollide = false
    handle.Parent = accessory

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://89823761737524"
    mesh.TextureId = "rbxassetid://96145327116732"
    mesh.Scale = Vector3.new(1.1, 1.1, 1.1)  -- Slightly smaller to prevent clipping
    mesh.Parent = handle

    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = handle
    weld.C0 = CFrame.new(layeredTShirtPositionOffset) * CFrame.Angles(layeredTShirtRotationOffset.X, layeredTShirtRotationOffset.Y, layeredTShirtRotationOffset.Z)
    weld.Parent = handle

    accessory.Parent = character
end

local function setSkinColor(character, color)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Handle" then
            if part.Name ~= "Head" or not part:FindFirstChildOfClass("Decal") then
                part.Color = color
                part.Material = Enum.Material.SmoothPlastic
            end
        end
    end
end

local function onCharacterAdded(character)
    wait(getgenv().Time)
    loadAccessories(character)
    loadClothing()
    addLayeredTShirt(character)
    addLayeredShoes(character)
end

local function onCharacterDied()
    local character = game.Players.LocalPlayer.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            lastDeathPosition = root.Position
        end
    end
end

-- Character Respawn Handling
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").Died:Connect(onCharacterDied)
    onCharacterAdded(char)
end)

if game.Players.LocalPlayer.Character then
    local char = game.Players.LocalPlayer.Character
    char:WaitForChild("Humanoid").Died:Connect(onCharacterDied)
    onCharacterAdded(char)
end