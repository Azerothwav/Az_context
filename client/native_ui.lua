UI = {}
UI.cooldown = false
UI.font = {}
UI.AnimatedFrames = {}
UI.pages = {

}
UI.lockedControls = {
    {24, 30, 31, 32, 33, 34, 35, 69, 70, 92, 114, 121, 140, 141, 142, 257, 263, 264, 331, 1, 2, 4, 5, 17, 16, 15, 14, 241, 242, 332, 333, 14, 15, 16, 17, 27, 50, 96, 97, 99, 115, 180, 181, 198, 241, 242, 261, 262, 334, 335, 336, 348, 81, 82, 83, 84, 85}
}

function UI.IsAnySubMenuActive()
    for k,v in pairs(UI.pages) do
        if v.active then
            return true
        end
    end
    return false
end

function UI.SetPageActive(page)
    if UI.pages[page] then
        UI.pages[page].active = true
    end
end

function UI.SetPageInactive(page)
    if UI.pages[page] then
        UI.pages[page].active = false
    end
end

function UI.EnableControlsForPage(page)
    if UI.pages[page] then
        UI.pages[page].showCursor = true
        UI.pages[page].lockControls = true
    end
end

function UI.DisableControlsForPage(page)
    if UI.pages[page] then
        UI.pages[page].showCursor = false
        UI.pages[page].lockControls = false
    end
end

function UI.GetPageStatus(page)
    if UI.pages[page] then
        return UI.pages[page].active
    end
    return false
end

function UI.SetFullscreenLoaderActive(status)
    if status then
        SendNUIMessage({
            type    = 'toggleLoaderOn',
        })
    else
        SendNUIMessage({
            type    = 'toggleLoaderOff',
        })
    end
end

function UI.ForceStopIntro()
    SendNUIMessage({
        type    = 'stopIntro',
    })
end

-- Citizen.CreateThread(function() -- No pages used so no need to loop for now.
--     while true do
--         local lockControls = false
--         local showCursor = false


--         for k,v in pairs(UI.pages) do
--             --print(v.active, k)
--             if v.active then
--                 if v.showCursor then
--                     showCursor = true
--                 end
--                 if v.lockControls then
--                     lockControls = true
--                 end
--                 if Loader.Loaded or v.ignoreLoader then
--                     v.drawFunction()
--                 end
--             end
--         end

--         if showCursor then
--             ShowCursorThisFrame()
--             SetMouseCursorSprite(1)
--         end

--         if lockControls then
--             for k,v in pairs(UI.lockedControls[1]) do
--                 if v ~= nil then
--                     DisableControlAction(0, v, true)
--                 end
--             end
--         end

--         Wait(1)
--     end
-- end)


-- Duplicate, need to be removed
function UI.RealWait(ms, cb)
    local timer = GetGameTimer() + ms
    while GetGameTimer() < timer do
        if cb ~= nil then
            cb(function(stop)
                if stop then
                    timer = 0
                    return
                end
            end)
        end
        Wait(0)
    end
end

function UI.LoadStreamDict(dict)
    -- if HasStreamedTextureDictLoaded(dict) then
    --     SetStreamedTextureDictAsNoLongerNeeded(dict)
    --     while HasStreamedTextureDictLoaded(dict) do
    --         SetStreamedTextureDictAsNoLongerNeeded(dict)
    --         print("Waiting unload before load for", dict)
    --         Wait(1)
    --     end
    -- end
    while not HasStreamedTextureDictLoaded(dict) do
        RequestStreamedTextureDict(dict, 1)
        print("Loading dict ", dict)
        Wait(0)
    end
    print("Dict loaded! ", dict)
end

function UI.LoadFont(font)
    RegisterFontFile(font[1]) -- the name of your .gfx, without .gfx
    local fontId = RegisterFontId(font[2]) -- the name from the .xml

    UI.font[font[2]] = fontId
end


