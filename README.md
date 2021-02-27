# Roblox-Rojo-Bundle

Roblox-Rojo-Bundle is a Rojo project template that facilitates the development and build of Roblox projects. It allows you to concatenate and minify all your script's dependencies.

## Dependencies

- [Rojo](https://rojo.space/docs/installation/)
- [Node.js/Npm](https://nodejs.org/en/download/)
- [Git](https://git-scm.com/downloads)

## How to use in a new project

If you are starting a new project, just clone that repository and, if you wish, [publish to your private repository](https://gist.github.com/0xjac/85097472043b697ab57ba1b1c7530274)

In the terminal, install the dependencies with `npm install`

For execution and build see the topic **Workflow**

### How to use in an existing Rojo project

> IMPORTANT! Make a backup of your project before

If you already use Rojo, copy the files `build.json`,` build.js` and `package.json` to your project.

The `build.js` file uses the Rojo configuration file (`default.project.json`), make a comparison with your configuration file

In the terminal, install the dependencies with `npm install`

For execution and build see the topic **Workflow**


## Workflow

### Development

During the development of your project you will use the root directory. Just start the
`rojo serve` through the terminal and connect to Roblox Studio.

This project configures Rojo (`default.project.json`) as follows:

|     Local     |     Roblox    | Description   |
| ------------- | ------------- | ------------- |
|**`src/Client`**| [`StarterPlayerScripts`](https://developer.roblox.com/en-us/api-reference/class/PlayerScripts) | Your client-side scripts |
|**`src/Server`**| [`ServerScriptService`](https://developer.roblox.com/en-us/api-reference/class/ServerScriptService) | Your server-side scripts |
|**`src/Shared`**| [`ReplicatedStorage`](https://developer.roblox.com/en-us/api-reference/class/ReplicatedStorage) | Common modules, which can be used by the client and the server |
|**`src/Workspace`**| `game.Workspace` | Never put scripts here |
|**`src/ServerStorage`**| [`ServerStorage`](https://developer.roblox.com/en-us/api-reference/class/ServerStorage) | Avoid placing scripts here, prefer **`src/Server`**  |
|**`src/CharacterScripts`**| [`StarterCharacterScripts`](https://developer.roblox.com/en-us/api-reference/class/StarterCharacterScripts) | Avoid placing scripts here, prefer **`src/Client`** |


### Test

After developing its functionality, just generate the build (`npm run-script build` or `node. / Build.js`) and test it in Roblox Studio.

After that, in the `build` directory run `rojo serve` and connect via Roblox Studio

### Production

After carrying out the local tests and ensuring that nothing has broken, you can copy only the generated/minified scripts to the final Place and finally publish this on Roblox.


## Configuration

The `build.json` file has the following configuration parameters:

```json
{
   "minify": false,
   "maxSize": 153600,
   "compressStrings": true,
   "compressFields": true,
   "entries": [
      "src/Client/GameClient.client.lua",
      "src/Server/GameServer.server.lua"
   ],
   "dontIgnoreVarDir": [
      "src/CharacterScripts",
      "src/Shared/Meshes"
   ]
}
```

Where:

- **`minify`** : Indicates whether the build should be minified. Use `false` for debugging and troubleshooting
- **`maxSize`** : Preferences for the maximum size of the generated files. If the files concatenation is greater than this value, build.js automatically breaks into smaller pieces. Roblox imposes a limitation of ~ 195.3Kb (199999 bytes) for strings, and therefore for Scripts created by Rojo. The default value is 150 * 1024 = 153600.
- **`entries`** : The input scripts. It is recommended that your game has only one main file on the client and another on the server side. The configuration of other main files can be useful for the generation of custom builds to be used as tools (Ex. Generate a build of your engine that has only the part that animates the weapons to facilitate the work of an animator, who can use this minimal script to do the tests, without the need to run the entire project)
- **`compressStrings`** : When true it makes the safe replacement of all existing strings in the code. If the replacement result is to generate a larger code, that specific replacement is ignored
- **`compressFields`** : When true it makes the safe substitution of the attributes of variables existing in the code. If the replacement result is to generate a larger code, that specific replacement is ignored
- **`dontIgnoreVarDir`** : The build script, when it identifies that a variable is a directory, by default it removes it from the final script. This behavior is expected since we generally save directories as variables just to make it easier to use multiple `require`. However, sometimes our script will actually use that directory. Here you must indicate which directories should not be ignored in the final script
   - Ex: 
      ```lua
      -- The "UtilServices" variable is only used to facilitate the import of scripts, 
      -- so it must be reassembled
      local UtilServices = game.ReplicatedStorage:WaitForChild('Utils')

      local MyUtilService = require(UtilServices:WaitForChild('MyUtilService'))
      local MyMathService = require(UtilServices:WaitForChild('MyUtilService'))
      ```
   - Ex2: 
      ```lua
      -- The "Meshes" variable in this case is a directory used by the GetMesh method 
      -- so it must remain
      local Meshes = game.ReplicatedStorage:WaitForChild('Meshes')

      local function GetMesh(name, clone)
         local mesh = Meshes:FindFirstChild(name)
      end
      ```

## Frequently Asked Questions and Problems

- I'm in trouble, I need to debug
   - If the generation of minified files caused problems, edit the `build.json` file and set `minify = false`. After that, perform a new build (`npm run-script build`), start `rojo serve` and connect via Roblox Studio. This way it will be easier to identify the problem that is happening.
- Rojo generated an empty file in Roblox Studio
   - The generated file size goes over 195kb, change the **`maxSize`** setting to a smaller value and redo the build
- Rojo doesn't work
   - [See Rojo documentation](https://rojo.space/docs/help/)
- Minification error
   - [Luamin](https://github.com/mathiasbynens/luamin) does not support [Luau typing](https://roblox.github.io/luau/typecheck.html)
- The `MeshId` property of the` MeshPart` is empty
   - Yes, this is a headache. It is not possible to modify the `MeshId` via Script, so Rojo cannot create the objects. To get around this problem I use the following strategies:
   1. If the Mesh can be replaced with a [SpecialMesh](https://developer.roblox.com/en-us/api-reference/class/SpecialMesh), I use this
   2. If not, I export my Meshes to the `Meshes` directory (In Roblox Studio, right click on the object` Save to file ... `, format` Roblox XML Model files .rbxmx`)
      - Whenever in the code I need to use a Mesh, in Roblox Studio I import `.rbxmx` into the `ReplicatedStorage/Meshes` directory (Right button `Insert from file ...`) and in my code I use the `GetMesh` method which is available at `src/Shared/Meshes/GetMesh.lua`
- A dependency is being duplicated at each entry point (`entries`)
   - Yes, this is the default behavior. Unfortunately in the current model it is not possible to reference a module without concatenating it in the final script. This build process assumes that each entry point is an independent, self-contained flow.
   - A solution to your problem can be: Make the other script being used as an entry point into a `ModuleScript` and import it into the main script (single entry point). In this way, the dependencies will be shared

## Contributing

You can contribute in many ways to this project.

### Translating and documenting

I'm not a native speaker of the English language, so you may have noticed a lot of grammar errors in this documentation.

You can FORK this project and suggest improvements to this document (https://github.com/nidorx/roblox-rojo-bundle/edit/master/README.md).

If you find it more convenient, report a issue with the details on [GitHub issues].

### Reporting Issues

If you have encountered a problem with this component please file a defect on [GitHub issues].

Describe as much detail as possible to get the problem reproduced and eventually corrected.

### Fixing defects and adding improvements

1. Fork it (<https://github.com/nidorx/roblox-rojo-bundle/fork>)
2. Commit your changes (`git commit -am 'Add some fooBar'`)
3. Push to your master branch (`git push`)
4. Create a new Pull Request

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).


[GitHub issues]: https://github.com/nidorx/roblox-rojo-bundle/issues
