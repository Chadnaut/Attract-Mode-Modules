/*################################################
# Stringify
#
# JSON-like value stringification
# Version 0.1.4
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
################################################*/

::stringify <- function(value, space = "") {
    local has_space = (space != "");
    local sp = has_space ? "" : " ";
    local cr = has_space ? "\n" : "";
    local _stringify = null;
    _stringify = function(value, indent = "") {
        switch (typeof value) {
            case "function":
                local info = value.getinfos();
                local args = "";
                if ("parameters" in info) foreach (i, v in info.parameters.slice(1)) args += (i ? ", " : "") + v;
                return "function(" + args + ")";

            case "table":
                local key, keys = [], res = "";
                foreach (k, v in value) keys.push(k);
                keys.sort(@(a, b) a.tostring() <=> b.tostring());
                foreach (i, k in keys) {
                    key = !!regexp(@"^[A-Za-z_][A-Za-z_0-9]*$").capture(k.tostring()) ? k : @"[""" + k + @"""]";
                    res += (i ? ", " : "") + cr + indent + space + key + " = " + _stringify(value[k], indent + space);
                }
                return "{" + sp + ((res != "") ? (res + cr + indent) : "") + sp + "}";

            case "array":
                local res = "";
                foreach (i, v in value) res += (i ? ", " : "") + cr + indent + space + _stringify(v, indent + space);
                return "[" + ((res != "") ? (res + cr + indent) : "") + "]";

            case "string":
                local i, start = 0;
                local verbatim = value.find("\\") != null;
                while ((i = value.find(@"""", start)) != null) {
                    value = value.slice(0, i) + @"""" + value.slice(i);
                    start = i + 2;
                    verbatim = true;
                }
                return verbatim
                    ? @"@""" + value + @""""
                    : @"""" + value + @"""";

            case "float":
                local res = value.tostring();
                return res + ((res.find(".") == null && res.find("n") == null) ? ".0" : ""); // n for nan

            case "integer":
                return value.tostring();

            case "null":
                return "null";

            case "bool":
            case "class":
            case "instance":
                return "" + value;

            default:
                return "<" + (typeof value) + ">";
        }
    }
    return _stringify(value);
}
