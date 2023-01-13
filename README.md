![Group 2 (12)](https://user-images.githubusercontent.com/76072277/212425057-347f91da-c8cf-4ae8-bd9a-90049860f770.png)

[![Love](http://ForTheBadge.com/images/badges/built-with-love.svg)]() [![name](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://forum.cfx.re/t/realistic-vehicle-failure-repair-fix/4887760/2) [![name](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/channel/UCH7coJ4d1gqh8BMMHacGQ5A) [![LUA](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/azeroth)

# Installation
    curl https://github.com/Azerothwav/Az_context

# Informations
An optimized and totally open source context menu for your FiveM server.

The az_context is the first open source context menu realized without HTML. Using the drawText, drawSprite and drawRectangle that GTA allows us to generate.
The contextual menu allows you to generate up to 4 fillable fields. See the [documentation](https://app.gitbook.com/o/LxKye6vVccygPAOaaogf/s/EabMaragdnJ0EoBRIgs6/az_context/useful) to learn how to use it.

The resource is completely standalone.

# Exemple
## Code view
    -- Show context menu and stock data in the variable
    local contextData = exports["az_context"]:ShowContextMenu({
        title = 'Job setting', 
        field = 1, 
        field1 = 'Job name :',
        field2 = 'Job name :'
    })
    
    -- Print the data
    print(contextData[1].text, contextData[2].text)

## In game view
![image](https://user-images.githubusercontent.com/76072277/195984316-3695af8a-374c-4d01-9c91-b2cf30f53474.png)
