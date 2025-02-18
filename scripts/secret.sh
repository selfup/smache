# generates a strong secret and rpc cookie

echo 'GENERATING SECRET_KEY_BASE AND COOKIE'

echo "" > .env

SECRET=$(mix phx.gen.secret)
COOKIE=$(mix phx.gen.secret)

echo "SECRET_KEY_BASE='${SECRET}'" >> .env
echo "COOKIE='${COOKIE}'" >> .env

echo 'SECRETS JOB DONE'
