#!/bin/bash
# -----------------------------------------------------------------

# set -x

MYSQL_HOST="localhost"
MYSQL_PORT=3306
MYSQL_USER="user"
MYSQL_PASSWORD=""
MYSQL_DB="first_db"
MYSQL_VERSION="5.7.5"

while getopts d:h:p:s:u:v: opt; do
  case "${opt}" in
      d ) MYSQL_DB="${OPTARG}" ;;
      h ) MYSQL_HOST="${OPTARG}" ;;
      p ) MYSQL_PORT="${OPTARG}" ;;
      u ) MYSQL_USER="${OPTARG}" ;;
      s ) MYSQL_PASSWORD="${OPTARG}" ;;
      v ) MYSQL_VERSION="${OPTARG}" ;;
      * )
          echo "invalid option: -${OPTARG}" >&2
          ;;
  esac
done

shift $(( OPTIND -1 ))

# -----------------------------------------------------------------

exec \
  docker run --name=mysql_cli --rm -it \
    mysql:"${MYSQL_VERSION}" \
      sh -c "exec mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASSWORD} -D${MYSQL_DB}" $*

# -----------------------------------------------------------------
# eof
