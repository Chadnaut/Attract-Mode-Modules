/*################################################
# Regex
#
# Regular Expression handler
# Version 0.1.1
# Chadnaut 2024
# https://github.com/Chadnaut/Attract-Mode-Modules
#
################################################*/

// Replace search in value
local str_replace = function(value, search, replace) {
    local search_len = search.len();
    local replace_len = replace.len();
    local index = 0;
    while ((index = value.find(search, index)) != null) {
        value = format("%s%s%s", value.slice(0, index), replace, value.slice(index + search_len));
        index += replace_len;
    }
    return value;
}

// Replace matches in value
local replace_inner = function(value, match, replace) {
    local len = value.len();
    local item;
    for (local i=match.len()-1; i>0; i--) {
        item = match[i];
        replace = str_replace(replace, "$"+i, value.slice(item.begin, (item.end > len) ? len : item.end));
    }
    item = match[0];
    return format("%s%s%s", value.slice(0, item.begin), replace, value.slice((item.end > len) ? len : item.end));
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
        local groups = match_all(pattern);
        return (typeof groups == "array") ? groups.map(@(r) r[0]) : groups;
    }

    // Return array of group matches
    function match_all(pattern) {
        local ex = regexp(pattern);
        local match = ex.capture(_value, 0);
        if (!match) return null;

        local len = _value.len();
        local groups = [];
        local group;

        while (match) {
            group = [];
            foreach (item in match) group.push(_value.slice(item.begin, (item.end > len) ? len : item.end));
            groups.push(group);
            match = (match[0].end < len) ? ex.capture(_value, match[0].end) : null;
        }

        return groups;
    }

    // Replace first matching pattern
    function replace(pattern, replace) {
        local match = regexp(pattern).capture(_value);
        return match ? replace_inner(_value, match, replace) : _value;
    }

    // Replace all matching patterns
    function replace_all(pattern, replace) {
        local value = _value;
        local ex = regexp(pattern);
        local match = ex.capture(value);
        local len;

        while (match) {
            len = value.len();
            value = replace_inner(value, match, replace);
            match = ex.capture(value, match[0].begin + value.len() - len);
        }

        return value;
    }
}