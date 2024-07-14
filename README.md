# GreenDays

There are lots of recruiters and engineering managers that filter candidates based solely on their github contribution frequency (not the actual quality of commits).

As developers, we can trick them, by creating a series of empty commits, with different date times.
This way, our github profile will look fabulously green!

### Installation

As this project is built using `.devcontainers`, all you need to do is `Ctrl+Shift+P` in your VSCode and select `Dev Containers: Rebuild and Open in container`.

If you are using an editor that does not support `devcontainers` out of the box, you can use the related npm package, maintained by the microsoft team.

OR! you can go vintage by installing Erlang 27 and Elixir 1.17 built by Erlang 27 (it may work with different versions but I haven't -or wanted to- test it, that's why we use docker)

### Usage

when inside the container
1. `mix escript.build`
2. `./green_days --max-commits=5 --skip-weekends=false --years=2`

this will create at most 5 commits per day, for every day (including weekends), for the past 2 years
I've added the option to skip weekends, in order to show more professional, as you will work for 5 days per week :P