function UI.DrawSlider(screenX, screenY, width, height, backgroundColor, progressColor, value, max, settings, cb)
    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)


        screenX = x
        screenY = y


        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x..", "..y)
        end
    end

    if value > max then
        value = max
    end

    if settings.direction == nil then
        settings.direction = 1
    end

    local valueUpdated = false
    local newValue = value

    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    DrawRect(pos[1], pos[2], width, height, backgroundColor[1], backgroundColor[2], backgroundColor[3], backgroundColor[4])

    local progressWidth = (value/max) * width
    local progressHeight = height

    if settings.direction == 1 then -- left-to-right
        pos = (vector2(screenX, screenY) + vector2(progressWidth, height) / 2.0)
    elseif settings.direction == 2 then -- right-to-left
        pos = pos + vector2(width / 2.0, 0.0) - vector2(progressWidth / 2.0, 0.0)
    elseif settings.direction == 3 then -- bottom-to-top
        progressWidth = width
        progressHeight = (value/max) * width
        pos = pos + vector2(0.0, height / 2.0) - vector2(0.0, progressHeight / 2.0)
    elseif settings.direction == 4 then -- top-to-bottom
        progressWidth = width
        progressHeight = (value/max) * width
        pos = pos - vector2(0.0, height / 2.0) + vector2(0.0, progressHeight / 2.0)
    end

    DrawRect(pos[1], pos[2], progressWidth, progressHeight, progressColor[1], progressColor[2], progressColor[3], progressColor[4])

    if settings.noHover == false then
        if UI.isMouseOnButton({x = GetControlNormal(0, 239) , y = GetControlNormal(0, 240)}, {x = screenX, y = screenY}, width, height) then
            SetMouseCursorSprite(4)
            if IsControlPressed(0, 24) then
                local mouse = GetControlNormal(0, 239)
                local size = ((mouse - screenX) * max) / width
                newValue = size

                --print(newValue)
                valueUpdated = true
            end
        end
    end

    cb(valueUpdated, newValue)
end



UI.HoveredCache = {}

function UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
    local uniqueID = textureDict .. textureName .. screenX .. screenY
    if UI.HoveredCache[uniqueID] == nil then
        UI.HoveredCache[uniqueID] = false
        return false, uniqueID
    else
        return UI.HoveredCache[uniqueID], uniqueID
    end
end

function UI.SetHoveredStatus(uniqueID, status)
    if UI.HoveredCache[uniqueID] ~= nil then
        UI.HoveredCache[uniqueID] = status
    end
end

function UI.DrawSpriteNew(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue, alpha, settings, cb)
    local onSelected = false
    local onHovered = false
    local pos
    if alpha <= 0 then
        return
    else
        alpha = math.floor(alpha)
    end

    if not HasStreamedTextureDictLoaded(textureDict) then
        RequestStreamedTextureDict(textureDict, true)
    else

        if settings.devmod ~= nil and settings.devmod == true then
            local x = GetControlNormal(0, 239)
            local y = GetControlNormal(0, 240)

            screenX = x
            screenY = y

            if IsControlJustReleased(0, 38) then
                print(x, y)
            end
        end


        if settings.centerDraw ~= nil and settings.centerDraw == true then
            pos = vector2(screenX, screenY)
        else
            pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
        end

        -- if Sheets.IsSpriteAnimated(textureDict, textureName) then
        --     textureName = textureName..Sheets.GetActualFrame(textureDict, textureName)
        -- end

        if settings.Draw3d ~= nil then
            SetDrawOrigin(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z, 0)
            pos = (vector2(0.0, 0.0) + vector2(width, height) / 2.0)
        end

        if settings.NoHover ~= nil and settings.NoHover == true then
            DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        else
            if settings.Draw3d ~= nil then
                _, screenX, screenY = GetScreenCoordFromWorldCoord(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z)
            end
            if UI.isMouseOnButton({x = GetControlNormal(0, 239) , y = GetControlNormal(0, 240)}, {x = screenX, y = screenY}, width, height) then
                onHovered = true
                local aleadyHovered, spriteUniqueId = UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
                if not aleadyHovered then
                    UI.SetHoveredStatus(spriteUniqueId, true)
                end
                if settings.CustomHoverTexture ~= nil and settings.CustomHoverTexture ~= false then
                    if settings.CustomHoverTexture[3] ~= nil and settings.CustomHoverTexture[4] ~= nil then
                        local x,y = UI.ConvertToPixel(settings.CustomHoverTexture[3], settings.CustomHoverTexture[4])
                        width = x
                        height = y
                    end

                    DrawSprite(settings.CustomHoverTexture[1], settings.CustomHoverTexture[2], pos[1], pos[2], width, height, heading, red, green, blue, alpha)
                else
                    DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
                end
            else
                onHovered = false
                local aleadyHovered, spriteUniqueId = UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
                if aleadyHovered then
                    UI.SetHoveredStatus(spriteUniqueId, false)
                end
                DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
            end
        end


        if settings.NoSelect == nil or settings.NoSelect == false and not settings.devmod == true then
            if UI.isMouseOnButton({x = GetControlNormal(0, 239) , y = GetControlNormal(0, 240)}, {x = screenX, y = screenY}, width, height) then
                SetMouseCursorSprite(4)
                onHovered = true
                if UI.HandleControl() then
                    --PlayCustomSound("FrontEnd/Navigate_Apply_01_Wave 0 0 0", 0.02)
                    onSelected = true
                end
            end
        end

        if settings.Draw3d ~= nil then
            ClearDrawOrigin()
        end
    end


    cb(onSelected, onHovered, pos)
