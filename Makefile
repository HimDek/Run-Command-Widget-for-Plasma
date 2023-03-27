runcommand: contents/* LICENSE* metadata.*
	zip -FS -r -v runcommand.plasmoid contents LICENSE* metadata.*
clean:
	rm *.plasmoid