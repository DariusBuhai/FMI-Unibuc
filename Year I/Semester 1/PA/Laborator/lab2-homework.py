
# Tema:
# Vi se da un text pe un singur rand format din litere, cifre spatii si semne de punctuatie.
# Trebuie sa numarati cate cuvinte sunt si sa le afisati pe cele mai scurte 10.

text = 'Ana.are mere, Ion are pereeee ofiuvneriuvnrtiuvn ikefive ieve aaaaaaaa!'

def format1(text):  # using list comprehension
    return ''.join(list([x if (ord(x) >= ord('a') and ord(x) <= ord('z')) or (ord(x) >= ord('A') and ord(x) <= ord('Z')) else ' ' for x in text])).split()

def format2(text):  # using regex
    import re as reg
    return reg.findall("[a-zA-Z]+", text)

def string_size(s):
    return len(s)

#text = format1(text)  # Turning text into an array of words with list comprehension
text = format2(text)  # Turning text into an array of words with regex

text.sort(key = string_size)  # Sorting the words by their lengths

print("\nTextul dat contine",len(text),"cuvinte", end="\n\n")
print("Cele mai scurte cuvinte sunt in ordine:\n","\n  * ".join(text[:10]), sep='  * ')


