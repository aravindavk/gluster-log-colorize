dev:
	dmd app.d -of=gluster-log-colorize
prod:
	ldmd2 -O -inline -release -version=StdLoggerDisableTrace app.d -of=gluster-log-colorize
