// Stringify
//
// > JSON-like value stringification
// > Version 0.1.8
// > Chadnaut 2024
// > https://github.com/Chadnaut/Attract-Mode-Modules

local key_regex = regexp(@"^[A-Za-z_][A-Za-z_0-9]*$");

::stringify <- function(value, space = 0) {
    local tight = false;
    if (typeof space == "integer") {
        tight = (space < 0);
        space = (space > 0) ? array(space, " ").reduce(@(t, s) t + s) : "";
    }
    local sp = (space.len() || tight) ? "" : " "; // space inside object braces
    local cr = space.len() ? "\n" : "";
    local delim_value = "," + sp;
    local equals_value = tight ? "=" : " = ";
    local _stringify = null;

    _stringify = function(value, indent = "") {
        switch (typeof value) {
            case "function":
                local info = value.getinfos();
                local args = "";
                if ("parameters" in info) foreach (i, arg in info.parameters.slice(1)) {
                    args += i ? delim_value + arg : arg;
                }
                return format("function%s%s(%s) {}", info.name ? " " : "", info.name || "", args);

            case "table":
                local key;
                local keys = [];
                local result = "";
                local res = "";
                local next_indent = indent + space;
                local nl = cr + next_indent;

                foreach (k, v in value) keys.push(k);
                keys.sort(@(a, b) a.tostring() <=> b.tostring());

                foreach (i, k in keys) {
                    key = !!key_regex.capture(k.tostring()) ? k : ("[" + _stringify(k) + "]");
                    res = nl + key + equals_value + _stringify(value[k], next_indent);
                    result += i ? delim_value + res : res;
                }
                return (result != "") ? format("{%s%s%s%s%s}", sp, result, cr, indent, sp) : "{}";

            case "array":
                local result = "";
                local res = "";
                local next_indent = indent + space;
                local nl = cr + next_indent;

                foreach (i, v in value) {
                    res = nl + _stringify(v, next_indent);
                    result += i ? delim_value + res : res;
                }
                return (result != "") ? format("[%s%s%s]", result, cr, indent) : "[]";

            case "string":
                local i = 0;
                local verbatim = value.find("\\") != null;

                while ((i = value.find(@"""", i)) != null) {
                    value = value.slice(0, i) + @"""" + value.slice(i);
                    verbatim = true;
                    i += 2;
                }
                return verbatim
                    ? @"@""" + value + @""""
                    : @"""" + value + @"""";

            case "float":
                local result = value.tostring();
                return result + ((result.find(".") != null || result.find("n") != null) ? "" : ".0"); // n for nan

            case "integer":
                return value.tostring();

            case "null":
                return "null";

            case "bool":
            case "class":
            case "instance":
                return "" + value; // auto-convert to string

            default:
                return @"""<!--" + (typeof value) + @"-->""";
        }
    }
    return _stringify(value);
}
