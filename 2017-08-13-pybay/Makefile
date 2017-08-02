

build:
	mkdir -p docs/theme/
	reveal-md pycon.md --static docs
	cp theme/pycon.css docs/theme/
	cp *.png *.jpg docs/
watch: build
	reveal-md -w pycon.md 

