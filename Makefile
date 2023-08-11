dyndocs = 02-the-basics-of-stata.qmd	03-working-with-data-sets.qmd \
					04-data-management.qmd	05-data-manipulation.qmd	\
					06-programming.qmd 07-appendix.qmd


.PHONY:default
default: $(dyndocs)
	quarto render

.PHONY:quarto-prerender
quarto-prerender: $(dyndocs)
	@echo > /dev/null

$(dyndocs): %.qmd: %.dyndoc
	/Applications/Stata/StataSE.app/Contents/MacOS/stata-se -b 'dyntext "$<", saving("$@") replace nostop'

.PHONY:open
open:
	@open docs/index.html
