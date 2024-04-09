fe.add_text(split(fe.script_dir, "/").top(), 0, fe.layout.height * 19 / 20, fe.layout.width, fe.layout.height / 20).align = Align.BottomLeft;
//===================================================

fe.load_module("fs");

local flw = fe.layout.width;
local flh = fe.layout.height;

//===================================================

// read a file one line at a time, good for processing large files
local display = ::fe.displays[::fe.list.display_index];
local fh1 = ::fs.open(FeConfigDirectory + "romlists/" + display.romlist + ".txt", "r");
local line1 = null;
local content1 = "";
while (line1 = fh1.read_line()) content1 += line1 + "\n";

local msg1 = fe.add_text(content1, 0, 0, flw/3, flh * 19 / 20);
msg1.char_size = 16;
msg1.align = Align.TopLeft;
msg1.word_wrap = true;

// =================================

// read a file all at once
local fh2 = ::fs.open(FeConfigDirectory + "attract.cfg", "r");
local content2 = fh2.read();

local msg2 = fe.add_text(content2, flw/3, 0, flw/3, flh * 19 / 20);
msg2.char_size = 16;
msg2.align = Align.TopLeft;
msg2.word_wrap = true;

// =================================

// directory listing
local dir = ::fs.readdir(FeConfigDirectory, true);
local content3 = "";
foreach (d in dir) content3 += d + "\n";

local msg3 = fe.add_text(content3, flw*2/3, 0, flw/3, flh * 19 / 20);
msg3.char_size = 16;
msg3.align = Align.TopLeft;
msg3.word_wrap = true;