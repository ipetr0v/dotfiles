import os
import readline
histfile = os.path.join(os.environ.get("XDG_STATE_HOME", os.path.expanduser("~/.local/state")), "python", "history")
os.makedirs(os.path.dirname(histfile), exist_ok=True)
try:
    readline.read_history_file(histfile)
except FileNotFoundError:
    pass
import atexit
atexit.register(readline.write_history_file, histfile)
