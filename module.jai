// Anyx is an extended version of the builtin Any type, this is nice
// to have when dealing with Json which has fields that accept
// multiple type.

// A simple usage would be like this, using the default value of a struct.

/*
    Bar :: struct {
    foo: Anyx = .{ optional = false, accepted_types = .[type_info(int), type_info(float)] };
    }
*/

// I do not recommend any use of this type other than creating binding.

Anyx :: struct {
    value: Any;

    optional: bool;
    has_value: bool;
    accepted_types: []*Type_Info;
}

// This version of set does not allocate memory
set :: (a: *Anyx, value: *void, ti: *Type_Info) -> bool {
    found := false;
    for a.accepted_types {
        if it == ti {
            found = true;
            break;
        }
    }

    if !found return false;

    a.value.type = ti;
    a.value.value_pointer = value;

    if a.optional {
        a.has_value = true;
    }

    return true;
}

// This will allocate memory
set :: (a: *Anyx, v: $T) -> bool {
    found := false;
    for a.accepted_types {
        if it == type_info(T) {
            found = true;
            break;
        }
    }

    if !found return false;

    // Allocating memory for data is a must
    p := alloc(size_of(T));
    memcpy(p, *v, size_of(T));

    a.value = (cast(*T)p).*;

    if a.optional {
        a.has_value = true;
    }

    return true;
}

get :: (a: Anyx) -> Any, bool {
    if a.optional && !a.has_value {
        return null, false;
    }

    return a.value, true;
}

clear :: (a: *Anyx) -> bool {
    if !a.optional return false;

    a.value = null;
    a.has_value = false;
    return true;
}

#scope_file
#import "Basic";
#import "Memory";
