#!/bin/bash

mv api/*.tmpl .

`dirname "$0"`/tools/render_template.sh directus.env.tmpl > api/directus.env
`dirname "$0"`/tools/render_template.sh postgresql.env.tmpl > api/postgresql.env

source `dirname "$0"`/tools/deploy.sh api
