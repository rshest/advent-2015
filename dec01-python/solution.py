import sys

path = ' '.join(sys.stdin.readlines())

# part 1
floor = path.count('(') - path.count(')')
print "Floor: %d"%(floor)

# part 2
bpos = 1
floor = 0
for c in path:
    floor += {'(':1, ')':-1}[c]
    if floor < 0: 
        break
    bpos += 1
    
print "First basement position: %d"%bpos
