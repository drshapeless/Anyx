// Anyx is an extended version of the builtin Any type, this is nice
// to have when dealing with Json which has fields that accept
// multiple type.

// A simple usage would be like this, using the default value of a struct.

/*
    Bar :: struct {
        foo: Anyx = .{ optional = false, accepted_types = .[int, float] };
    }
*/

// I do not recommend any use of this type other than creating binding.

Anyx :: struct {
    data: Any;

    optional: bool;
    has_value: bool;
    accepted_types: []Type;
}

set :: (a: *Anyx, v: $T) -> bool {
    found := false;
    for a.accepted_types {
        if it == T {
            found = true;
            break;
        }
    }

    if !found return false;

    // Allocating memory for data is a must
    p := alloc(size_of(T));
    memcpy(p, *v, size_of(T));

    // With this weird line of code, we omit the following two lines.
    a.data = (cast(*T)p).*;
    // a.data.type = type_info(T);
    // a.data.value_pointer = p;

    if a.optional {
        a.has_value = true;
    }

    return true;
}

get :: (a: Anyx) -> Any, bool {
    if a.optional && !a.has_value {
        return null, false;
    }

    return a.data, true;
}

clear :: (a: *Anyx) -> bool {
    if !a.optional return false;

    a.data = null;
    a.has_value = false;
    return true;
}

print_anyx :: (a: Anyx) -> string {
    return sprint("%", a.data);
}

#scope_file
#import "Basic";
#import "Memory";
