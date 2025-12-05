package day3

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

calc_jolts :: proc(filepath: string) {
    data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
        fmt.printf("file does not exist : %v\n", filepath)
		return
	}
	defer delete(data, context.allocator)
    
	it := string(data)
    sum := 0
	for line in strings.split_lines_iterator(&it) {
        sum += find_max_joltage(line)
	}

    fmt.printf("sum = %v\n", sum)
}

find_max_joltage :: proc(line: string) -> int {
    max_bank := -1
    max_sum := -1

    for r in line {
        curr, ok := strconv.digit_to_int(r)
        if !ok {
            fmt.print("THIS FAILED")
            return -1
        }

        fmt.printf("line: %v, max_sum: %v\n", line, max_sum)
        curr_combined :=  (max_bank * 10) + curr
        if curr_combined > max_sum {
            max_sum = curr_combined
        }
        if curr > max_bank {
            max_bank = curr
        }
    }

    return max_sum
}

main :: proc() {
    calc_jolts("day3/input.txt")
}