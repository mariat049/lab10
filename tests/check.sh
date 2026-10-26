#!/usr/bin/env bash
# Автоматична перевірка виконання лабораторної
cd "$(dirname "$0")/.."
source ./config.env
fail=0
ok(){ echo "✅ $1"; }
bad(){ echo "❌ $1"; fail=1; }
chk(){ if eval "$2"; then ok "$1"; else bad "$1"; fi; }

[ "$SURNAME" != "Petrenko" ] && ok "Прізвище змінено у config.env" || bad "Змініть дані у config.env (залишилось прізвище-приклад)"

chk "Каталог $SURNAME існує"            "[ -d '$SURNAME' ]"
chk "Підкаталоги DEE, SEE, SSS"         "[ -d '$SURNAME/DEE' ] && [ -d '$SURNAME/SEE' ] && [ -d '$SURNAME/SSS' ]"
chk "Файл ${FIRSTNAME}.txt у DEE"       "[ -f '$SURNAME/DEE/${FIRSTNAME}.txt' ]"
chk "Файл ${SURNAME}.txt у SSS"         "[ -f '$SURNAME/SSS/${SURNAME}.txt' ]"
chk "Група у файлі ${SURNAME}.txt"      "grep -qF '$GROUP' '$SURNAME/SSS/${SURNAME}.txt'"
chk "Дата у файлі ${SURNAME}.txt"       "grep -qF '$DATE' '$SURNAME/SSS/${SURNAME}.txt'"
chk "Email у файлі ${FIRSTNAME}.txt (regex)" "grep -Eq '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\$' '$SURNAME/DEE/${FIRSTNAME}.txt'"
chk "Файли скопійовано в кореневий каталог" "[ -f '$SURNAME/${FIRSTNAME}.txt' ] && [ -f '$SURNAME/${SURNAME}.txt' ]"
chk "Копії ідентичні оригіналам"        "cmp -s '$SURNAME/DEE/${FIRSTNAME}.txt' '$SURNAME/${FIRSTNAME}.txt' && cmp -s '$SURNAME/SSS/${SURNAME}.txt' '$SURNAME/${SURNAME}.txt'"

if [ -f "$LOGFILE" ]; then
  out=$(bash lab.sh 2>&1)
  exp=$(grep -Ec 'HTTP/[0-9.]+" 404 ' "$LOGFILE")
  chk "Скрипт виводить кількість 404 ($exp)" "echo \"\$out\" | grep -q 'Кількість 404: $exp'"
else
  bad "Лог-файл $LOGFILE відсутній (додайте його в logs/)"
fi

chk "Звіт report/REPORT.md існує"       "[ -s report/REPORT.md ]"
chk "У звіті є посилання на GitHub"     "grep -q 'github.com' report/REPORT.md"

exit $fail
