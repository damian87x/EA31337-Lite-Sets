#!/usr/bin/env bash
# Script to run optimization tests.
: ${1?"Usage: $0 (dir) (filter)"} || exit 1
set -e
cd -P -- "$(dirname -- "$0")" && pwd -P
ROOT="$(git rev-parse --show-toplevel)"
PATH="$PATH:$ROOT/_scripts:$ROOT/_VM/scripts"
OUT="README.md"

# Find, parse configuration and run the tests.
find "$ROOT/$1" -type f -name "test.ini" -print0 | while IFS= read -r -d '' file; do
  . <(grep = "$file" | sed "s/;/#/g") # Load ini values.
  dir="$(dirname "$file")"
  find "$ROOT/$1" -type f -name "*$2*.rules" -print0 | while IFS= read -r -d '' rule_file; do
    report_base="$(basename "${rule_file%.*}")"
    report_name="${report_base}--${pair}-${deposit}${currency}-${year}year-${spread}spread-${bt_source}-optimization-test"
    run_backtest.sh $3 -v -o -t -e $name -f "$dir/$setfile" -c $currency -p $pair -d $deposit -y $year -s $spread -b $bt_source -r "$report_name" -i "$rule_file" -D "$dir/_optimization_results"
    push_report.sh "Optimization-$report_base" "Optimization results: $report_name"
  done
  gen_report.sh "$dir/_optimization_results" "$OUT"
done
echo "$0 done."
