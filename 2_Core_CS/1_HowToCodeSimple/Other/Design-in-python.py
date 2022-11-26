# String -> String
# produce "A-Bb-Ccc" ketika inputnya "abc",
# dengan huruf kapital di awal, pemisah "-", dan diikuti huruf kecil

def check_expect():
    if compounding("") != "":
        print("base_error")

    if compounding("a") != "A":
        print("error1")

    if compounding("abc") != "A-Bb-Ccc":
        print("error3")

    if compounding("HaLo") != "H-Aa-Lll-Oooo":
        print("error_HaLo")

# Stub
#def compounding(str):
#    return ""

def compounding(str):

    if len(str) == 0:
        return ""

    if len(str) == 1:
        return str.upper()

    else:
        return compounding(str[:-1]) + "-" + str[-1].upper() + str[-1].lower() * (len(str) - 1)

check_expect()