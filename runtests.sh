#!/bin/sh

rojo build test.project.json -o TestPlace.rbxlx
run-in-roblox --script RunTests.server.lua --place TestPlace.rbxlx
