--[[
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.

    This file is intended to be executed from the command line. It executes all
    of Locomotion's test cases using lemur.
]]

local lemur = require("lib.lemur")
local habitat = lemur.Habitat.new()

local ReplicatedStorage = habitat.game:GetService("ReplicatedStorage")

local function loadFolder(path, name)
    local folder = lemur.Instance.new("Folder")
    folder.Name = name
    folder.Parent = ReplicatedStorage

    habitat:loadFromFs(path, folder)
end

local function mergeUpper(root)
    local source = root:FindFirstChild("init")

    if source then
        for _, child in ipairs(root:GetChildren()) do
            child.Parent = source
        end

        source.Name = root.Name
        source.Parent = root.Parent

        root:Destroy()
    end

    for _, child in ipairs(root:GetChildren()) do
        if child:IsA("Folder") then
            mergeUpper(child)
        end
    end
end

-- Load TestEZ into habitat's ReplicatedStorage
loadFolder("lib/TestEZ/lib", "TestEZ")

-- Now load Locomotion
loadFolder("src", "Locomotion")

-- Collapse init folders, like in Rojo!
mergeUpper(ReplicatedStorage.TestEZ)
mergeUpper(ReplicatedStorage.Locomotion)

-- Now run TestEZ's tests!
local TestEZ = habitat:require(ReplicatedStorage.TestEZ)
local TestBootstrap = TestEZ.TestBootstrap
local TextReporter = TestEZ.TextReporter
TestBootstrap:run(ReplicatedStorage.Locomotion, TextReporter)
