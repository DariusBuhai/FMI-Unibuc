import socket
import struct

s = socket.socket(socket.AF_INET, socket.SOCK_RAW, proto=socket.IPPROTO_UDP)

data, adresa = s.recvfrom(65535)

print(data)
print(adresa)

(port_s, port_d, lungime, chksum) = struct.unpack("!HHHH", data[20:28])
print((port_s, port_d, lungime, chksum))

print(data[28:])
# payload = struct.unpack('!{}s'.format(1000), data[28:])
# print(payload)
