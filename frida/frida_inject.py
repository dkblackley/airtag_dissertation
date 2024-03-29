# Modified script, originally from: https://raw.githubusercontent.com/frida/frida-python/master/examples/child_gating.py

# -*- coding: utf-8 -*-
from __future__ import unicode_literals, print_function
import sys
import frida

import threading
from frida_tools.application import Reactor


class my_class(object):
    def __init__(self):
        self._stop_requested = threading.Event()
        self._reactor = Reactor(run_until_return=lambda reactor: self._stop_requested.wait())

        self._device = frida.get_local_device()
        self._sessions = set()

        self._device.on("child-added", lambda child: self._reactor.schedule(lambda: self._on_child_added(child)))
        self._device.on("child-removed", lambda child: self._reactor.schedule(lambda: self._on_child_removed(child)))
        self._device.on("output", lambda pid, fd, data: self._reactor.schedule(lambda: self._on_output(pid, fd, data)))


    def _start(self):
        self._instrument(1)


    def _instrument(self, pid):
        print("✔ attach(pid={})".format(pid))
        session = self._device.attach(pid)
        session.on("detached", lambda reason: self._reactor.schedule(lambda: self._on_detached(pid, session, reason)))
        print("✔ enable_child_gating()")
        session.enable_child_gating()
        print("✔ create_script()")
        script = session.create_script(open('disable-ssl-pin.js', 'r').read())
        script.on("message", lambda message, data: self._reactor.schedule(lambda: self._on_message(pid, message)))
        print("✔ load()")
        script.load()
        print("✔ resume(pid={})".format(pid))
        try:
            self._device.resume(pid)
        except Exception as e:
            print(e)
        self._sessions.add(session)

    def _on_child_added(self, child):
        print("⚡ child_added: {}".format(child))
        self._instrument(child.pid)

    def _on_child_removed(self, child):
        print("⚡ child_removed: {}".format(child))

    def _on_output(self, pid, fd, data):
        print("⚡ output: pid={}, fd={}, data={}".format(pid, fd, repr(data)))

    def _on_message(self, pid, message):
        print("⚡ message: pid={}, payload={}".format(pid, message["payload"]))


app = my_class()

pid = sys.argv[1]

if pid.isnumeric():
    pid = int(pid)

#pid=1

app._instrument(pid)





# def on_uninjected(id):
#     print("on_uninjected id=%u" % id)
#
# #(target, library_path) = sys.argv[1:]
# (pid, library_path) = ("findmydeviced", "disable-ssl-pin.js")
#
# print("✔ attach(pid={})".format(pid))
# session = device.attach(pid)
# session.on("detached", lambda reason: reactor.schedule(lambda: on_detached(pid, session, reason)))
# print("✔ enable_child_gating()")
# session.enable_child_gating()
# print("✔ create_script()")
# script = session.create_script(open('frida-ssl-pin.js', 'r').read())
# script.on("message", lambda message, data: self._reactor.schedule(lambda: self._on_message(pid, message)))
# print("✔ load()")
# script.load()
# print("✔ resume(pid={})".format(pid))
# try:
#         device.resume(pid)
#     except Exception as e:
#         print(e)
#     sessions.add(session)
#
# device = frida.get_local_device()
# device.on("uninjected", on_uninjected)
# id = device.inject_library_file(target, library_path, "example_main", "w00t")
# print("*** Injected, id=%u -- hit Ctrl+D to exit!" % id)
# sys.stdin.read()
