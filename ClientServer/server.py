import socket
import os
from threading import Thread


class MessageHandler(Thread):
    def __init__(self, connection):
        Thread.__init__(self)
        self.connection = connection

    def run(self):
        while True:
            data = self.connection.recv(4096)  # Получение данных из сокета.

            if (
                data.decode("utf-8") == "" or data.decode("utf-8") == "stop"
            ):  # Если не получили ничего ценного.
                break
            else:
                self.connection.send(b"Server: " + data)
                print("Получено: " + data.decode("utf-8"))
        print("Закрытие сидфслвоединения.")
        self.connection.close()


class Server:
    def __init__(self, socket_path):
        self.socket_path = socket_path
        self.sock = None

    def drop_prev_socket_file(self):
        if os.path.exists(self.socket_path):
            os.remove(self.socket_path)

    def open_socket(self):
        self.sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self.sock.bind(self.socket_path)  # Привязка сокета к адресу.
        self.sock.listen(10)

    def close_socket(self):
        self.sock.shutdown(
            socket.SHUT_RDWR
        )  # Дальнейшая отправка и получение данных запрещены.
        self.sock.close()

    def listen(self):
        while True:
            print("Ожидание соединения...")
            connection, client_address = self.sock.accept()
            print("Соединение установлено.")
            message_handler = MessageHandler(connection)
            message_handler.start()


if __name__ == "__main__":
    server = Server("/home/roman/Projects/Active/Python/Lab_3/unix.socket")

    print("Удаление файла сокета, если существует.")
    server.drop_prev_socket_file()

    print("Открытие сокета.")
    server.open_socket()

    try:
        print("Сервер слушает...")
        server.listen()
    except KeyboardInterrupt as e:
        print("Закрытие сокета.")
        server.close_socket()
