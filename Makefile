.PHONY: build test record report

build:
	docker compose build

test:
	docker compose run --rm pw

record:
	@if [ -n "$(URL)" ]; then \
		slug=$$(echo "$(URL)" | sed 's/[^a-zA-Z0-9]//g'); \
		timestamp=$$(date +%Y%m%d-%H%M); \
		echo "TARGET_URL=$(URL)" > .env; \
		echo "OUT_FILE=tests/$${slug}_$${timestamp}.spec.js" >> .env; \
	elif [ ! -f .env ]; then \
		echo "Fehler: Keine .env gefunden. Starte mit: make record URL=https://example.com"; \
		exit 1; \
	fi
	docker compose run --rm --service-ports pw_record

report:
	open playwright-report/index.html || xdg-open playwright-report/index.html
