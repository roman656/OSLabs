#!/bin/bash

# Форматтер.
shfmt -w -i 4 $(pwd)

backup() {
    # Путь до директории, бекап которой необходимо произвести.
    path_from="/home/roman/Projects/Active/Bash/data/"

    # То, куда все будет сохранено.
    path_to='karelia@mati.su:/home/karelia/www/karelia.mati.su/temp/'

    # Непосредственно бекап.
    # -a - режим архивирования, когда сохраняются все атрибуты оригинальных файлов;
    # -z - сжимать файлы перед передачей;
    # -e - использовать другой транспорт, например, ssh;
    # -v - выводить подробную информацию о процессе копирования.
    rsync -azve ssh $path_from $path_to
}

restore() {
    # То, где лежит бекап.
    path_from='karelia@mati.su:/home/karelia/www/karelia.mati.su/temp/'

    # Путь до директории, которую необходимо восстановить.
    path_to="/home/roman/Projects/Active/Bash/data/"

    # Непосредственно восстановка.
    rsync -azve ssh $path_from $path_to
}

lab_4() {
    echo "Создание бекапа..."
    backup

    # Даем возможность все сломать.
    # -p -> для использования строки приглашения.
    read -p "Введите, что хотите: "

    echo "Восстановление..."
    restore
}

lab_4
