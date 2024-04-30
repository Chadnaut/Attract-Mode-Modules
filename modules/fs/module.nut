/*################################################
# FileSystem
#
# File reading and writing
# Version 0.7.0
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
################################################*/

const FORWARDSLASH_CODE = 47; // == /
const BACKSLASH_CODE = 92; // == \
const NEWLINE_CODE = 10; // == \n
const CHUNK_SIZE = 1048576; // bytes = 1MB
local CRC_LOOKUP = [0, 1996959894, 3993919788, 2567524794, 124634137, 1886057615, 3915621685, 2657392035, 249268274, 2044508324, 3772115230, 2547177864, 162941995, 2125561021, 3887607047, 2428444049, 498536548, 1789927666, 4089016648, 2227061214, 450548861, 1843258603, 4107580753, 2211677639, 325883990, 1684777152, 4251122042, 2321926636, 335633487, 1661365465, 4195302755, 2366115317, 997073096, 1281953886, 3579855332, 2724688242, 1006888145, 1258607687, 3524101629, 2768942443, 901097722, 1119000684, 3686517206, 2898065728, 853044451, 1172266101, 3705015759, 2882616665, 651767980, 1373503546, 3369554304, 3218104598, 565507253, 1454621731, 3485111705, 3099436303, 671266974, 1594198024, 3322730930, 2970347812, 795835527, 1483230225, 3244367275, 3060149565, 1994146192, 31158534, 2563907772, 4023717930, 1907459465, 112637215, 2680153253, 3904427059, 2013776290, 251722036, 2517215374, 3775830040, 2137656763, 141376813, 2439277719, 3865271297, 1802195444, 476864866, 2238001368, 4066508878, 1812370925, 453092731, 2181625025, 4111451223, 1706088902, 314042704, 2344532202, 4240017532, 1658658271, 366619977, 2362670323, 4224994405, 1303535960, 984961486, 2747007092, 3569037538, 1256170817, 1037604311, 2765210733, 3554079995, 1131014506, 879679996, 2909243462, 3663771856, 1141124467, 855842277, 2852801631, 3708648649, 1342533948, 654459306, 3188396048, 3373015174, 1466479909, 544179635, 3110523913, 3462522015, 1591671054, 702138776, 2966460450, 3352799412, 1504918807, 783551873, 3082640443, 3233442989, 3988292384, 2596254646, 62317068, 1957810842, 3939845945, 2647816111, 81470997, 1943803523, 3814918930, 2489596804, 225274430, 2053790376, 3826175755, 2466906013, 167816743, 2097651377, 4027552580, 2265490386, 503444072, 1762050814, 4150417245, 2154129355, 426522225, 1852507879, 4275313526, 2312317920, 282753626, 1742555852, 4189708143, 2394877945, 397917763, 1622183637, 3604390888, 2714866558, 953729732, 1340076626, 3518719985, 2797360999, 1068828381, 1219638859, 3624741850, 2936675148, 906185462, 1090812512, 3747672003, 2825379669, 829329135, 1181335161, 3412177804, 3160834842, 628085408, 1382605366, 3423369109, 3138078467, 570562233, 1426400815, 3317316542, 2998733608, 733239954, 1555261956, 3268935591, 3050360625, 752459403, 1541320221, 2607071920, 3965973030, 1969922972, 40735498, 2617837225, 3943577151, 1913087877, 83908371, 2512341634, 3803740692, 2075208622, 213261112, 2463272603, 3855990285, 2094854071, 198958881, 2262029012, 4057260610, 1759359992, 534414190, 2176718541, 4139329115, 1873836001, 414664567, 2282248934, 4279200368, 1711684554, 285281116, 2405801727, 4167216745, 1634467795, 376229701, 2685067896, 3608007406, 1308918612, 956543938, 2808555105, 3495958263, 1231636301, 1047427035, 2932959818, 3654703836, 1088359270, 936918000, 2847714899, 3736837829, 1202900863, 817233897, 3183342108, 3401237130, 1404277552, 615818150, 3134207493, 3453421203, 1423857449, 601450431, 3009837614, 3294710456, 1567103746, 711928724, 3020668471, 3272380065, 1510334235, 755167117];

class FileHandler {

    path = "";
    mode = null;
    _file = null;
    _blob = null;

