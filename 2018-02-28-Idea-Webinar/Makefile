object = idea.md

build:
	mkdir -p docs/theme/
	reveal-md $(object) --static docs
	cp -r theme/* docs/theme/
	#cp *.png *.jpg docs/
watch: build
	reveal-md -w $(object) 
pdf: 
	reveal-md $(object) --print slides.pdf
