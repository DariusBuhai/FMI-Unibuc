from Cipher.Cipher import AES

key = b'O cheie oarecare'
data = b'testtesttesttesttesttesttesttesttesttest'

cipher = AES.new(key, AES.MODE_ECB)
cipher.encrypt(data)