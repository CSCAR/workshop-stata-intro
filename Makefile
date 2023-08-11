dyndocs = stata.qmd

.PHONY:default
default: $(dyndocs)
	quarto render

.PHONY:quarto-prerender
quarto-prerender: $(dyndocs)
	@echo > /dev/null

$(dyndocs): %.qmd: %.dyndoc
	/Applications/Stata/StataSE.app/Contents/MacOS/stata-se -b 'dyntext "$<", saving("$@") replace nostop'
