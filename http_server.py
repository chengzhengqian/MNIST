from flask import Flask, jsonify, render_template, request
import socket
app = Flask(__name__,template_folder="template")

ip='127.0.0.1'
port=10116

size=1024

def send(txt):
    print("send cmd:%s\n"%txt)
    s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect((ip,port))
    s.send((txt+"\n").encode())
    data=s.recv(size)
    s.close()
    return data.decode()


@app.route("/hello")
def hello():
    return "hello"
ADD="ADD"
CLEAN="CLEAN"
PREDICT="PREDICT"
OK="OK"
@app.route('/_add_point')
def add_point():
    x = request.args.get('x', 0, type=float)
    y = request.args.get('y', 0, type=float)
    # return jsonify(result=(a+ b))
    r=send("%s,%f,%f"%(ADD,x,y))
    print(r)
    return jsonify(result=r)


@app.route('/_clean')
def clean():
    r=send(CLEAN)
    print(r)
    return jsonify(result=r)

@app.route('/_predict')
def predict():
    r=send(PREDICT)
    print("predict\n")
    print(r)
    return jsonify(result=r)

# @app.route('/_add_numbers')
# def add_numbers():
#     a = request.args.get('a', 0, type=int)
#     b = request.args.get('b', 0, type=int)
#     # return jsonify(result=(a+ b))
#     r=send(str(request.args.get('a')))
#     print(r)
#     return jsonify(result=r)

@app.route('/')
def index():
    return render_template('show.html')

def run():
    app.run(host="0.0.0.0",port=9903,debug=True)
    

if __name__=="__main__" :
    run()
