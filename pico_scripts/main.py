# Taken from: https://gist.github.com/romilly/66db6afa88e5a113b3804308e8c4c37c
import serial
import time
import sys
from tqdm.notebook import trange, tqdm
import os

class Talker:
    TERMINATOR = '\r'.encode('UTF8')

    def __init__(self, timeout=1):
        self.serial = serial.Serial('/dev/ttyACM0', 115200, timeout=timeout) #Change this to whichever port your pico is on

    def send(self, text: str):
        line = '%s\r\f' % text
        self.serial.write(line.encode('utf-8'))
        reply = self.receive()
        reply = reply.replace('>>> ','') # lines after first will be prefixed by a propmt
        if reply != text: # the line should be echoed, so the result should match
            raise ValueError('expected %s got %s' % (text, reply))

    def receive(self) -> str:
        line = self.serial.read_until(self.TERMINATOR)
        return line.decode('UTF8').strip()

    def close(self):
        self.serial.close()

t = Talker()

def test_jtag():
    os.system("st-flash read flash.bin 0 0xFFFF")

    if os.path.exists("flash.bin"):
        return True
    else:
        return False

while True:

    for delay in trange(63000, 84000):
        us = delay/10000000000 #convert to microseconds

        t.send("debug()")
        CPU_power = t.receive()
        while CPU_power == '':
            CPU_power = t.receive()
        t.receive()

        time.sleep(us)
        t.send('drain()')
        time.sleep(0.05)

        if test_jtag():
            print("SUCCESS")
            t.close()
            sys.exit(0)
        else:
            t.send('refresh()')
            time.sleep(0.05)
            t.send('power_board()')