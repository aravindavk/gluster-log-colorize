dev:
	dmd app.d -of=gluster-log-colorize
prod:
	ldc2 -release -O app.d -of=gluster-log-colorize
