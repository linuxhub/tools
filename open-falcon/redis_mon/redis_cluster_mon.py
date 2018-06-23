#!/usr/bin/env python
#encoding:utf8
#author: www.linuxhub.org
# Redis集群主从节点监控

# pip install redis

import redis
import time
import json
import copy
import requests

class RedisMonitor():

    def __init__(self, redis_hosts, redis_password, endpoint, falcon_agent_api):
        self.redis_hosts = redis_hosts
        self.redis_password = redis_password
        self.endpoint = endpoint
        self.falcon_agent_api = falcon_agent_api


    def stat_info(self,host,port):
        '''
        获取 redis状态信息，返回redis, 连接状态码，角色主从状态码信息(1为从库，2为主库 ), 客户端连接数
        :return: {'stat_code': 1, 'role_code': 1, 'connected_clients': 9}
        '''

        data = {'stat_code': 0, 'role_code': 0, 'connected_clients': 0}

        try:
            pool = redis.ConnectionPool(host=host, port=port, password=self.redis_password)
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
        :return:
        '''

        step = 60
        ts = int(time.time())
        payload = []
        data = {"endpoint": self.endpoint, "metric": "", "timestamp": ts, "step": step, "value": "", "counterType": "", "tags": ""}

        for hosts in str(self.redis_hosts).split(','):
            res = hosts.strip().split(':')
            host = res[0]
            port = res[1]

            info = self.stat_info(host=host,port=port)
            for key in info:
                data["tags"] = "host=%s" % str(host)
                data["metric"] = "redis.%s" % key
                data["value"] = info[key]
                data["counterType"] = "GAUGE"
                payload.append(copy.copy(data))

        #print json.dumps(payload)
        r = requests.post(self.falcon_agent_api, data=json.dumps(payload))

if __name__ == '__main__':
    redis_hosts = "192.168.100.81:6379, 192.168.148.82:6379, 192.168.148.89:63790"
    redis_password = "12345678"
    endpoint = "CCTV.TEST.RedisCluster"
    falcon_agent_api = "http://192.168.100.21:1988/v1/push"
    conn = RedisMonitor(redis_hosts, redis_password, endpoint, falcon_agent_api)
    conn.push_data()








