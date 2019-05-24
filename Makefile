help:
	@echo "dev - Development Build"
	@echo "archive - Archive the binary"

dev:
	dub build

release:
	./release.sh
