#!/bin/sh

# default session name, personal preference
DEFAULT_SESSION="main"

if [ -z "$TMUX" ]; then
    # open a session with the default name if it doesnt exist
    SESSION=$DEFAULT_SESSION
    tmux new-session -d -s $SESSION
else
    # get the name of the current session
    SESSION=$(tmux display-message -p '#S')
fi

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
tmux send-keys -t $SESSION:mcserver.2 "docker exec -it paper rcon-cli" C-m

# attach to session if not already in tmux
if [ -z "$TMUX" ]; then
    tmux attach -t $SESSION
fi