#!/bin/bash

# Форматтер.
shfmt -w -i 4 $(pwd)

choose_way() {
    # Выбор пользователя. По умолчанию rsync.
    choice=2

    read -p "Выберите с помощью чего будут производиться бекап и восстановление. t - tar; r - rsync: " answer

    case $answer in
    [TtЕе]*) choice=1 ;;
    [RrКк]*) choice=2 ;;
    *) echo "Введено что-то другое, но я сделаю вид, что это r." ;;
    esac

    return $choice
}

backup() {
    # Путь до директории, бекап которой необходимо произвести.
    path_from="/home/roman/Projects/Active/Bash/data/"

    # То, куда все будет сохранено.
    path_to='karelia@mati.su:/home/karelia/www/karelia.mati.su/temp/'

    # Непосредственно бекап.
    # rsync:
    # -a - режим архивирования, когда сохраняются все атрибуты оригинальных файлов;
    # -z - сжимать файлы перед передачей;
    # -e - использовать другой транспорт, например, ssh;
    # -v - выводить подробную информацию о процессе копирования.
    # tar:
    # -c – создает новый архив и записывает в него файлы;
    # -v - выводит подробную информацию;
    # -p - сохраняет все права доступа;
    # -z - сжимает архив с помощью программы GZIP;
    # -f file - использовать файл file;
    # --one-file-system - оставаться в локальной файловой системе при создании архива.

    case $1 in
    [1]*) tar -cvpzf backup.tar.gz --one-file-system data ;;
    *) rsync -azve ssh $path_from $path_to ;;
    esac
}

restore() {
    # То, где лежит бекап.
    path_from='karelia@mati.su:/home/karelia/www/karelia.mati.su/temp/'

    # Путь до директории, которую необходимо восстановить.
    path_to="/home/roman/Projects/Active/Bash/data/"

    # Непосредственно восстановка.
    # tar: -x - извлечение файлов из архива.

    case $1 in
    [1]*) tar -xvpzf backup.tar.gz ;;
    *) rsync -azve ssh $path_from $path_to ;;
    esac
}

lab_4() {
    choose_way
    way=$?

    echo "Создание бекапа..."
    backup $way

    # Даем возможность все сломать.
    # -p -> для использования строки приглашения.
    read -p "Введите, что хотите: "

    echo "Восстановление..."
    restore $way
}

lab_4