end


function UI.DrawRect(screenX, screenY, width, height, heading, red, green, blue, alpha, settings, cb)
    local onSelected = false
    local onHovered = false

    alpha = math.floor(alpha)
    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)

       print(x, y)

        screenX = x
        screenY = y

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x..", "..y)
        end
    end

    local pos
    if settings.centerDraw ~= nil and settings.centerDraw == true then
        pos = vector2(screenX, screenY)
    else
        pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    end

    -- if Sheets.IsSpriteAnimated(textureDict, textureName) then
    --     textureName = textureName..Sheets.GetActualFrame(textureDict, textureName)
    -- end

    if settings.Draw3d ~= nil then
        SetDrawOrigin(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z, 0)
        pos = (vector2(0.0, 0.0) + vector2(width, height) / 2.0)
    end

    if settings.NoHover ~= nil and settings.NoHover == true then
        --DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        --print(pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        if alpha >= 0 then
            DrawRect(pos[1], pos[2], width, height, red, green, blue, alpha)
        end

    else
        if settings.Draw3d ~= nil then
            _, screenX, screenY = GetScreenCoordFromWorldCoord(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z)
        end
        if UI.isMouseOnButton({x = GetControlNormal(0, 239) , y = GetControlNormal(0, 240)}, {x = screenX, y = screenY}, width, height) then
            onHovered = true
            local aleadyHovered, spriteUniqueId = UI.CheckIfAlreadyHovered("RECT", "RECT", screenX, screenY)
            if not aleadyHovered then
                UI.SetHoveredStatus(spriteUniqueId, true)
            end
            if settings.CustomHoverTexture ~= nil and settings.CustomHoverTexture ~= false then
                if alpha >= 0 then
                    DrawRect(pos[1], pos[2], width, height, settings.CustomHoverTexture[1], settings.CustomHoverTexture[2], settings.CustomHoverTexture[3], settings.CustomHoverTexture[4])
                end
            else
                if alpha >= 0 then
                    DrawRect(pos[1], pos[2], width, height, red, green, blue, alpha)
                end

            end
        else
            onHovered = false
            local aleadyHovered, spriteUniqueId = UI.CheckIfAlreadyHovered("RECT", "RECT", screenX, screenY)
            if aleadyHovered then
                UI.SetHoveredStatus(spriteUniqueId, false)
            end
            if alpha >= 0 then
                DrawRect(pos[1], pos[2], width, height, red, green, blue, alpha)
            end

        end
    end


    if settings.NoSelect == nil or settings.NoSelect == false and not settings.devmod == true then
        if UI.isMouseOnButton({x = GetControlNormal(0, 239) , y = GetControlNormal(0, 240)}, {x = screenX, y = screenY}, width, height) then
            SetMouseCursorSprite(4)
            onHovered = true
            if UI.HandleControl() then
                --PlayCustomSound("FrontEnd/Navigate_Apply_01_Wave 0 0 0", 0.02)
                onSelected = true
            end
        end
    end

    if settings.Draw3d ~= nil then
        ClearDrawOrigin()
    end

    cb(onSelected, onHovered, pos)
end

-- Position = mouse pos
function UI.isMouseOnButton(position, buttonPos, Width, Heigh)
   -- print(position, buttonPos, Width, Heigh)
	return position.x >= buttonPos.x and position.y >= buttonPos.y and position.x < buttonPos.x + Width and position.y < buttonPos.y + Heigh
end



function UI.HandleCooldown()
    if not UI.cooldown then
        UI.cooldown = true
        Citizen.CreateThread(function()
            Wait(150)
            UI.cooldown = false
        end)
    end
end

local clickControl = {24, 176, 18, 69, 92, 106, 122, 135, 142, 144, 223, 229, 237, 257, 329, 346}
function UI.HandleControl()
    for k,v in pairs(clickControl) do
        if not UI.cooldown then
            if IsControlJustPressed(0, v) or IsDisabledControlJustPressed(0, v) then
                UI.HandleCooldown()
                return true
            end
        end
    end
    return false
end

starttimertext = false

function UI.StartTimerTextSlide(text, vitessedraw, startposition)
    starttimertext = true
    affichetext = true
    local val1 = startposition
    local val2 = startposition
    Citizen.CreateThread(function()
        while affichetext do
            local TextToDraw = text
            local valtotal = string.len(TextToDraw)
            texttoffiche = string.sub(TextToDraw, val1, val2)
            if valtotal > val2 then
                val2 = val2 + 1
            end
            Citizen.Wait(vitessedraw)
        end
    end)
end

function UI.DrawTextAndSlideIt(x, y, text, center, scale, rgb, font, rightJustify, devmod, vitessedraw, startposition)
    if not starttimertext then
        UI.StartTimerTextSlide(text, vitessedraw, startposition)
    end
    if starttimertext then
        if rgb[4] >= 0 then
            if devmod then
                local x2 = GetControlNormal(0, 239)
                local y2 = GetControlNormal(0, 240)

                x = x2
                y = y2

                if IsControlJustReleased(0, 38) then
                    print(x..", "..y)
                    TriggerEvent("addToCopy", x..", "..y)
                end
            end
            if rightJustify ~= 0 and rightJustify ~= false then
                SetTextJustification(2)
                SetTextWrap(0.0, x)
            end

            SetTextFont(font)
            SetTextScale(scale, scale)

            SetTextColour(rgb[1], rgb[2], rgb[3], math.floor(rgb[4]))
            SetTextEntry("STRING")
            SetTextCentre(center)
            AddTextComponentString(texttoffiche)
            EndTextCommandDisplayText(x,y)
        end
    end
end

function UI.DrawTexts(x, y, text, center, scale, rgb, font, rightJustify, devmod)
    if rgb[4] >= 0 then
        if devmod then
            local x2 = GetControlNormal(0, 239)
            local y2 = GetControlNormal(0, 240)

            x = x2
            y = y2

            if IsControlJustReleased(0, 38) then
                print(x..", "..y)
                TriggerEvent("addToCopy", x..", "..y)
            end
        end

        if rightJustify ~= 0 and rightJustify ~= false then
            SetTextJustification(2)
            SetTextWrap(0.0, x)
        end

        SetTextFont(font)
        SetTextScale(scale, scale)

        SetTextColour(rgb[1], rgb[2], rgb[3], math.floor(rgb[4]))
        SetTextEntry("STRING")
        SetTextCentre(center)
        AddTextComponentString(text)
        EndTextCommandDisplayText(x,y)
    end

end

function UI.DrawTextsNoLimit(x, y, text, center, scale, rgb, font, rightJustify, devmod)
    AddTextEntry("text", text)

    if devmod then
        local x2 = GetControlNormal(0, 239)
        local y2 = GetControlNormal(0, 240)

        print(x2, y2)

        x = x2
        y = y2
    end

    if rightJustify ~= 0 and rightJustify ~= false then
        SetTextJustification(2)
        SetTextWrap(0.0, x)
    end

    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x,y)
