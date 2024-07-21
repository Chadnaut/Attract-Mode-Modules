::fe.add_text(split(::fe.script_dir, "/").top(), 0, ::fe.layout.height * 0.95, ::fe.layout.width, ::fe.layout.height * 0.05).align = Align.BottomLeft;
//===================================================

local text = ::fe.add_text("", 0, 0, ::fe.layout.width, ::fe.layout.height);
text.char_size = ::fe.layout.height / 20;
text.word_wrap = true;

if (!("MessageQueue" in ::fe.plugin)) {
    text.msg = "Enable MessageQueue Plugin";
    return;
}

text.msg = format("Run 'example.bat' to create a message\n%s", ::fe.plugin["MessageQueue"].queue_path);

::fe.add_message_callback("on_message");
function on_message(message) {
    text.msg = message;
}
