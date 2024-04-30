/*################################################
# Stringify
#
# JSON-like value stringification
# Version 0.1.5
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
################################################*/

::stringify <- function(value, space = "") {
    local sp = (space != "") ? "" : " ";
    local cr = (space != "") ? "\n" : "";
    local delim_value = ", ";
    local equals_value = " = ";
    local _stringify = null;

    _stringify = function(value, indent = "") {
        switch (typeof value) {
            case "function":
                local info = value.getinfos();
                local args = "";
                local delim = "";
                if ("parameters" in info) foreach (i, arg in info.parameters.slice(1)) {
                    args += format("%s%s", delim, arg);
                    delim = delim_value;
                }
                return format("function(%s)", args);

            case "table":
                local key;
                local keys = [];
                local result = "";
                local delim = "";
                local insp = indent + space;
                local nl = cr + insp;

                foreach (k, v in value) keys.push(k);
                keys.sort(@(a, b) a.tostring() <=> b.tostring());

                foreach (i, k in keys) {
                    key = !!regexp(@"^[A-Za-z_][A-Za-z_0-9]*$").capture(k.tostring()) ? k : format("[%s]", _stringify(k));
                    result += format("%s%s%s%s%s", delim, nl, key, equals_value, _stringify(value[k], insp));
                    delim = delim_value;
                }
                return format("{%s%s%s%s}", sp, result, (result != "") ? cr + indent : "", sp);

            case "array":
                local result = "";
                local delim = "";
                local insp = indent + space;
                local nl = cr + insp;

                foreach (i, v in value) {
                    result += format("%s%s%s", delim, nl, _stringify(v, insp));
                    delim = delim_value;
                }
                return format("[%s%s]", result, (result != "") ? cr + indent : "");

            case "string":
                local i = 0;
                local verbatim = value.find("\\") != null;

                while ((i = value.find(@"""", i)) != null) {
                    value = format(@"%s""%s", value.slice(0, i), value.slice(i));
                    verbatim = true;
                    i+=2;
                }
                return format(verbatim ? @"@""%s""" : @"""%s""", value);

            case "float":
                local result = value.tostring();
                return format("%s%s", result, (result.find(".") != null || result.find("n") != null) ? "" : ".0"); // n for nan

            case "integer":
                return value.tostring();

            case "null":
                return "null";

            case "bool":
            case "class":
            case "instance":
                return "" + value; // auto-convert to string

            default:
                return format("<%s>", typeof value);
        }
    }
    return _stringify(value);
}
