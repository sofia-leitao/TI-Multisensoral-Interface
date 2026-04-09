import serial
import serial.tools.list_ports


class SerialInterface:
    def __init__(self, port: str, baudrate: int = 9600, timeout: float = 1.0):
        self.port = port
        self.baudrate = baudrate
        self.timeout = timeout
        self.connection = None

    def open(self):
        """Open the serial connection using pySerial."""
        self.connection = serial.Serial(self.port, self.baudrate, timeout=self.timeout)
        if not self.connection.is_open:
            self.connection.open()

    def close(self):
        """Close the serial connection."""
        if self.connection and self.connection.is_open:
            self.connection.close()

    def read_line(self) -> str:
        """Read one line from serial and return it as a decoded string."""
        if not self.connection or not self.connection.is_open:
            raise RuntimeError("Serial port is not open")

        data = self.connection.readline()
        if not data:
            return ""

        return data.decode("utf-8", errors="replace").strip()

    @staticmethod
    def list_ports() -> list[str]:
        """List available serial ports."""
        return [port.device for port in serial.tools.list_ports.comports()]


def main():
    print("Available serial ports:")
    
    print("opened port: ", SerialInterface.list_ports()[2])

    selected_port = SerialInterface.list_ports()[2]
    serial_interface = SerialInterface(selected_port, baudrate=9600, timeout=1.0)

    try:
        serial_interface.open()
        print(f"Opened {selected_port} at 9600 baud.")
        print("Waiting for incoming strings. Press Ctrl+C to stop.")

        while True:
            line = serial_interface.read_line()
            if line:
                print(f"Received: {line}")
    except KeyboardInterrupt:
        print("Stopped by user.")
    except Exception as error:
        print(f"Serial error: {error}")
    finally:
        serial_interface.close()


if __name__ == "__main__":
    main()
