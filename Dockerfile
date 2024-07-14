FROM elixir:1.17

RUN apt-get update && apt-get upgrade -y

ENV MIX_ENV=prod

WORKDIR /lib

COPY . .

ENTRYPOINT ["mix", "run", "lib/green_days.exs"]

