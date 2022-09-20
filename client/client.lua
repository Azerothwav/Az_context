DontMovePlayer = function(bool)
	dontmoveplayer = bool
	Citizen.CreateThread(function()
		while dontmoveplayer do
			DisableControlAction(0, 1,   true) -- LookLeftRight
			DisableControlAction(0, 2,   true) -- LookUpDown
			DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
			DisableControlAction(0, 142, true) -- MeleeAttackAlternate
			DisableControlAction(0, 30,  true) -- MoveLeftRight
			DisableControlAction(0, 31,  true) -- MoveUpDown
			DisableControlAction(0, 21,  true) -- disable sprint
			DisableControlAction(0, 24,  true) -- disable attack
			DisableControlAction(0, 25,  true) -- disable aim
			DisableControlAction(0, 47,  true) -- disable weapon
			DisableControlAction(0, 58,  true) -- disable weapon
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 75,  true) -- disable exit vehicle
			DisableControlAction(27, 75, true) -- disable exit vehicle
			Citizen.Wait(0)
		end
	end)
end

ActiveKeyboard = function(titre, taille)
	DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", taille)
	input = true
	while input do
		if input == true then
			HideHudAndRadarThisFrame()
			if UpdateOnscreenKeyboard() == 3 then
				input = false
			elseif UpdateOnscreenKeyboard() == 1 then
				local inputText = GetOnscreenKeyboardResult()
				if string.len(inputText) > 0 then
					input = false
					return inputText
				else
					DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", taille)
				end
			elseif UpdateOnscreenKeyboard() == 2 then
				input = false
			end
		end
		Citizen.Wait(0)
	end
end

