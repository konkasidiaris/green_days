docker run --rm -it \
  --network="host" \
  -u $(id -u):$(id -g) \
  -v $HOME/.gitconfig:/.gitconfig:ro \
  -v $HOME/.ssh:/.ssh:ro \
  -v $HOME/.gnupg:/.gnupg:ro \
  -v /run/user/$(id -u)/gnupg:/run/user/$(id -u)/gnupg \
  -v $(pwd):/app \
  -w /app \
  green_days $@ 
  # --entrypoint /bin/sh \
