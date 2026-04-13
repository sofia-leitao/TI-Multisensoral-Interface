import serial
import serial.tools.list_ports
import tkinter as tk
from tkinter import ttk, scrolledtext
import threading
from datetime import datetime


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


class SerialGUI:
    def __init__(self, root, port: str, baudrate: int = 9600):
        self.root = root
        self.root.title("Serial Communication Interface")
        self.root.geometry("700x600")
        
        self.port = port
        self.baudrate = baudrate
        self.serial_interface = None
        self.reading = False
        self.read_thread = None
        
        self.setup_ui()
        self.start_reading()
        
    def setup_ui(self):
        """Create the GUI components."""
        # Top frame for title and status
        control_frame = ttk.Frame(self.root, padding=10)
        control_frame.pack(fill="x")
                
        self.status_var = tk.StringVar(value="Status: Connecting...")
        status_label = ttk.Label(control_frame, textvariable=self.status_var, foreground="orange")
        status_label.pack(side="left", padx=20)
        self.status_label = status_label
        
        # Data display frame
        display_frame = ttk.LabelFrame(self.root, text="Incoming Data", padding=10)
        display_frame.pack(fill="both", expand=True, padx=10, pady=5)
        
        self.text_display = scrolledtext.ScrolledText(display_frame, height=20, width=80, 
                                                       wrap=tk.WORD, state="disabled", 
                                                       font=("Courier", 20))
        self.text_display.pack(fill="both", expand=True)
        
        # Bottom frame for buttons
        bottom_frame = ttk.Frame(self.root, padding=10)
        bottom_frame.pack(fill="x")


    def start_reading(self):
        """Initialize connection and start reading thread."""
        try:
            self.serial_interface = SerialInterface(self.port, baudrate=self.baudrate, timeout=0.5)
            self.serial_interface.open()
            self.reading = True
            
            self.status_var.set("Status: Connected ✓")
            self.status_label.config(foreground="green")
            
            self.append_text(f"[{self._timestamp()}] Connected to {self.port} at {self.baudrate} baud\n\n")
            
            # Start reading thread
            self.read_thread = threading.Thread(target=self.read_serial_data, daemon=True)
            self.read_thread.start()
        except Exception as e:
            self.status_var.set(f"Status: Error - {str(e)}")
            self.status_label.config(foreground="red")
            self.append_text(f"[{self._timestamp()}] Connection error: {str(e)}\n")
    
    def read_serial_data(self):
        """Read data from serial port in a separate thread."""
        while self.reading:
            try:
                if self.serial_interface:
                    line = self.serial_interface.read_line()
                    if line:
                        self.append_text(f"[{self._timestamp()}] {line}\n")
            except Exception as e:
                self.append_text(f"[{self._timestamp()}] Error reading: {str(e)}\n")
                self.reading = False
    
    def append_text(self, text):
        """Append text to the display area safely from thread."""
        self.text_display.config(state="normal")
        self.text_display.insert("end", text)
        self.text_display.see("end")
        self.text_display.config(state="disabled")
    
    @staticmethod
    def _timestamp():
        """Return current timestamp as string."""
        return datetime.now().strftime("%H:%M:%S.%f")[:-3]


def main():
    ports = SerialInterface.list_ports()
    print("Available ports:", ports)
    
    if len(ports) <= 2:
        print("Error: Port at index 2 not found")
        return
    
    selected_port = ports[2]
    print(f"Using port: {selected_port}")
    
    root = tk.Tk()
    gui = SerialGUI(root, selected_port, baudrate=9600)
    root.mainloop()


if __name__ == "__main__":
    main()