    constructor(_path, _mode = "r") {
        path = _path;
        mode = _mode;
        try {
            _file = file(path, mode);
        } catch (err) {
            log_error("Cannot open", err, _path, _mode);
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
                if (!_blob || _blob.eos()) _blob = _file.readblob(CHUNK_SIZE);
                while (!_blob.eos()) {
                    char = _blob.readn('b');
                    if (char == NEWLINE_CODE) return line;
                    line += char.tochar();
                }
            }
        } catch (err) {
            log_error("Cannot read", err, _path, _mode);
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
    // - easier to handle delim immediately, as split() removes empty values
    function read_csv_line(delim = ";") {
        if ((!_file || _file.eos()) && (!_blob || _blob.eos())) return null;
        local delim_code = delim[0];
        local item = "";
        local line = [];
        local char;
        try {
            while (!_blob || !_blob.eos() || !_file.eos()) {
                if (!_blob || _blob.eos()) _blob = _file.readblob(CHUNK_SIZE);
                while (!_blob.eos()) {
                    char = _blob.readn('b');
                    if (char == NEWLINE_CODE) {
                        line.push(item);
                        return line;
                    } else if (char == delim_code) {
                        line.push(item);
                        item = "";
                    } else {
                        item += char.tochar();
                    }
                }
            }
        } catch (err) {
            log_error("Cannot read CSV", err, _path, _mode);
            return null;
        }
        line.push(item);
        return line;
    }

    // ------------------------------------------

    // Return unsigned CRC32
    function crc() {
        if (!_file) return null;
        try {
            local p = _file.tell();
            _file.seek(0, 'b');
            local crc = 0xFFFFFFFF;
            local _blob = null;
            while (!_blob || !_blob.eos() || !_file.eos()) {
                if (!_blob || _blob.eos()) _blob = _file.readblob(CHUNK_SIZE);
                while (!_blob.eos()) crc = (crc >>> 8) ^ CRC_LOOKUP[(crc ^ _blob.readn('b')) & 0xFF];
            }
            _file.seek(p, 'b');
            return crc ^ 0xFFFFFFFF;
        } catch (err) {
            log_error("Cannot read CRC", err, _path, _mode);
            return null;
        }
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
            local _blob = blob(text.len());
            foreach (char in text) _blob.writen(char, 'b');
            _file.writeblob(_blob);
        } catch (err) {
            log_error("Cannot write", err, _path, _mode);
        }
        return this;
    }
}

// =====================================================

// Print error message
local log_error = function(title, error, path = null, mode = null) {
    print(mode
        ? format("%s '%s' - %s [%s]\n", title, error, path, mode)
        : path
            ? format("%s '%s' - %s\n", title, error, path)
            : format("%s '%s'\n", title, error)
    );
    return false;
}

// Ensure path has a single trailing slash
local add_trailing_slash = function(path) {
    local tail = path[path.len() - 1];
    return (tail == FORWARDSLASH_CODE || tail == BACKSLASH_CODE) ? path : path + "/";
}

// Join args into path delimited by slashes
local join = function(...) {
    local path = "";
    local len = vargv.len();
    for (local i=0, n=len-1; i<n; i++) path += add_trailing_slash(vargv[i]);
    return path + (len ? vargv.top() : "");
};

// Return array of items in folder
local readdir = function(path, absolute_path = false) {
    local files = zip_get_dir(path);
    return absolute_path ? files.map(@(f) join(path, f)) : files;
};

// Wrappers for path checking methods
local exists = @(path) ::fe.path_test(path, PathTest.IsFileOrDirectory);
local file_exists = @(path) ::fe.path_test(path, PathTest.IsFile);
local directory_exists = @(path) ::fe.path_test(path, PathTest.IsDirectory);

// Delete a file
local unlink = function(path) {
    try {
        if (!file_exists(path)) return log_error("Cannot unlink", "File not found", path);
        ::remove(path);
        return true;
    } catch (err) {
        return log_error("Cannot unlink", err, path);
    }
};

// Rename a file
local rename = function(from, to) {
    try {
        if (!file_exists(from)) return log_error("Cannot rename", "Source not found", from);
        if (file_exists(to)) return log_error("Cannot rename", "Destination exists", to);
        ::rename(from, to);
        return true;
    } catch (err) {
        return log_error("Cannot rename", err, to);
    }
};

// Copy a file
local copy = function(from, to, overwrite = false) {
    try {
        if (!file_exists(from)) return log_error("Cannot copy", "Source not found", from);
        if (!overwrite && file_exists(to)) return log_error("Cannot copy", "Destination exists", to);
        local src = file(from, "rb");
        local dest = file(to, "wb");
        local _blob = null;
        while (!_blob || !_blob.eos() || !src.eos()) {
            _blob = src.readblob(CHUNK_SIZE);
            if (!_blob.eos()) dest.writeblob(_blob);
        }
        src.close();
        dest.close();
        return true;
    } catch (err) {
        return log_error("Cannot copy", err);
    }
};

// Move a file
local move = function(from, to, overwrite = false) {
    try {
        if (!file_exists(from)) return log_error("Cannot move", "Source not found", from);
        if (file_exists(to)) {
            if (!overwrite) return log_error("Cannot move", "Destination exists", to);
            remove(to);
        }
        return rename(from, to);
    } catch (err) {
        return false;
    }
};

// =====================================================

::fs <- {
    open = @(path, mode = "r") FileHandler(path, mode),
    copy = copy,
    move = move,
    unlink = unlink,
    rename = rename,

    exists = exists,
    file_exists = file_exists,
    directory_exists = directory_exists,

    join = join,
    readdir = readdir,
    add_trailing_slash = add_trailing_slash,
};