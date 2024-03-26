::stringify <- function(value, space = "") {
    local cr = (space != "") ? "\n" : "";
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
                    key = !!regexp(@"^[A-Za-z0-9_]*$").capture(k.tostring()) ? k : @"[""" + k + @"""]";
                    res += (i ? ", " : "") + cr + indent + space + key + " = " + _stringify(value[k], indent + space);
                }
                return "{" + ((res != "") ? (res + cr + indent) : "") + "}";

            case "array":
                local res = "";
                foreach (i, v in value) res += (i ? ", " : "") + cr + indent + space + _stringify(v, indent + space);
                return "[" + ((res != "") ? (res + cr + indent) : "") + "]";

            case "string":
                return @"""" + value + @"""";

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
