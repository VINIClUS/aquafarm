#!/usr/bin/env bash
set -o errexit

echo "===> Installing gems"
bundle install --without development test

#echo "===> Preparing DB (migrate)"
# Usa DATABASE_URL em produção
#bundle exec rails db:migrate

echo "===> Precompiling assets (se existirem)"
# Se for API-only, ignora sem falhar
bundle exec rails assets:precompile 2>/dev/null || echo "No assets to precompile"

# Opcional: rode seeds só na primeira vez definindo RUN_SEEDS=true nas variáveis de ambiente
#if [ "${RUN_SEEDS:-false}" = "true" ]; then
#  echo "===> Seeding database"
#  bundle exec rails db:seed
#fi

#bundle exec puma -C config/puma.rb