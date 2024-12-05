import re

content = list(line.strip() for line in open("Input.txt", "r"))
split_index = content.index("") if "" in content else len(content)
rules, updates = [tuple(p.split('|')) for p in content[:split_index]],[u.split(',') for u in content[split_index + 1:]]

n_part_2 = 0
n_part_1 = 0

for values in updates:
    relevant_rules = [(x, y) for x, y in rules if x in values and y in values]
    all_correct = lambda v: all(v.index(x) < v.index(y) for x, y in relevant_rules)

    if all_correct(values): n_part_1 += int(values[len(values) // 2])
    else:
        while not all_correct(values):
            for x, y in relevant_rules:
                xi, yi = values.index(x), values.index(y)
                if xi > yi: values[xi], values[yi] = values[yi], values[xi]

        n_part_2 += int(values[len(values) // 2])

print("Day 5 P1:", n_part_1)
print("Day 5 P2:", n_part_2)