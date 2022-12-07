
filefile = open("list_rkt.txt")

lst_file = []

for i in filefile:
    lst_file.append(i[:-1])

filefile.close()



for i in lst_file:

    raw = list(i)
    raw = list(raw[:-1])
    raw.reverse()

    for j in raw:

        if j == "\\":
            idx = len(raw) - raw.index(j)
            print(i[idx:-4] + ".rkt")
            break
