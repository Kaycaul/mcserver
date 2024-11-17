#!/bin/sh

if [ -z "$TMUX" ]; then
    echo "Error: Run this script inside a tmux session."
    exit 1
fi

SESSION=$(tmux display-message -p '#S')

# run the mcserver docker compose detatched
docker compose up -d

# set up session and clear window
tmux kill-window -t $SESSION:mcserver
tmux new-window -t $SESSION -n mcserver

# attach to server, playit, exec rcon-cli, and open bash in the new window
tmux split-window -v -t $SESSION:mcserver
tmux split-window -h -t $SESSION:mcserver.0
tmux split-window -h -t $SESSION:mcserver.2
tmux send-keys -t $SESSION:mcserver.0 "docker attach paper" C-m
tmux send-keys -t $SESSION:mcserver.1 "docker attach playit" C-m
tmux send-keys -t $SESSION:mcserver.2 "sleep 30 ; docker exec -it paper rcon-cli" C-m