end

function UI.Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*25
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)		-- You can change the text color here
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end


-- pos.xyz
-- textureDict
-- textureName
-- x
-- y
-- width
-- height
-- heading
-- r
-- g
-- b
-- a
function UI.DrawSprite3d(data, dontDrawHowOfScreen)
    if dontDrawHowOfScreen == nil then
        dontDrawHowOfScreen = false
    end

    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x,y = GetScreenCoordFromWorldCoord(data.pos.x, data.pos.y, data.pos.z)
        --print(get, x, y)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local dist = #(GetGameplayCamCoords().xy - data.pos.xy)
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = ((1 / dist) * 2) * fov
        SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
        DrawSprite(
            data.textureDict,
            data.textureName,
            (data.x or 0) * scale,
            (data.y or 0) * scale,
            data.width * scale,
            data.height * scale,
            data.heading or 0,
            data.r or 255,
            data.g or 255,
            data.b or 255,
            data.a or 255
        )
        ClearDrawOrigin()
    end
    return draw
end

function UI.DrawSprite3dNoDownSize(data, dontDrawHowOfScreen)
    if dontDrawHowOfScreen == nil then
        dontDrawHowOfScreen = false
    end

    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x,y = GetScreenCoordFromWorldCoord(data.pos.x, data.pos.y, data.pos.z)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local scale = 1
        SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
        DrawSprite(
            data.textureDict,
            data.textureName,
            data.x or (0 * scale),
            data.y or (0 * scale),
            data.width * scale,
            data.height * scale,
            data.heading or 0,
            data.r or 255,
            data.g or 255,
            data.b or 255,
            data.a or 255
        )
        ClearDrawOrigin()
    end
    return draw

