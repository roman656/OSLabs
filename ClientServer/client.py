import socket
import os


def connect_to_socket(path):
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    sock.connect(path)
    return sock


def get_server_answer(sock):
    data = sock.recv(4096)  # Получение данных из сокета.
    print("Получено сообщение: " + data.decode('utf-8'))


def sending(sock):
    while True:
        try:
            data = input("Ваше сообщение: ")

            if data == "stop":
                sock.send(b"stop")
                break
            elif data != "":
                print("Отправка сообщения.")
                sock.send(data.encode('utf-8'))
                get_server_answer(sock)
        except KeyboardInterrupt as e:
            break


if __name__ == "__main__":
    socket_path = "/home/roman/Projects/Active/Python/Lab_3/unix.socket"

    print("Для выхода введите: stop")

    print("Подключение к сокету.")
    if os.path.exists(socket_path):
        client = connect_to_socket(socket_path)
        sending(client)

        print("Завершение работы.")
        client.close()
    else:
        print("Подключение не удалось. Не найден файл сокета.")
