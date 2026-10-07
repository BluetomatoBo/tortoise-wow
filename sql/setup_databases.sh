#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREATE_SQL="$SCRIPT_DIR/create_databases.sql"
UPDATES_DIR="$SCRIPT_DIR/database_updates"

MYSQL_BIN=""

if command -v mariadb >/dev/null 2>&1; then
  MYSQL_BIN="mariadb"
elif command -v mysql >/dev/null 2>&1; then
  MYSQL_BIN="mysql"
else
  echo "Error: neither mariadb nor mysql client was found in PATH."
  exit 1
fi

echo "Using database client: $MYSQL_BIN"

if [[ ! -f "$CREATE_SQL" ]]; then
  echo "Error: missing $CREATE_SQL"
  exit 1
fi

echo "Importing create_databases.sql..."
"$MYSQL_BIN" < "$CREATE_SQL"

if [[ ! -d "$UPDATES_DIR" ]]; then
  echo "Error: missing database_updates directory."
  exit 1
fi

# The updates live in one folder per database, and the files themselves carry no
# USE statement: each has to be fed to the client with its database selected,
# exactly like mangosd's own auto-updater does.
#
# Reading only "$UPDATES_DIR"/*.sql - which is what this script used to do - finds
# nothing, prints "No SQL update files found" and exits successfully, leaving a
# fresh installation without any of the ~150 updates in those folders (the
# character-side ones alone are missing character_pvp_currency and the
# character_inventory_copy table the honor maintenance needs).
database_for_update_dir() {
  case "$(basename "$1")" in
    logon)     echo "tw_logon" ;;
    character) echo "tw_char" ;;
    world)     echo "tw_world" ;;
    logs)      echo "tw_logs" ;;
    *)         echo "" ;;
  esac
}

shopt -s nullglob
imported=0

for dir in "$UPDATES_DIR"/*/; do
  db="$(database_for_update_dir "$dir")"
  if [[ -z "$db" ]]; then
    echo "Skipping $(basename "$dir"): no database is mapped to that folder." >&2
    continue
  fi

  files=("$dir"*.sql)
  if [[ ${#files[@]} -eq 0 ]]; then
    continue
  fi

  echo "Importing ${#files[@]} update(s) from $(basename "$dir") into $db..."
  for sql_file in "${files[@]}"; do
    echo "  $(basename "$sql_file")"
    "$MYSQL_BIN" "$db" < "$sql_file"
    imported=$((imported + 1))
  done
done

if [[ $imported -eq 0 ]]; then
  echo "No SQL update files found in $UPDATES_DIR"
  exit 0
fi

echo "All $imported SQL update(s) imported successfully."