end

-- function UI.ConvertToPixel(x, y)
--     return (x * 1920), (y * 1080)
-- end

function UI.ConvertToPixel(x, y)
    return (x / 1920), (y / 1080)
end

function UI.ConvertToRes(x, y)
    return (x * 1920), (y * 1080)
end

function UI.StopDrawScaleformMovie()
    if duiObj and IsDuiAvailable(duiObj) then
        DestroyDui(duiObj)
    end
    if HasScaleformMovieLoaded('generic_texture_renderer') then
        SetScaleformMovieAsNoLongerNeeded('generic_texture_renderer')
    end
    showduiscreen = false
end

local sfHandle = nil
local txdHasBeenSet = false
local duiObj = nil
function UI.DrawScaleformMovie(url, largeur, hauteur, duration, posx, posy)
    local scaleformHandle = RequestScaleformMovie('generic_texture_renderer')
    while not HasScaleformMovieLoaded(scaleformHandle) do 
        Wait(0) 
    end
    sfHandle = scaleformHandle
    local txd = CreateRuntimeTxd('meows')
    local duiObj = CreateDui(url, largeur, hauteur)
    local dui = GetDuiHandle(duiObj)
    local tx = CreateRuntimeTextureFromDuiHandle(txd, 'woof', dui)
    showduiscreen = true
    if duration and duration ~= nil then
        Citizen.SetTimeout(duration, function()
            if duiObj and IsDuiAvailable(duiObj) then
                DestroyDui(duiObj)
            end
            if HasScaleformMovieLoaded('generic_texture_renderer') then
                SetScaleformMovieAsNoLongerNeeded('generic_texture_renderer')
            end
            showduiscreen = false
        end)
    end
    local x,y = UI.ConvertToPixel(largeur, hauteur)
    Citizen.CreateThread(function()
        while showduiscreen do
            if (sfHandle ~= nil and not txdHasBeenSet) then
                PushScaleformMovieFunction(sfHandle, 'SET_TEXTURE')
            
                PushScaleformMovieMethodParameterString('meows')
                PushScaleformMovieMethodParameterString('woof')

                PushScaleformMovieMethodParameterInt(1)
                EndScaleformMovieMethod()
            
                txdHasBeenSet = true
            end

            if (sfHandle ~= nil and HasScaleformMovieLoaded(sfHandle)) then
                if devmod then
                    posx = GetControlNormal(0, 239)
                    posy = GetControlNormal(0, 240)
                    if IsControlJustReleased(0, 38) then
                        print(posx, posy)
                    end
                end
                DrawScaleformMovie(sfHandle, posx, posy, x, y, 255, 255, 255, 255)
            end
            Citizen.Wait(0)
        end
    end)
end

local timer = GetGameTimer()
Citizen.CreateThread(function()
	while true do
		UI.TimeFrame = (GetGameTimer() - timer)
		timer = GetGameTimer()
		Wait(0)
	end
end)