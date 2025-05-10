export XDG_CONFIG_HOME=~/gothic/.config
if uwsm check may-start && uwsm select; then
	exec uwsm start default
fi
