X = 0
Y = 1


def nearest_intersection(wires):
    wires = wires.split("\n")
    wire_paths = [wire_path(wire) for wire in wires]
    contact_points = [
        contact_point(seg1, seg2) for seg1 in wire_paths[0] for seg2 in wire_paths[1]
    ]
    contact_points = [point for point in contact_points if point]
    contact_distances = [
        abs(point[0]) + abs(point[1]) for point, steps in contact_points
    ]
    return min(contact_distances)


def least_steps_intersection(wires):
    wires = wires.split("\n")
    wire_paths = [wire_path(wire) for wire in wires]
    contact_points = [
        contact_point(seg1, seg2) for seg1 in wire_paths[0] for seg2 in wire_paths[1]
    ]
    contact_points = [point for point in contact_points if point]
    contact_points = min(contact_points, key=lambda x: x[1])
    return contact_points[1]


def contact_point(s1, s2):
    segment1, steps1 = s1
    segment2, steps2 = s2

    if segment1[0][X] == segment1[1][X] and segment2[0][Y] == segment2[1][Y]:
        segment1, segment2 = segment2, segment1

    if segment1[0][Y] == segment1[1][Y] and segment2[0][X] == segment2[1][X]:
        seg2_y_range = sorted([segment2[0][Y], segment2[1][Y]])
        seg1_x_range = sorted([segment1[0][X], segment1[1][X]])

        if (
            seg2_y_range[0] < segment1[1][Y] < seg2_y_range[1]
            and seg1_x_range[0] < segment2[0][X] < seg1_x_range[1]
        ):
            steps = abs(segment1[1][Y] - segment2[0][Y]) + abs(
                segment2[0][X] - segment1[0][X]
            )
            return [[segment1[0][Y], segment2[0][X]], steps + steps1 + steps2]

    return None


def wire_path(wire):
    steps = 0
    cur_pos = [0, 0]
    path = []

    wire = wire.split(",")
    for segment in wire:
        direction = segment[0]
        length = int(segment[1:])

        next_pos = None
        if direction == "R":
            next_pos = [cur_pos[0] + length, cur_pos[1]]
        elif direction == "L":
            next_pos = [cur_pos[0] - length, cur_pos[1]]
        elif direction == "U":
            next_pos = [cur_pos[0], cur_pos[1] + length]
        elif direction == "D":
            next_pos = [cur_pos[0], cur_pos[1] - length]

        path.append([[cur_pos, next_pos], steps])
        cur_pos = next_pos
        steps += length

    return path


if __name__ == "__main__":
    test_1 = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
    test_2 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"

    file = open("input03.txt", "r")
    input = file.read()
    file.close()

    assert nearest_intersection(test_1) == 159
    assert nearest_intersection(test_2) == 135
    print(f"Part 1: {nearest_intersection(input)}")

    assert least_steps_intersection(test_1) == 610
    assert least_steps_intersection(test_2) == 410
    print(f"Part 2: {least_steps_intersection(input)}")
