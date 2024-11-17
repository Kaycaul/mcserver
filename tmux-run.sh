#!/bin/sh

if [ -z "$TMUX" ]; then
    echo "Run this script inside the tmux session \"main\""
    exit 1
fi

# run the mcserver docker compose detatched
docker compose up -d

# set up session and clear window
tmux kill-window -t main:mcserver
tmux new-window -t main -n mcserver

# attach to server, playit, exec rcon-cli, and open bash in the new window
tmux split-window -v -t main:mcserver
tmux split-window -h -t main:mcserver.0
tmux split-window -h -t main:mcserver.2
tmux send-keys -t main:mcserver.0 "docker attach paper" C-m
tmux send-keys -t main:mcserver.1 "docker attach playit" C-m
tmux send-keys -t main:mcserver.2 "sleep 30 ; docker exec -it paper rcon-cli" C-m
