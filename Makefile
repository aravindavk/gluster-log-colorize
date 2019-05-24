help:
	@echo "dev     - Development build"
	@echo "release - Prepare for the release"
	@echo "clean   - Clean the build"

dev:
	dub build --compiler=dmd

release:
	./release.sh

clean:
	rm -f gluster-log-colorize
	rm -f *.tar.xz
