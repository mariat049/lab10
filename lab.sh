#!/usr/bin/env bash
# Лабораторна: дерево каталогів, файли, копіювання, перевірка email, пошук 404
set -euo pipefail
cd "$(dirname "$0")"
source ./config.env

ROOT="$SURNAME"

# 9. Дерево: AAA -> LAA/GR1, LAA/GR2, LBB, LCC
mkdir -p "$ROOT/LAA/GR1" "$ROOT/LAA/GR2" "$ROOT/LBB" "$ROOT/LCC"
# GR1: файл з іменем -> електронна пошта
echo "$EMAIL" > "$ROOT/LAA/GR1/${FIRSTNAME}.txt"
# GR2: файл з прізвищем -> група та дата
printf '%s\n%s\n' "$GROUP" "$DATE" > "$ROOT/LAA/GR2/${SURNAME}.txt"

# 10. Копіювання файлів у кореневий каталог (AAA)
cp "$ROOT/LAA/GR1/${FIRSTNAME}.txt" "$ROOT/"
cp "$ROOT/LAA/GR2/${SURNAME}.txt"   "$ROOT/"

# 11. Перевірка email регулярним виразом
RE='^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
if grep -Eq "$RE" "$ROOT/LAA//GR1/${FIRSTNAME}.txt"; then
  echo "[OK] У файлі ${FIRSTNAME}.txt міститься коректна електронна пошта"
else
  echo "[ERR] У файлі ${FIRSTNAME}.txt немає коректної електронної пошти"
  exit 1
fi

# 13. Помилки 404 в Apache-логах
if [ -f "$LOGFILE" ]; then
  PATTERN='HTTP/[0-9.]+" 404 '
  echo "Повідомлення 404:"
  grep -E "$PATTERN" "$LOGFILE" || true
  echo "Кількість 404: $(grep -Ec "$PATTERN" "$LOGFILE" || true)"
else
  echo "[WARN] Лог-файл $LOGFILE не знайдено"
fi
