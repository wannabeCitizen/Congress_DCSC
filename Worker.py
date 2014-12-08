#!/usr/bin/env python
import pika

hostname = 'webserver.local'

connection = pika.BlockingConnection(pika.ConnectionParameters(
        host=hostname))

channel = connection.channel()

channel.queue_declare(queue='rpc_queue')

response_types = {
    'date': by_date,
    'name': by_name,
    'doc' : by_doc,
    'search' : search
}

def by_date(q_date):
    pass

def by_name(q_name):
    pass

def by_doc(q_doc):
    pass

def search(q_string):
    pass

def on_request(ch, method, props, body):
    query = body[0]
    my_type = body[1]

    print "Received Request of type {0}".format(my_type)
    response = response_types[my_type](query)

    ch.basic_publish(exchange='',
                     routing_key=props.reply_to,
                     properties=pika.BasicProperties(correlation_id = \
                                                         props.correlation_id),
                     body=str(response))
    ch.basic_ack(delivery_tag = method.delivery_tag)

channel.basic_qos(prefetch_count=1)
channel.basic_consume(on_request, queue='rpc_queue')

print " [x] Awaiting RPC requests"
channel.start_consuming()