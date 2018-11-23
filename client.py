import socket

ip='127.0.0.1'
port=10105

size=1024

def conenct():
    s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect((ip,port))
    s.send("good help\n".encode())
    data=s.recv(size)
    print("get:",data)
    s.close()
