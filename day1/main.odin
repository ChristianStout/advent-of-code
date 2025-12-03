package day1

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

STARTING_POINT :: 50;

Dial :: struct {
    position: int,
    rested_at_0: int,
    touched_0: int,
}

turn_dial_from_instructions :: proc(dial: ^Dial, filepath: string) {
    data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.printf("file does not exist : %v\n", filepath)
		return
	}
	defer delete(data, context.allocator)


    // fmt.print(data)
    
	it := string(data)
	for line in strings.split_lines_iterator(&it) {
		// fmt.printf("line[0:1]: %v, value: %v\n", line[0:1], line[1:])
        l_or_r := line[0:1]
        value, ok := strconv.parse_int(line[1:])

        if !ok {
            fmt.print("could not parse an int from line\n")
            return
        }

        amount := value

        if l_or_r == "L" {
            turn_left_caveman(dial, amount)
        }
        else {
            turn_right_caveman(dial, amount)
        }

        // fmt.printf("\tdial value: %v, passed 0: %v\n\n", dial.position, dial.touched_0)

        if dial.position == 0 {
            dial.rested_at_0 += 1
        }
	}
}


turn_left_caveman :: proc(dial: ^Dial, amount: int) {
    for i in 0..<amount {
        dial.position -= 1
        if dial.position == 0 {
            dial.touched_0 += 1
        }
        if dial.position == -1 {
            dial.position = 99
        }
    }
}

turn_right_caveman :: proc(dial: ^Dial, amount: int) {
    for i in 0..<amount {
        dial.position += 1
        if dial.position == 100 {
            dial.position = 0
        }
        if dial.position == 0 {
            dial.touched_0 += 1
        }
    }
}

turn_left :: proc(dial: ^Dial, amount: int) {
    old_pos := dial.position
    dial.position -= amount

    if amount < old_pos {
        return
    }

    complement := 100 - old_pos
    combined := complement + amount

    calc_zero(dial, old_pos, combined)

    dial.position %= 100
    if dial.position < 0 {
        dial.position = 100 + dial.position
    }
}

turn_right :: proc(dial: ^Dial, amount: int) {
    old_pos := dial.position
    dial.position += amount

    combined := old_pos + amount

    calc_zero(dial, old_pos, combined)

    dial.position %= 100
}

calc_zero :: proc(dial: ^Dial, old_pos: int, sum: int) {
    dial.touched_0 += sum / 100
    if old_pos == 0 {
        dial.touched_0 -= 1
    }
}

main :: proc() {
    dial := Dial { STARTING_POINT, 0, 0 }
    turn_dial_from_instructions(&dial, "day1/input.txt")
    fmt.printf("RESTED AT 0: %v\n", dial.rested_at_0)
    fmt.printf("Touched 0: %v\n", dial.touched_0)
}
