import SocketServer  
import person_pb2
from SocketServer import StreamRequestHandler as SRH  
from time import ctime  
  
host = '127.0.0.1'  
port = 6969  
addr = (host,port)  
  
class Servers(SRH):  
    def handle(self):  
        print 'got connection from ',self.client_address  
        self.wfile.write('connection %s:%s at %s succeed!' % (host,port,ctime()))  
        while True:  
            data = self.request.recv(1024)  
            if not data:   
                break  
            person = person_pb2.Person()
            person.ParseFromString(data)
            print person 
            print person.myfield[0]  
            print "RECV from 1:", self.client_address[0]  
            self.request.send(data)  
print 'server is running....'  
server = SocketServer.ThreadingTCPServer(addr,Servers)  
server.serve_forever()  