#!/usr/bin/env python
#encoding:utf8
#author: zeping lai
# Redis主从节点监控

# pip install redis

import redis
import time
import json
import copy
import requests

class RedisMonitor():

    def __init__(self,host,port,password,endpoint,falcon_agent_api):
        self.host = host
        self.port = port
        self.password = password
        self.endpoint = endpoint
        self.falcon_agent_api = falcon_agent_api


    def stat_info(self):
        '''
        获取 redis状态信息，返回redis, 连接状态码，角色主从状态码信息(1为从库，2为主库 ), 客户端连接数
        :return: {'stat_code': 1, 'role_code': 1, 'connected_clients': 9}
        '''

        data = {}

        try:
            pool = redis.ConnectionPool(host=self.host, port=self.port, password=self.password)
            r = redis.Redis(connection_pool=pool)
            info = r.info()
        except Exception, e:
            print "Connection Redis Service Error: %s " % e
            info = {}

        if info:
            stat_code = 1
            connected_clients = info["connected_clients"]
            # 1表示从库，2表示主库
            if info["role"] == "slave":
                role_code = 1
            elif info["role"] == "master":
                role_code = 2
            else:
                role_code = 0
            data["role_code"] = role_code
            data["connected_clients"] = connected_clients
        else:
            stat_code = 0
        data["stat_code"] = stat_code
        return data

    def push_data(self):
        '''
        组合好监控数据推送数据
        :return: [{"step": 60, "endpoint": "GZ-V-L-ZEZE-TEST", "tags": "", "timestamp": 1529654525, "metric": "redis.stat_code", "value": 1, "counterType": "GAUGE"}, {"step": 60, "endpoint": "GZ-V-L-ZEZE-TEST", "tags": "", "timestamp": 1529654525, "metric": "redis.role_code", "value": 1, "counterType": "GAUGE"}, {"step": 60, "endpoint": "GZ-V-L-ZEZE-TEST", "tags": "", "timestamp": 1529654525, "metric": "redis.connected_clients", "value": 9, "counterType": "GAUGE"}]
        '''
        step = 60
        ts = int(time.time())
        payload = []
        data = {"endpoint": self.endpoint, "metric": "", "timestamp": ts, "step": step, "value": "", "counterType": "", "tags": ""}
        info = self.stat_info()
        for key in info:
            data["metric"] = "redis.%s" % key
            data["value"] = info[key]
            data["counterType"] = "GAUGE"
            payload.append(copy.copy(data))

        #print json.dumps(payload)
        r = requests.post(self.falcon_agent_api, data=json.dumps(payload))

if __name__ == '__main__':
    host = "192.168.100.89"
    port = 63790
    password = "12345678"
    endpoint = "GZ-V-L-ZEZE-TEST"
    falcon_agent_api = "http://192.168.100.20:1988/v1/push"
    conn = RedisMonitor(host, port, password, endpoint, falcon_agent_api)
    conn.push_data()

