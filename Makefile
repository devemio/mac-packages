upd := ./run.sh

all:
	@$(upd) omz && $(upd) brew && $(upd) casks && $(upd) npm && $(upd) composer
