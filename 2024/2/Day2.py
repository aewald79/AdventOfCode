with open("c:\\Users\\a7618\\Desktop\\Advent of Code\\2024\\2\\Input.txt", 'r') as file:
	lines = [line.strip() for line in file]

def is_safe(report):
	all_inc = True
	all_dec = True
	for i in range(1, len(report)):
		if(report[i] - report[i-1] < 1 or report[i] - report[i-1] > 3):
			all_inc = False
		if(report[i] - report[i-1] < -3 or report[i] - report[i-1] > -1):
			all_dec = False

	return all_inc or all_dec

def count_safe(reports):
	num = 0
	for report in reports:
		if(is_safe(report)):
			print(report)
			num += 1
	return num


def can_be_safe(report):
	for i in range(len(report)):
		new_rep = report[:i] + report[i+1:]
		if(is_safe(new_rep)):
			return True
	return False

def count_safe_new(reports):
	num = 0
	for report in reports:
		if(is_safe(report) or can_be_safe(report)):
			num += 1
	return num

lines = [line.split(" ") for line in lines]
lines = [[int(n) for n in line] for line in lines]

#For part 1:
print(count_safe(lines))

#For part 2:
print(count_safe_new(lines))