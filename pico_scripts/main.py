# Taken from: https://gist.github.com/romilly/66db6afa88e5a113b3804308e8c4c37c
import serial

class Talker:
    TERMINATOR = '\r'.encode('UTF8')

    def __init__(self, timeout=1):
        self.serial = serial.Serial('/dev/ttyACM0', 115200, timeout=timeout)

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

t.send('2 + 2')
t.receive()
t.send('on()')
t.send('off()')
t.close()