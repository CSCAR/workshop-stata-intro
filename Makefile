dyndocs = 01-the-basics-of-stata.qmd	02-working-with-data-sets.qmd \
					03-data-management.qmd	04-data-manipulation.qmd	\
					05-programming.qmd appendix.qmd


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
