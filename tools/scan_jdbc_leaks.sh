#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SRC_DIR="${REPO_ROOT}/src/main/java"
REPORT_DIR="${REPO_ROOT}/out"
REPORT_FILE="${REPORT_DIR}/jdbc_scan_report.txt"
mkdir -p "${REPORT_DIR}"
count_pattern() {
  local pattern="$1"
  # shellcheck disable=SC2086
  grep -R --include='*.java' -o "${pattern}" "${SRC_DIR}" 2>/dev/null | wc -l | tr -d ' '
}
PREPARE_COUNT=$(count_pattern 'prepareStatement(')
EXECUTE_QUERY_COUNT=$(count_pattern 'executeQuery(')
EXECUTE_UPDATE_COUNT=$(count_pattern 'executeUpdate(')
TRY_CONNECTION_COUNT=$(grep -R --include='*.java' -o 'try (Connection' "${SRC_DIR}" 2>/dev/null | wc -l | tr -d ' ')
{
  echo "JDBC usage quick scan"
  echo "===================="
  echo "prepareStatement occurrences : ${PREPARE_COUNT}"
  echo "executeQuery occurrences     : ${EXECUTE_QUERY_COUNT}"
  echo "executeUpdate occurrences    : ${EXECUTE_UPDATE_COUNT}"
  echo "try-with Connection patterns : ${TRY_CONNECTION_COUNT}"
  echo
  echo "Manual close hotspots"
  echo "---------------------"
  if grep -R --include='*.java' -nE '\\b(conn|ps|rs)\\.close\\(' "${SRC_DIR}" 2>/dev/null; then
    :
  else
    echo "(no manual close() calls detected)"
  fi
} > "${REPORT_FILE}"
echo "Report written to ${REPORT_FILE}"
