from machine import Pin
import time

led = Pin(25, Pin.OUT)  # Debug pin for Pico
power_pins = Pin(0, Pin.OUT)  # Pins to power AirTag
cpu_power = Pin(4, Pin.IN)  # Power for NRF board
drain_mosfet = Pin(9, Pin.IN)  # Use this to drain power from CPU


def power_board():
    power_pins.value(1)


def de_power_board():
    power_pins.value(0)


def drain():
    drain_mosfet.value(1)


def wait_until_CPU_powered():
    while True:
        if cpu_power.value():
            return True


def refresh():
    de_power_board()
    drain_mosfet.value(0)


def debug():
    time.sleep(1)
    led.toggle()
    return True
