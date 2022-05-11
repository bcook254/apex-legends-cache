# apex-legends-cache

## What does this file do?
The first time a new player on Linux tries to play Apex Legends it can be a horrible experience. From occasional stuttering when a new shader is cached, to complete freezes and crashes as hundred or thousands of new shaders a processed. These problems also plague long time Apex Legends on Linux players as each new map update has a huge impact on game performance requiring re-rendering of shaders. This repository will hopefully become a large community effort to make Apex Legends on Linux a smooth and enjoyable experience for everyone.

## Why do we need this?
Apex Legends uses the Direct3D 11 rendering engine which is not supported on Linux. Instead, Proton uses DXVK to provide a Vulkan-based implementation of D3D11 and 10. While this works great for most games, some have a lot of shaders that need to be accessed while you play the game. The Valve team handles most of the pre-caching of these shaders from community sourced files, but they do not distribute this one file which assists with accessing these pre-cached shaders. A more detailed explanation of what goes on behind the scenes can be found in this [r/linux\_gaming thread](https://www.reddit.com/r/linux_gaming/comments/t5xrho/comment/hz8bae5/).

Instead of each player having to drop in multiple times with unplayable rendering lag and stutter, we can combine the efforts of multiple Apex Legends players by combining our dxvk-cache files using the [dxvk-cache-tool](https://github.com/DarkTigrus/dxvk-cache-tool) created by [DarkTigrus](https://github.com/DarkTigrus). Lutris provides a build of this tool [here](https://lutris.nyc3.cdn.digitaloceanspaces.com/games/overwatch/merge-tool.tar.xz).

This effort was originally started by [u/ryao](https://www.reddit.com/user/ryao/) in this [r/linux\_gaming thread](https://www.reddit.com/r/linux_gaming/comments/t5xrho/dxvk_state_cache_for_fixing_stutter_in_apex/). This thread worked well for a while but will eventually get lost in the history of the subreddit and may not be easy to find, especially for new players. Additionally, the history of the cache file is not readily available and cannot be quickly reverted in the event of a bad merge. This repository will also add more transparency to each merge, make it easier to give credit to each contributed, and can be more easily forked/transferred should I or any future maintainers decide to stop working on this project.

## Using this file
View the [r5apex.dxvk-cache file](https://github.com/bcook254/apex-legends-cache/blob/main/r5apex.dxvk-cache) in this repository and click the Download button in the top right hand corner. You can also use [this link](https://github.com/bcook254/apex-legends-cache/raw/main/r5apex.dxvk-cache) to directly download the file to your computer. Copy the downloaded file to your Apex Legends shadercache folder located at `/path/to/steamapps/shadercache/1172470/DXVK_state_cache/r5apex.dxvk-cache`. By default this location is `~/.local/share/Steam/steamapps/shadercache/1172470/DXVK_state_cache/r5apex.dxvk-cache`. That's it!

You could also clone this repository to your local machine and either manually or automatically pull each update and copy your local repository files to the same location listed above. This does require installing and setting up git and git-lfs for which there are many guides available online.

## Contributing cache files
Fork this repository and clone it to your local machine. You will need git-lfs set up to track the cache file. Use the dxvk-cache-tool available [here](https://lutris.nyc3.cdn.digitaloceanspaces.com/games/overwatch/merge-tool.tar.xz) to combine the current [r5apex.dxvk-cache file](https://github.com/bcook254/apex-legends-cache/blob/main/r5apex.dxvk-cache) in the repository with your local r5apex.dxvk-cache file. __Create a new commit with a commit message containing the current unix timestamp.__ An example workflow might look something like this.

Copy your local cache file to the location of the repository cache file.

    cp ~/.local/share/Steam/steamapps/shadercache/1172470/DXVK_state_cache/r5apex.dxvk-cache ./r5apex-local.dxvk-cache

Merge your repository cache file with your local cache file. __Make a note of the number of entries added by your file!__

    dxvk-cache-tool ./r5apex.dxvk-cache ./r5apex-local.dxvk-cache

Rename the output cache file.

    mv ./output.dxvk-cache ./r5apex.dxvk-cache

Add the new file, commit, and push to your repository.

    git add r5apex.dxvk-cache
    git commit -m "$(date +%s)"
    git push origin main

Create a pull request on this repository __and make sure to include the number of new entries this request will add to the cache file! It will be cool to see the number of entries we can add over time!__

## Contributions
### Cache Files
[u/ryao](https://www.reddit.com/u/ryao/) (original maintainer on r/linux_gaming)  
[u/Melon__Bread](https://www.reddit.com/u/Melon__Bread/)  
[u/najodleglejszy](https://www.reddit.com/u/najodleglejszy/)  
[u/PsychologicalLog1090](https://www.reddit.com/u/PsychologicalLog1090/)  
[u/a9dnsn](https://www.reddit.com/u/a9dnsn/)  
[u/LilCalosis](https://www.reddit.com/u/LilCalosis/)  
[u/Flubberding](https://www.reddit.com/u/Flubberding/)  
[u/AnyEntertainment8080](https://www.reddit.com/u/AnyEntertainment8080/)  
[u/arvind-d](https://www.reddit.com/u/arvind-d/)  
[u/DAVE_nn](https://www.reddit.com/u/DAVE_nn/)  
[u/yourfavrodney](https://www.reddit.com/u/yourfavrodney/)  
[u/jumper775](https://www.reddit.com/u/jumper775/)  
[u/Tiflotin](https://www.reddit.com/u/Tiflotin/)  
[u/NineBallAYAYA](https://www.reddit.com/u/NineBallAYAYA/)  
[u/CaptainKrisss](https://www.reddit.com/u/CaptainKrisss/)  
[u/Nik0ne](https://www.reddit.com/u/Nik0ne/)  
[u/Tenshar](https://www.reddit.com/u/Tenshar/)  
[u/-ThunderFox](https://www.reddit.com/u/-ThunderFox/) - 3604 entries  
[u/EpicCreeper713](https://www.reddit.com/u/EpicCreeper713/)  
[u/Kitchen-Drop236](https://www.reddit.com/u/Kitchen-Drop236/)  
[u/SneakySnk](https://www.reddit.com/u/SneakySnk/)  
[u/K1f0](https://www.reddit.com/u/K1f0/)  
[u/gudhost](https://www.reddit.com/u/gudhost/)  
[u/wanna_play_r5](https://www.reddit.com/u/wanna_play_r5/)  
[u/baryluk](https://www.reddit.com/u/baryluk/)  
[u/sP6awFXL94V6vH7C](https://www.reddit.com/u/sP6awFXL94V6vH7C/)  

## Thank You!
This would not be possible without everyone who originally contributed to this file when Apex Legends first supported Linux and could not continue to be possible without each contribution and user from the community.

__Together, we will slátra our enemies.__
