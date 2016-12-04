parse_idx_pair(str) = map(x -> parse(Int64, x) + 1, split(str, ","))

@enum OP turn_on=1 turn_off=2 toggle=3

function parse_op(str::String)
    parts = split(str, " ")
    if parts[1] == "turn"
        x1, y1 = parse_idx_pair(parts[3])
        x2, y2 = parse_idx_pair(parts[5])
        op = (parts[2] == "on") ? turn_on : turn_off
    else
        x1, y1 = parse_idx_pair(parts[2])
        x2, y2 = parse_idx_pair(parts[4])
        op = toggle
    end
    return (op, (x1, y1), (x2, y2))
end

function apply_op1(m::BitArray{2}, str::String)
    op, (x1, y1), (x2, y2) = parse_op(str)
    if op == toggle
        m[y1:y2, x1:x2] $= true
    else
        m[y1:y2, x1:x2] = (op == turn_on)
    end
    return m
end

function apply_op2(m::Array{Float64,2}, str::String)
    op, (x1, y1), (x2, y2) = parse_op(str)
    if op == toggle
        m[y1:y2, x1:x2] += 2
    else
        m[y1:y2, x1:x2] += (op == turn_on) ? 1 : -1
    end
    return max(m, 0)
end

# read data
file = length(ARGS) > 0 ? ARGS[1] : "input.txt"
f = open(file);
lines = readlines(f)

const GRIDW, GRIDH = 1000, 1000

# part 1
m1 = foldl(apply_op1, falses(GRIDH, GRIDW), lines)
@printf "Number of lights on: %d\n" sum(m1)

# part 2
m2 = foldl(apply_op2, zeros(GRIDH, GRIDW), lines)
@printf "Total brightness: %d\n" sum(m2)