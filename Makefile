dyndocs = 01-the-basics-of-stata.qmd	02-working-with-data-sets.qmd \
					03-data-management.qmd	04-data-manipulation.qmd	\
					05-programming.qmd appendix.qmd


.PHONY:default
default: $(dyndocs) ## Build the workshop notes
	quarto render

.PHONY:quarto-prerender
quarto-prerender: $(dyndocs) ## Rebuild only qmd from Stata files
	@echo > /dev/null

$(dyndocs): %.qmd: %.dyndoc ## @ignore
	/Applications/Stata/StataSE.app/Contents/MacOS/stata-se -b 'dyntext "$<", saving("$@") replace nostop'

.PHONY:open
open: ## Open built workshop
	@open docs/index.html

.PHONY:preview
preview: ## Quarto Preview
	quarto preview

.PHONY:clean
clean: ## Remove build files
	rm -rf docs/ $(dyndocs)