function ShowContextMenu(data)
    local ContextTable = {
        ["context_1"] = {
            ["ratioscreenx"] = 528.5,
            ["ratioscreeny"] = 523.5,
            ["Rect"] = {
                ["field1"] = {
                    largeur = 390,
                    longueur = 60,
                    posx = 0.396875,
                    posy = 0.470370
                },
                ["finish"] = {
                    largeur = 210,
                    longueur = 60,
                    posx = 0.44375,
                    posy = 0.62037
                }
            },
            ["Text"] = {
                ["title"] = {
                    posx = 0.5,
                    posy = 0.325925,
                },
                ["field1"] = {
                    text = nil,
                    posx = 0.5,
                    posy = 0.425925,
    
                    textindiquerx = 0.5,
                    textindiquery = 0.479629
                }
            }
        },
        ["context_2"] = {
            ["ratioscreenx"] = 528.5,
            ["ratioscreeny"] = 673.5,
            ["Rect"] = {
                ["field1"] = {
                    largeur = 390,
                    longueur = 60,
                    posx = 0.397395,
                    posy = 0.401851
                },
                ["field2"] = {
                    largeur = 390,
                    longueur = 60,
                    posx = 0.396875,
                    posy = 0.572222
                },
                ["finish"] = {
                    largeur = 210,
                    longueur = 60,
                    posx = 0.44375,
                    posy = 0.71037
                }
            },
            ["Text"] = {
                ["title"] = {
                    posx = 0.5,
                    posy = 0.255925,
                },
                ["field1"] = {
                    text = nil,
                    posx = 0.5,
                    posy = 0.357407,
    
                    textindiquerx = 0.5,
                    textindiquery = 0.411111
                },
                ["field2"] = {
                    text = nil,
                    posx = 0.5,
                    posy = 0.525925,
    
                    textindiquerx = 0.5,
                    textindiquery = 0.581481
                }
            }
        },
        ["context_3"] = {
            ["ratioscreenx"] = 528.5,
            ["ratioscreeny"] = 673.5,
            ["Rect"] = {
                ["field1"] = {
                    largeur = 390,
                    longueur = 60,
                    posx = 0.397395,
                    posy = 0.331481
                },
                ["field2"] = {
                    largeur = 390,
                    longueur = 60,
                    posx = 0.396875,
                    posy = 0.461111
                },
                ["field3"] = {
                    largeur = 390,
                    longueur = 60,
                    posx = 0.396875,
                    posy = 0.595370
                },
                ["finish"] = {
                    largeur = 210,
                    longueur = 60,
                    posx = 0.44375,
                    posy = 0.709259
                }
            },
            ["Text"] = {
                ["title"] = {
                    posx = 0.5,
                    posy = 0.224999,
                },
                ["field1"] = {
                    text = nil,
                    posx = 0.5,
                    posy = 0.278703,
    
                    textindiquerx = 0.5,
                    textindiquery = 0.341666
                },
                ["field2"] = {
                    text = nil,
                    posx = 0.5,
                    posy = 0.408333,
    
                    textindiquerx = 0.5,
                    textindiquery = 0.471296
                },
                ["field3"] = {
                    text = nil,
                    posx = 0.5,
                    posy = 0.541666,
    
                    textindiquerx = 0.5,
                    textindiquery = 0.605555
                }
            }
        },
        ["context_4"] = {
            ["ratioscreenx"] = 528.5,
            ["ratioscreeny"] = 773.5,
            ["Rect"] = {
                ["field1"] = {
                    largeur = 390,
                    longueur = 60,
                    posx = 0.397395,
                    posy = 0.273148
                },
                ["field2"] = {
                    largeur = 390,
                    longueur = 60,
                    posx = 0.396875,
                    posy = 0.392592
                },
                ["field3"] = {
                    largeur = 390,
                    longueur = 60,
                    posx = 0.396875,
                    posy = 0.514814
                },
                ["field4"] = {
                    largeur = 390,
                    longueur = 60,
                    posx = 0.396875,
                    posy = 0.63703
                },
                ["finish"] = {
                    largeur = 210,
                    longueur = 60,
                    posx = 0.44375,
                    posy = 0.76703
                }
            },
            ["Text"] = {
                ["title"] = {
                    posx = 0.5,
                    posy = 0.171296,
                },
                ["field1"] = {
                    text = nil,
                    posx = 0.5,
                    posy = 0.225925,
    
                    textindiquerx = 0.5,
                    textindiquery = 0.283333
                },
                ["field2"] = {
                    text = nil,
                    posx = 0.5,
                    posy = 0.344444,
    
                    textindiquerx = 0.5,
                    textindiquery = 0.401851
                },
                ["field3"] = {
                    text = nil,
                    posx = 0.5,
                    posy = 0.467592,
    
                    textindiquerx = 0.5,
                    textindiquery = 0.524074
                },
                ["field4"] = {
                    text = nil,
                    posx = 0.5,
                    posy = 0.593518,
    
                    textindiquerx = 0.5,
                    textindiquery = 0.646296
                }
            }
        }
    }
    DontMovePlayer(true)
    showContext = true
    local CurrentContext = {}
    local contextmenu = "context_"..data.field
    while showContext do
        ShowCursorThisFrame()
        SetMouseCursorSprite(1)
        local spritex, spritey = UI.ConvertToPixel(ContextTable[contextmenu].ratioscreenx, ContextTable[contextmenu].ratioscreeny)
        UI.DrawSpriteNew("ui_context", contextmenu, 0.5, 0.5, spritex, spritey, 0, 255, 255, 255, 255, {
            NoHover = true,
            CustomHoverTexture = false,
            NoSelect = true,
            devmod = false,
            centerDraw = true
        }, function(onSelected, onHovered)
        end)
        for k, v in pairs(ContextTable[contextmenu].Rect) do
            local rectx, recty = UI.ConvertToPixel(v.largeur, v.longueur)
            UI.DrawRect(v.posx, v.posy, rectx, recty, 0, 255, 255, 255, 0, {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false,
                centerDraw = false
            }, function(onSelected, onHovered)
                if onSelected and onHovered then
                    if k == 'finish' then
                        if data.field == #CurrentContext then
                            showContext = false
                            DontMovePlayer(false)
                        else
                            print('You did not fill in everything')
                        end
                    else
                        for x, w in pairs(CurrentContext) do
                            if w.index == k then
                                table.remove(CurrentContext, x)
                            end
                        end
                        local textindiquer = ActiveKeyboard(k, 64)
                        table.insert(CurrentContext, {text = textindiquer, index = k})
                        ContextTable[contextmenu]["Text"][k].text = textindiquer
                    end
                end
            end)
        end
        for k, v in pairs(ContextTable[contextmenu].Text) do
            if v.text and v.text ~= nil then
                UI.DrawTexts(
                    v.textindiquerx, v.textindiquery,
                    v.text,
                    true,
                    0.5,
                    {255, 255, 255, 255},
                    UI.font["RobotoMono-Medium"],
                    true,
                    false
                )
            end
            UI.DrawTexts(
                v.posx, v.posy,
                data[k],
                true,
                0.5,
                {255, 255, 255, 255},
                UI.font["RobotoMono-Medium"],
                true,
                false
            )
        end
        Citizen.Wait(0)
    end
    return CurrentContext
end