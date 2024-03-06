import sys, argparse, win32con
from win32gui import SendMessage, EnumWindows, GetWindowText, GetClassName, GetForegroundWindow

parser = argparse.ArgumentParser(description="Send keypress to window")
parser.add_argument("key", help="key name or code")
parser.add_argument("window_name", default=None, nargs="?", help="name of the window")
parser.add_argument("class_name", default=None, nargs="?", help="class of the window")

args = parser.parse_args()
window_name = args.window_name
class_name = args.class_name
key = args.key

if hasattr(win32con, key):
    code = getattr(win32con, key)
elif key.isnumeric():
    code = int(key)
elif len(key.strip("'\"")) == 1:
    code = ord(key.strip("'\""))
elif hasattr(win32con, f"VK_{key}"):
    code = getattr(win32con, f"VK_{key}")
else:
    sys.exit(f"Unknown key {key}")

def sendKeypress(hwnd, code):
    SendMessage(hwnd, win32con.WM_KEYDOWN, code, 0)
    SendMessage(hwnd, win32con.WM_KEYUP, code, 0)

if window_name:
    def enumHandler(hwnd, lParam):
        if (GetWindowText(hwnd) == window_name) and ((class_name == None) or (GetClassName(hwnd) == class_name)):
            sendKeypress(hwnd, code)
    EnumWindows(enumHandler, None)
else:
    sendKeypress(GetForegroundWindow(), code)
