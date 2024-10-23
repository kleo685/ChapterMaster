/// @function string_upper_first
/// @description Capitalizes the first character in a string.
/// @param {string} _string The string to be modified.
/// @returns {string} Modified string.

function string_upper_first(_string) {
    try {
        var _first_char;
        var _modified_string;
    
        _first_char = string_char_at(_string, 1);
        _first_char = string_upper( _first_char );
        
        _modified_string = _string;
        _modified_string = string_delete(_modified_string, 1, 1);
        _modified_string = string_insert(_first_char, _modified_string, 1);
    
        return _modified_string;
	}
    catch(_exception) {
        show_debug_message(_exception.longMessage);
	}
}

/// @function string_has_digits
/// @description Returns true if the string has any digits in it.
/// @param {string}
/// @returns {bool}
function string_has_digits(_string) {
    try {
        return string_length(string_digits(_string)) > 0;
	}
    catch(_exception) {
        show_debug_message(_exception.longMessage);
	}
}

/// @function string_is_digits
/// @description Returns true if the string has only digits and no letters.
/// @param {string}
/// @returns {bool}
function string_is_digits(_string) {
    try {
        return string_length(string_digits(_string)) == string_length(_string);
	}
    catch(_exception) {
        show_debug_message(_exception.longMessage);
	}
}