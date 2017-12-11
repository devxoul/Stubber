generate:
	./scripts/gencode

project: generate
	swift package generate-xcodeproj
	ruby ./scripts/configure_xcodeproj.rb

test: generate
	swift test
