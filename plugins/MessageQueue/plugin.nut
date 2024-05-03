/*################################################
# Message Queue
#
# Send messages using files
# Version 0.1.0
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
################################################*/

class UserConfig</ help="Send messages using files (v0.1.0)" /> {
    </  label="Queue Path",
        options="",
        help="The full path to the queue folder",
        order=1 />
    queue_path=::fe.script_dir + "queue"
    </  label="Queue Extension",
        options="",
        help="Extension(s) for queue files. Multiple extensions can be entered if separated by a semicolon",
        order=2 />
    queue_ext=".txt"
    </  label="Frequency",
        options="16ms,100ms,250ms,500ms,1000ms,2000ms",
        help="How often the queue is checked",
        order=3 />
    queue_frequency="100ms"
}

class MessageQueue {

    queue_ext = "";
    queue_path = "";
    queue_frequency = 0;

    message_callbacks = null;
    next_time = 0;
    is_init = false;

    constructor() {
        local config = ::fe.get_config();
        queue_ext = split(config["queue_ext"], ";");
        queue_path = add_trailing_slash(config["queue_path"]);
        queue_frequency = config["queue_frequency"].tointeger();

        if (::fe.path_test(remove_trailing_slash(queue_path), PathTest.IsDirectory)) {
            print(format("MessageQueue invalid queue path: %s\n", queue_path));
        }

        message_callbacks = [];
        ::fe.add_message_callback <- add_message_callback.bindenv(this);
    }

    // ---------------------------------------------------

    function add_message_callback(...) {
        if (vargv.len() == 1) vargv.insert(0, ::getroottable());
        message_callbacks.push(vargv);
        if (!is_init) {
            ::fe.add_ticks_callback(this, "on_tick");
            is_init = true;
        }
    }

    function on_tick(ttime) {
        if (ttime >= next_time) {
            next_time = ttime + queue_frequency;
            local message;
            foreach (filename in ::zip_get_dir(queue_path)) {
                if (!match_ext(filename)) continue;
                filename = queue_path + filename;
                if (message = read_file(filename)) {
                    foreach (callback in message_callbacks) callback[0][callback[1]](message);
                    ::remove(filename);
                }
            }
        }
    }

    // ---------------------------------------------------

    function remove_trailing_slash(path) {
        local tail = path[path.len() - 1];
        return (tail == 47 || tail == 92) ? path.slice(0, path.len() - 2) : path;
    }

    function add_trailing_slash(path) {
        local tail = path[path.len() - 1];
        return (tail == 47 || tail == 92) ? path : path + "/";
    }

    function match_ext(filename) {
        foreach (ext in queue_ext) if (filename.slice(-ext.len()) == ext) return true;
        return false;
    }

    function read_file(filename) {
        try {
            local content = "";
            local f = ::file(filename, "r");
            local b = f.readblob(f.len());
            while (!b.eos()) content += b.readn('b').tochar();
            f.close();
            return content;
        } catch(err) {
            print(format("MessageQueue cannot read: %s\n%s\n", filename, err));
            return null;
        }
    }
}

fe.plugin["MessageQueue"] <- MessageQueue();
