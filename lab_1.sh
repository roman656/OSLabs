#!/bin/bash

# Форматтер.
shfmt -w -i 4 $(pwd)

task_1() {
    # Путь до файла, у которого будут меняться права.
    path="/usr/bin/ls"

    # Вывод информации о файле. -l выведет больше информации:
    # тип файла, права доступа к файлу,
    # количество жестких ссылок на файл,
    # владелец файла, файловая группа,
    # размер файла, дата создания, имя файла.
    ls -l $path

    # Изменение прав доступа к файлу.
    # o-x - запретить выполнение для остальных пользователей.
    chmod o-x $path
    ls -l $path
    chmod o+x $path
    ls -l $path
}

task_2() {
    # ps -e --sort -rss выберет все процессы и отсортирует их по количеству используемой памяти.
    # RSS - реальный размер процесса в памяти.
    # head -n 3 выведет первые 3 строки.
    ps -e --sort -rss | head -n 3

    # Получение PID процесса, занимающего больше всего памяти.
    # -o -> свой формат вывода.
    # xargs читает аргументы из стандартного ввода, разделенные пробелами или символами новой строки,
    # и выполняет указанную команду, используя входные данные в качестве аргументов команды.
    # Если команда не указана, по умолчанию используется /bin/echo.
    pid=$(ps -eo pid= --sort -rss | head -n 1 | xargs)

    # Даем возможность выбрать действие.
    # -p -> для использования строки приглашения.
    read -p "Завершить принудительно процесс (PID = $pid) [y/n]: " answer
    case $answer in
    [YyДд]*)
        kill $pid # SIGTERM
        echo "Дело сделано"
        ps -e --sort -rss | head -n 3
        ;;
    [NnНн]*) echo "Ладно" ;;
    *) echo "Введено что-то другое, но я сделаю вид, что это n" ;;
    esac
}

task_3() {
    # Поиск 5 самых больших файлов.
    # -type f - искать только файлы.
    # -exec du -> выполняет команду du.
    # Все символы, следующие за командой, считаются ее аргументами до того момента, как встречается символ ";".
    # Строка "{}" заменяется на имя рассматриваемого файла каждый раз,
    # когда она встречается среди аргументов команды.
    # du - выведет размер файла и имя.
    # sort -r -> отсортировать в обратном порядке.
    # awk '{print $2}' -> выборка второй колонки (пути к файлам).
    # print(строка) - вывод чего либо в стандартный поток вывода.
    # $ - ссылка на колонку по номеру.
    files=$(find /home/someusr/ -type f -exec du {} ';' | sort -rh | head -n 5 | awk '{print $2}')

    for i in ${files[@]}; do
        rm -i "$i" # Выводить запрос на подтверждение удаления каждого файла.
    done
}

lab_1() {
    echo "Задача 1."
    task_1
    echo -e "\nЗадача 2." # -e - включить поддержку вывода escape последовательностей.
    task_2
    echo -e "\nЗадача 3."
    task_3
}

lab_1
