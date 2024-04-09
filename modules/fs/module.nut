/*################################################
# FileSystem
#
# File reading and writing
# Version 0.3.0
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
################################################*/

class ReadFileHandler {

    path = "";
    chunksize = 1024;
    _file = null;
    _blob = null;

    constructor(_path) {
        path = _path;
        try {
            _file = file(path, "r");
        } catch (err) {
            print(err + "\n");
        }
    }

    // Return length of file
    function len() {
        return _file ? _file.len() : null;
    }

    // Return true if file exists
    function exists() {
        return !!_file;
    }

    // Close file
    function close() {
        if (_file) _file.close();
        _file = null;
        _blob = null;
        return this;
    }

    // Place read pointer at start of file
    function rewind() {
        if (_file) _file.seek(0, 'b');
        _blob = null;
        return this;
    }

    // Return entire file as string
    function read() {
        local line = null;
        local content = read_line();
        while (line = read_line()) content += "\n" + line;
        return content;
    }

    // Return all lines as array
    function read_lines() {
        local lines = [];
        local line = null;
        while (line = read_line()) lines.push(line);
        return lines;
    }

    // Return next line in file, or null if none
    function read_line() {
        if (_file == null || _file.eos()) return null;
        local line = "";
        local char;
        while (!_file.eos()) {
            if (_blob == null || _blob.eos()) _blob = _file.readblob(chunksize);
            while (!_blob.eos()) {
                char = _blob.readn('b');
                if (char == 10) return line; // 10 = newline
                line += char.tochar();
            }
        }
        return line;
    }
}

// =====================================================

class WriteFileHandler {

    path = "";
    _file = null;

    constructor(_path) {
        path = _path;
        try {
            _file = file(path, "w");
        } catch (err) {
            print(err + "\n");
        }
    }

    // Return length of file
    function len() {
        return _file ? _file.len() : null;
    }

    // Return true if file exists
    function exists() {
        return !!_file;
    }

    // Close file
    function close() {
        if (_file) _file.close();
        _file = null;
        return this;
    }

    // Place write pointer at start of file
    function rewind() {
        if (_file) _file.seek(0, 'b');
        return this;
    }

    // Write array of strings to file
    function write_lines(lines) {
        foreach (line in lines) write_line(line);
        return this;
    }

    // Write string to file with new line after
    function write_line(text) {
        return write(text).write("\n");
    }

    // Write string to file
    function write(text) {
        if (!_file) return this;
        if (typeof text != "string") text = text.tostring();
        local b = blob(text.len());
        for (local i=0, n=text.len(); i<n; i++) b.writen(text[i], 'b');
        _file.writeblob(b);
        return this;
    }
}

// =====================================================

// Ensure path has a single trailing slash
local trailing_slash = function(path) {
    local tail = path[path.len() - 1];
    return (tail != 47 && tail != 92) ? path + "/" : path;
}

// Join args into path delimited by slashes
local join = function(...) {
    local path = "";
    local len = vargv.len();
    for (local i=0, n=len-1; i<n; i++) path += trailing_slash(vargv[i]);
    return path + (len ? vargv.top() : "");
};

// Return array of items in folder, paths are relative
local readdir = function(path, absolute_path = false) {
    local dirs = zip_get_dir(path);
    return absolute_path
        ? dirs.map(@(f) join(path, f))
        : dirs
};

// =====================================================

::fs <- {
    open = @(path, mode = "r") (mode == "w")
        ? WriteFileHandler(path)
        : ReadFileHandler(path),
    readdir = readdir,
    join = join,
};