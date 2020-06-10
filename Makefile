SOURCE="https://www.tagspaces.org/downloads/tagspaces-linux64.AppImage"
OUTPUT="TagSpaces.AppImage"


all:
	echo "Building: $(OUTPUT)"
	rm -f ./$(OUTPUT)
	wget --output-document=$(OUTPUT) --continue $(SOURCE)
	chmod +x $(OUTPUT)

