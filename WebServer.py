import os
from flask import Flask, request, abort
import pika
import uuid

app = Flask(__name__)
hostname = 'localhost'


class My_RPC_Client(object):
    def __init__(self):
        #Right, now we'll establish a blocking client connection 
        #Set up our client's connection to Rabbit Server
        self.connection = pika.BlockingConnection(pika.ConnectionParameters(host=hostname))
        self.channel = self.connection.channel()

        #Establish a callback queue for requests
        my_queue = self.channel.queue_declare(exclusive=True)
        self.callback_queue = my_queue.method.queue
        self.channel.basic_consume(self.response_check, no_ack=True, queue=self.callback_queue)

    def response_check(self, ch, method, props, body):
        if self.corr_id == props.correlation_id:
            self.response = body

    def call_RPC(self, message, my_type):
        self.response = None
        self.corr_id = str(uuid.uuid4())

        channel.basic_publish(exchange='',
                                routing_key='rpc_queue',
                                properties=pika.BasicProperties(
                                    reply_to = self.callback_queue,
                                    correlation_id = self.corr_id,
                                    ),
                                   body=(message, my_type))
        
        while self.response is None:
            connection.process_data_events()
        return str(self.response)

@app.route('/')
def home():
    return "We are here to help you understand the craziness that is Congress!"

@app.route('/lookup/date/<date>', methods=['GET'])
def find_by_date(date):
    if request.method == 'GET':
        print "looking for what congress did on {0}".format(date)
        my_rabbit = My_RPC_Client()
        return my_rabbit.call_RPC(date, 'date')
    else:
        abort(403)

@app.route('/lookup/person/<name>')
def find_by_name(name):
    if request.method == 'GET':
        print "looking for what {0} has been up to in Congress".format(name)
        my_rabbit = My_RPC_Client()
        return my_rabbit.call_RPC(date, 'name')
    else:
        abort(403)

@app.route('/lookup/title/<doc_title>')
def find_by_title(doc_title):
    if request.method == 'GET':
        print "looking for documents about {0} ".format(doc_title)
        my_rabbit = My_RPC_Client()
        return my_rabbit.call_RPC(date, 'doc')
    else:
        abort(403)

@app.route('/lookup/search/<search_string>')
def open_search(search_string):
    if request.method == 'GET':
        print "looking for anything involving {0} in Congress".format(search_string)
        my_rabbit = My_RPC_Client()
        return my_rabbit.call_RPC(date, 'search')
    else:
        abort(403)

@app.route('/dump/record/<record_num>')
def dump_record(record_num):
    pass

if __name__ == "__main__":
    app.debug = True
    app.run(host='0.0.0.0', port=8080)
