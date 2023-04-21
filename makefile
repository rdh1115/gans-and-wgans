REPO_NAME := $(shell basename `git rev-parse --show-toplevel` | tr '[:upper:]' '[:lower:]')
DOCKER_REGISTRY := mathematiguy
IMAGE := ${REPO_NAME}.sif
RUN ?= singularity exec ${FLAGS} --nv ${IMAGE}
FLAGS ?=  -B $$(pwd):/code --pwd /code
SINGULARITY_ARGS ?=

.PHONY: sandbox container shell root-shell docker docker-push docker-pull enter enter-root

report:
	${RUN} bash -c "latexmk ArsClassica.tex -pdf"

env:
	. /opt/venv/bin/activate

crawl:
	${RUN} bash -c '. /opt/venv/bin/activate && scrapy crawl aclcrawler -L INFO'

JUPYTER_PASSWORD = $(shell $(RUN) bash -c '. /opt/venv/bin/activate && python3 -c "from notebook.auth import passwd; print(passwd('jupyter', 'sha1'))")
jupyter:
	${RUN} bash -c '. /opt/venv/bin/activate && jupyter lab --ip 0.0.0.0 --port=8888 --NotebookApp.password=$(JUPYTER_PASSWORD)'

REMOTE ?= cn-f001
push:
	rsync -rvahzP ${IMAGE} ${REMOTE}.server.mila.quebec:${SCRATCH}

container: ${IMAGE}
${IMAGE}:
	sudo singularity build ${IMAGE} ${SINGULARITY_ARGS} Singularity

shell:
	singularity shell ${FLAGS} ${IMAGE} ${SINGULARITY_ARGS}

root-shell:
	sudo singularity shell ${FLAGS} ${IMAGE} ${SINGULARITY_ARGS}
