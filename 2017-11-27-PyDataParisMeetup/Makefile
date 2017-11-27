

build:
	mkdir -p docs/theme/
	reveal-md Meetup.md --static docs
	cp -r theme/* docs/theme/
	#cp *.png *.jpg docs/
watch: build
	reveal-md -w Meetup.md 

