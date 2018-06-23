#!/usr/bin/env python
#encoding:utf8
#author: www.linuxhub.org
# MySQL从库节点监控

import MySQLdb
import time
import json
import copy
import requests

class MySQLMonitor():

    def __init__(self,host,port,user,password,endpoint,falcon_agent_api):
        self.host = host
        self.port = port
        self.user = user
        self.password = password
        self.endpoint = endpoint
        self.falcon_agent_api = falcon_agent_api

    def stat_info(self):
        '''
        获取 mysql从库状态信息，返回mysql从库, 连接状态码，从库io进程状态码信息(1为正常，0为异常 ), 从库sql进程状态码信息(1为正常，0为异常 ),
        :return: {'stat_code': 0, 'slave_io_running_code': 0, 'slave_sql_running_code': 0}
        '''

        data = {'stat_code': 0, 'slave_io_running_code': 0, 'slave_sql_running_code': 0}
        try:
            db = MySQLdb.connect(host=self.host, port=self.port, user=self.user, passwd=self.password)
            cursor = db.cursor()
            cursor.execute("show slave status;")
            res = cursor.fetchone()
            db.close()
            stat_code = 1
        except Exception, e:
            print "Connection MySQL Service Error: %s " % e
            stat_code = 0

        if stat_code:
            try:
                slave_io_running = res[10]
                slave_sql_running = res[11]

                # 1表示正常，0表示异常
                if slave_io_running == "Yes":
                    slave_io_running_code = 1
                else:
                    slave_io_running_code = 0

                if slave_sql_running == "Yes":
                    slave_sql_running_code = 1
                else:
                    slave_sql_running_code = 0
                data["slave_io_running_code"] = slave_io_running_code
                data["slave_sql_running_code"] = slave_sql_running_code
            except:
                print "MySQL Slave Error:  Not Currently Slave MySQL."
        data["stat_code"] = stat_code
        return data

    def push_data(self):
        '''
        组合好监控数据推送数据
        :return: [{"step": 60, "endpoint": "CCTV.TEST.MysqlCluster", "tags": "host=192.168.100.38", "timestamp": 1529723012, "metric": "mysql.stat_code", "value": 1, "counterType": "GAUGE"}, {"step": 60, "endpoint": "CCTV.TEST.MysqlCluster", "tags": "host=192.168.100.38", "timestamp": 1529723012, "metric": "mysql.slave_io_running_code", "value": 1, "counterType": "GAUGE"}, {"step": 60, "endpoint": "CCTV.TEST.MysqlCluster", "tags": "host=192.168.100.38", "timestamp": 1529723012, "metric": "mysql.slave_sql_running_code", "value": 1, "counterType": "GAUGE"}]
        '''
        step = 60
        ts = int(time.time())
        payload = []
        data = {"endpoint": self.endpoint, "metric": "", "timestamp": ts, "step": step, "value": "", "counterType": "", "tags": ""}
        info = self.stat_info()
        for key in info:
            data["tags"] = "host=%s" % self.host
            data["metric"] = "mysql.%s" % key
            data["value"] = info[key]
            data["counterType"] = "GAUGE"
            payload.append(copy.copy(data))

        print json.dumps(payload)
        r = requests.post(self.falcon_agent_api, data=json.dumps(payload))


if __name__ == '__main__':
    host = "192.168.100.38"
    port = 3306
    user = "root"
    password = "12345678"
    endpoint = "CCTV.TEST.MysqlCluster"
    falcon_agent_api = "http://192.168.100.208:1988/v1/push"
    conn = MySQLMonitor(host, port, user, password, endpoint, falcon_agent_api)
    conn.push_data()

