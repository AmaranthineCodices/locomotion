--[[
	This Source Code Form is subject to the terms of the Mozilla Public
	License, v. 2.0. If a copy of the MPL was not distributed with this
	file, You can obtain one at http://mozilla.org/MPL/2.0/.

	This file runs Locomotion's test suite in Roblox.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestEZ = require(ReplicatedStorage.TestEZ)

local locomotionRoot = ReplicatedStorage.Locomotion

local TestBootstrap = TestEZ.TestBootstrap
local TextReporter = TestEZ.TextReporter
TestBootstrap:run(locomotionRoot, TextReporter)
