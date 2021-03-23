import os
import signal
import time


def handler_int(signum, frame):
    print(f"Процесс {os.getpid()} получил SIGINT({signum}).")


def handler_term(signum, frame):
    print(f"Процесс {os.getpid()} получил SIGTERM({signum}).")


def fork(children_amount=1):
    try:
        pid = os.fork()  # Создание клона текущего процесса, как дочерний процесс.

        if pid:  # Возвращает идентификатор дочернего процесса в родительском.
            if children_amount > 1:
                fork(children_amount - 1)
        else:  # Возвращает 0 в дочернем процессе.
            print(f"PID дочернего процесса: {os.getpid()}.")
    except OSError as e:
        print(f"Ошибка os.fork:\n{e}")


if __name__ == "__main__":
    print(f"PID родительского процесса: {os.getpid()}.")

    print("Настройка обработчиков сигналов...")
    signal.signal(signal.SIGINT, handler_int)
    signal.signal(signal.SIGTERM, handler_term)

    fork(children_amount=8)  # Создание дочерних процессов.

    time.sleep(9000)  # В секундах.
