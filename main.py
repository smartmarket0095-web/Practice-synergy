from abc import ABC, abstractmethod


class Transport(ABC):
    def __init__(self, brand: str, speed: int):
        self.brand = brand
        self.speed = speed

    def move(self) -> str:
        return f"{self.brand}: движение со скоростью {self.speed} км/ч."

    @abstractmethod
    def description(self) -> str:
        pass


class Bus(Transport):
    def __init__(self, brand: str, speed: int, seats: int):
        super().__init__(brand, speed)
        self.seats = seats

    def description(self) -> str:
        return f"Автобус {self.brand}, мест: {self.seats}."


class TouristBus(Bus):
    def __init__(self, brand: str, speed: int, seats: int, guide: str):
        super().__init__(brand, speed, seats)
        self.guide = guide

    def description(self) -> str:
        return (
            f"Туристический автобус {self.brand}, мест: {self.seats}, "
            f"экскурсовод: {self.guide}."
        )


def main():
    transports = [
        Bus("Volvo", 80, 45),
        TouristBus("Mercedes", 90, 50, "Анна"),
    ]

    print("Кейс-задача №2")
    print("Демонстрация базового и производного классов:\n")

    for transport in transports:
        print(transport.description())
        print(transport.move())
        print("-" * 50)


if __name__ == "__main__":
    main()
