/*################################################
# Regex
#
# Regular Expression handler
# Version 0.1.0
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
################################################*/

// String replace helper
local str_replace = function(value, search, replace) {
    local search_len = search.len();
    local replace_len = replace.len();
    local index = 0;
    while ((index = value.find(search, index)) != null) {
        value = value.slice(0, index) + replace + value.slice(index + search_len);
        index += replace_len;
    }
    return value;
}

class Regex {

    _value = "";

    constructor(value = "") {
        _value = value;
    }

    function _tostring() {
        return "Regex";
    }

    // Return true if pattern matchs
    function test(pattern) {
        return !!regexp(pattern).capture(_value);
    }

    // Return index of pattern in value, or -1 if none
    function search(pattern, start = 0) {
        local match = regexp(pattern).capture(_value, start);
        return match ? match[0].begin : -1;
    }

    // Return array of full-matches
    function match(pattern) {
        local results = match_all(pattern);
        return (typeof results == "array")
            ? results.map(@(r) r[0])
            : results;
    }

    // Return array of group matches
    function match_all(pattern) {
        local ex = regexp(pattern);
        local match = ex.capture(_value, 0);
        if (!match) return null;

        local value_len = _value.len();
        local results = [];
        local result;

        while (match) {
            result = [];
            foreach (item in match) {
                result.push(_value.slice(item.begin, (item.end > value_len) ? value_len : item.end));
            }
            results.push(result);
            match = (match[0].end < value_len) ? ex.capture(_value, match[0].end) : null;
        }

        return results;
    }

    // Replace first matching pattern
    function replace(pattern, replace) {
        local result = _value;
        local ex = regexp(pattern);
        local match = ex.capture(result);
        local item, len, match_replace;

        if (match) {
            len = result.len();
            match_replace = replace;
            for (local i=match.len()-1; i>0; i--) {
                item = match[i];
                match_replace = str_replace(match_replace, "$"+i, result.slice(item.begin, (item.end > len) ? len : item.end));
            }
            item = match[0];
            result = result.slice(0, item.begin) + match_replace + result.slice((item.end > len) ? len : item.end);
        }

        return result;
    }

    // Replace all matching patterns
    function replace_all(pattern, replace) {
        local result = _value;
        local ex = regexp(pattern);
        local match = ex.capture(result);
        local item, len, match_replace;

        while (match) {
            len = result.len();
            match_replace = replace;
            for (local i=match.len()-1; i>0; i--) {
                item = match[i];
                match_replace = str_replace(match_replace, "$"+i, result.slice(item.begin, (item.end > len) ? len : item.end));
            }
            item = match[0];
            result = result.slice(0, item.begin) + match_replace + result.slice((item.end > len) ? len : item.end);

            match = ex.capture(result, match[0].begin + match_replace.len());
        }

        return result;
    }
}