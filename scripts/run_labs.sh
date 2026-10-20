#!/usr/bin/env bash
set -euo pipefail

LAB_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PGHOST="${PGHOST:-localhost}"
export PGPORT="${PGPORT:-5432}"
export PGUSER="${PGUSER:-$(id -un)}"
LAB_DATABASE="${LAB_DATABASE:-database_labworks_20261020}"
export PAGER=cat

if [[ ! "$LAB_DATABASE" =~ ^[a-z][a-z0-9_]{0,43}$ ]]; then
    echo 'Use a database name of 1–44 lowercase letters, digits, or underscores, starting with a letter.' >&2
    exit 1
fi

psql --version
pg_isready -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d postgres
# CREATE DATABASE fails rather than reusing or resetting an existing database.
createdb --maintenance-db=postgres "$LAB_DATABASE"

for week in 01 02 03 04 05 06 07 08; do
    mkdir -p "$LAB_ROOT/week$week/logs"
    echo "Running Week $week in $LAB_DATABASE"
    if [[ "$week" == 02 ]]; then
        {
            psql --version
            pg_isready -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$LAB_DATABASE"
            psql -X -d "$LAB_DATABASE" -v ON_ERROR_STOP=1 -a -P pager=off -f "$LAB_ROOT/week$week/lab.sql"
        } 2>&1 | tee "$LAB_ROOT/week$week/logs/terminal.txt"
    else
        psql -X -d "$LAB_DATABASE" -v ON_ERROR_STOP=1 -a -P pager=off -f "$LAB_ROOT/week$week/lab.sql" 2>&1 | tee "$LAB_ROOT/week$week/logs/terminal.txt"
    fi
done

psql -X -d "$LAB_DATABASE" -v ON_ERROR_STOP=1 -f "$LAB_ROOT/scripts/check_results.sql"

echo "All eight labs passed. Database: $LAB_DATABASE"
