

build:
	mkdir -p docs/theme/
	reveal-md pybay.md --static docs
	cp theme/pybay.css docs/theme/
	cp *.png *.jpg docs/
watch: build
	reveal-md -w pybay.md 
pdf:
	reveal-md pybay.md --print slides.pdf

