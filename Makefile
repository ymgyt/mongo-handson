NEXTEST_PROFILE ?= default

test:
	make compose-up
	make setup
	make cargo-test

compose-up:
	docker compose down
	docker compose up --detach

setup:
	bash ./scripts/wait_mongo.sh

cargo-test:
	RUST_LOG=debug cargo nextest run --profile ${NEXTEST_PROFILE} --no-capture

.PHONY: test compose-up setup cargo-test
