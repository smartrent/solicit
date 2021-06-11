test-coverage:
	MIX_ENV=test mix coveralls.html 
	open cover/excoveralls.html

deps-graph: 
	mix xref graph --format stats --label compile
	
deps-unused:
	mix deps.unlock --unused
