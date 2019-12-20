#!Makefile

HUGO=hugo
SPONSORDOCLATEST:=$(shell curl -s https://api.github.com/repos/loadays/sponsordoc/releases/latest | grep '"browser_download_url":' | awk '{print $$2}' | sed 's/"//g')

.PHONY: sponsordoc build serve draft clean

default all: sponsordoc build

sponsordoc:
	@echo $(SPONSORDOCLATEST)
	@curl -sL $(SPONSORDOCLATEST) -o static/files/sponsordoc.pdf

build:
	$(HUGO) --minify
	@find public/ -name '*.html' ! -name '*.gz' -type f -exec sh -c "gzip -c -9 < {} > {}.gz" \;
	@find public/ -name '*.css' ! -name '*.gz' -type f -exec sh -c "gzip -c -9 < {} > {}.gz" \;
	@find public/ -name '*.js' ! -name '*.gz' -type f -exec sh -c "gzip -c -9 < {} > {}.gz" \;

giggity:
	#@gzip -9 -c static/schedule/giggity.json > static/schedule/giggity.json.gz
	#@qrencode -t SVG -o static/schedule/giggity.svg -l H -Sv 3 < static/schedule/giggity.json
	#@qrencode -t SVG -o static/schedule/ical.svg -l H 'https://cfgmgmtcamp.eu/schedule/schedule.ics'
	#@echo "" > public/schedule/schedule.ics
	#@test -s public/schedule/monday/index.ics && head -n -1 public/schedule/monday/index.ics >> public/schedule/schedule.ics
	#@test -s public/schedule/tuesday/index.ics && tail -n +9 public/schedule/tuesday/index.ics >> public/schedule/schedule.ics
	#@sed -e '/^$$/d' -i public/schedule/schedule.ics
	#@unix2dos public/schedule/schedule.ics public/schedule/schedule.ics

travis:
	$(MAKE) HUGO=./hugo build

draft:
	$(HUGO) --minify --buildDrafts --buildFuture --buildExpired

serve:
	$(HUGO) --minify
	$(HUGO) server --disableFastRender

clean:
	@rm -rf public/
