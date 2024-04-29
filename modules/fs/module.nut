/*################################################
# FileSystem
#
# File reading and writing
# Version 0.5.0
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
################################################*/

class FileHandler {

    path = "";
    chunksize = 1024;
    _file = null;
    _blob = null;
    _mode = null;
    _err = null;

    constructor(_path, mode = "r") {
        path = _path;
        _mode = mode;
        try {
            _file = file(path, mode);
        } catch (err) {
            _err = err;
        }
    }

    function get_error() {
        return _err;
    }

    function log_error(title, error) {
        _err = error;
        print(format("%s '%s' [%s] - %s\n", title, error, _mode, path));
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

    // Place pointer at start of file
    function rewind() {
        return seek(0, 'b');
    }

    // Place pointer at end of file
    function end() {
        return seek(0, 'e');
    }

    // Move pointer within file
    function seek(offset, origin = 'c') {
        if (_file) _file.seek(offset, origin);
        _blob = null;
        return this;
    }

    // ------------------------------------------

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
        if ((!_file || _file.eos()) && (!_blob || _blob.eos())) return null;
        local line = "";
        local char;
        try {
            while (!_blob || !_blob.eos() || !_file.eos()) {
                if (!_blob || _blob.eos()) _blob = _file.readblob(chunksize);
                while (!_blob.eos()) {
                    char = _blob.readn('b');
                    if (char == 10) return line; // 10 = newline
                    line += char.tochar();
                }
            }
        } catch (err) {
            log_error("Cannot read", err);
            return null;
        }
        return line;
    }

    // ------------------------------------------

    // Return all lines as csv array
    function read_csv_lines(delim = ";") {
        local lines = [];
        local line = null;
        while (line = read_csv_line()) lines.push(line);
        return lines;
    }

    // Return next csv line in file, or null if none
    function read_csv_line(delim = ";") {
        if ((!_file || _file.eos()) && (!_blob || _blob.eos())) return null;
        local d = delim[0];
        local item = "";
        local line = [];
        local char;
        try {
            while (!_blob || !_blob.eos() || !_file.eos()) {
                if (!_blob || _blob.eos()) _blob = _file.readblob(chunksize);
                while (!_blob.eos()) {
                    char = _blob.readn('b');
                    if (char == 10) {
                        line.push(item);
                        return line;
                    } else if (char == d) {
                        line.push(item);
                        item = "";
                    } else {
                        item += char.tochar();
                    }
                }
            }
        } catch (err) {
            log_error("Cannot read", err);
            return null;
        }
        line.push(item);
        return line;
    }

    // ------------------------------------------

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
        try {
            if (typeof text != "string") text = text.tostring();
            local b = blob(text.len());
            for (local i=0, n=text.len(); i<n; i++) b.writen(text[i], 'b');
            _file.writeblob(b);
        } catch (err) {
            log_error("Cannot write", err);
        }
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
    open = @(path, mode = "r") FileHandler(path, mode),
    readdir = readdir,
    exists = @(path) ::fe.path_test(path, PathTest.IsFileOrDirectory),
    file_exists = @(path) ::fe.path_test(path, PathTest.IsFile),
    directory_exists = @(path) ::fe.path_test(path, PathTest.IsDirectory),
    join = join,
};