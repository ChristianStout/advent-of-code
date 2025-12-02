package day1

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

STARTING_POINT :: 50;

Dial :: struct {
    position: int,
    rested_at_0: int,
}

turn_dial_from_instructions :: proc(dial: ^Dial, filepath: string) {
    data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.print("I FAILED!!!!")
		return
	}
	defer delete(data, context.allocator)
    
	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		fmt.printf("line[0:1]: %v, value: %v\n", line[0:1], line[1:])
        l_or_r := line[0:1]
        value, ok := strconv.parse_int(line[1:])
        if !ok {
            fmt.print("I FAILED!!!!")
            return
        }

        amount := value

        if l_or_r == "L" {
            turn_left(dial, amount)
        }
        else {
            turn_right(dial, amount)
        }

        fmt.printf("\tdial value: %v\n\n", dial.position)

        if dial.position == 0 {
            dial.rested_at_0 += 1
        }
	}
}

turn_left :: proc(dial: ^Dial, amount: int) {
    dial.position -= amount
    dial.position %= 100
}

turn_right :: proc(dial: ^Dial, amount: int) {
    dial.position += amount
    dial.position %= 100
}

main :: proc() {
    dial := Dial { STARTING_POINT, 0 }
    turn_dial_from_instructions(&dial, "day1/input.txt")
    fmt.printf("RESTED AT 0: %v\n", dial.rested_at_0)
}
