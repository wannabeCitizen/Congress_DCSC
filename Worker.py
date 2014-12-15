#!/usr/bin/env python
import pika
import redis

def by_date(q_date):
    data = []
    if redis_date.exists(q_date):
        doc_list = redis_date.lrange(q_date, 0, -1)
        for x in doc_list:
            data.append(redis_rawdoc.get(x))
    print "About to send off data"
    return data
    
def by_name(q_name):
    data = []
    people = redis_name.keys('*'+q_name.upper()+'*')
    for person in people:
        doc_list = redis_name.lrange(person, 0, -1)
        i = 0
        for doc in doc_list:
            if i < 10:
                data.append(redis_rawdoc.get(doc))
                i += 1
    print "About to send off data"
    return data

def by_doc(q_doc):
    data = []
    doc_list = redis_title.keys('*'+q_doc.upper()+'*')
    for title in doc_list:
        docs = redis_doc.lrange(title, 0, -1)
        i = 0
        for doc in docs:
            if i<10:
                data.append(redis_rawdoc.get(doc))
                i += 1
    print "About to send off data"
    return data

def search(q_string):
    pass

def on_request(ch, method, props, body):
    my_message = body.split(',')
    query = my_message[0]
    my_type = my_message[1]

    print "Received Request of type {0}".format(my_type)
    response = response_types[my_type](query)

    ch.basic_publish(exchange='',
                     routing_key=props.reply_to,
                     properties=pika.BasicProperties(correlation_id = \
                                                         props.correlation_id),
                     body=str(response))
    ch.basic_ack(delivery_tag = method.delivery_tag)


redisHost = 'node1-database.local'
redis_rawdoc = redis.Redis(host=redisHost, db=1) # Key = Raw Document File; Value = Body of Document - Raw
redis_name= redis.Redis(host=redisHost, db=2) # Key = Speaker Name; Value = The Raw Doc File Name
redis_title = redis.Redis(host=redisHost, db=3) # Key = License; Value = MD5 Hash
redis_date = redis.Redis(host=redisHost, db=4) # Key = License; Value = File Name

hostname = 'node1-webserver.local'

credentials = pika.PlainCredentials('guest', 'guest')
connection = pika.BlockingConnection(pika.ConnectionParameters(host=hostname, port=5672, credentials=credentials))

channel = connection.channel()

channel.queue_declare(queue='rpc_queue')

response_types = {
    'date': by_date,
    'name': by_name,
    'doc' : by_doc,
    'search' : search
}


channel.basic_qos(prefetch_count=1)
channel.basic_consume(on_request, queue='rpc_queue')

print " [x] Awaiting RPC requests"
channel.start_consuming()
