#!/bin/bash

source tools/deploy_functions.sh

mv api/*.tmpl .

.github/scripts/tools/render_template.sh directus.env.tmpl > api/directus.env
.github/scripts/tools/render_template.sh postgresql.env.tmpl > api/postgresql.env

deploy api
