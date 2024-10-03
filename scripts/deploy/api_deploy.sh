#!/bin/bash

mv api/*.tmpl .

source `dirname "$0"`/tools/render_template.sh directus.env.tmpl > api/directus.env
source `dirname "$0"`/tools/render_template.sh postgresql.env.tmpl > api/postgresql.env

source `dirname "$0"`/tools/deploy.sh api
