package day2

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

run_instructions :: proc(filepath: string) -> int {
    data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.printf("file does not exist : %v\n", filepath)
		return -1
	}
	defer delete(data, context.allocator)
    
	it := string(data)

    sum := 0
    for ranges in strings.split(it, ",") {
        split := strings.split(ranges, "-")

        bottom, b_ok := strconv.parse_int(split[0])
        top, t_ok := strconv.parse_int(split[1])

        if !b_ok || !t_ok {
            fmt.print("whatre ya doin")
            return -2
        }

        // fmt.printf("bottom: %v, top: %v\n", bottom, top)

        sum += sum_of_invalid_ids(bottom, top)
    }

    return sum
}

sum_of_invalid_ids :: proc(bottom: int, top: int, ) -> int {
    sum := 0

    for id in bottom..=top {
        buf: [12]u8
        id_string := strconv.write_int(buf[:], cast(i64)id, 10)
        inner: for length in 1..=(len(id_string)-1) {
            if repeats(id_string, length) {
                sum += id
                break inner
            }
        }
    }

    return sum
}

repeats :: proc(id: string, length: int) -> bool {
    if len(id) % length != 0 {
        return false
    }

    prev := id[0:length]
    p := fmt.aprintf("repeats - id: %v, length: %v, operation: [%v", id, length, prev)

    for l := length; l < len(id); l += length {
        curr := id[l:l+length]
        if !(strings.compare(prev, curr) == 0) {
            // fmt.printf("] returning false...\n\n")
            return false
        }
        // p += fmt.aprintf(", %v", curr)
        p = strings.concatenate({p, fmt.aprintf(", %v", curr)})
        prev = curr
    }

    fmt.printf("%v]\n\n", p)
    return true
}

main :: proc() {
    sum := run_instructions("day2/input.txt")

    fmt.printf("sum: %v\n", sum)
}

