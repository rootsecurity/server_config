# Elasticsearch集群的备份与恢复
    0x01:
    在ES集群上做一个NFS，并挂载：
    [root@localhost ~]# yum install nfs-utils*
    [root@localhost ~]# vi /etc/exports
    输入集群的IP地址，例如：
    192.168.1.2(rw)
    192.168.1.3(rw)
    192.168.1.4(rw)
    保存退出,并启动NFS服务
    [root@localhost ~]# service nfs start
    [root@localhost ~]# service rpcgissd start
    [root@localhost ~]# service rpcbind start
    挂载NFS
    [root@localhost ~]# mount elasticsearch.master:/data/es/es_backup /data/es/es_backup
    0x02:
    在elasticsearch.master端执行:
    curl -XPUT 'http://elasticsearch.master:9200/_snapshot/backup' -d '{
    "type": "fs",
    "settings": {
        "location": "/data/es/es_backup",
        "compress": true
      }
    }'
    0x03:
    备份操作，名字根据自己的情况修改
    curl -XPUT http://elasticsearch.master:9200/_snapshot/backup/logstash-2016.01.01 -d '     
    {"indices":"logstash-sec-2016.01.01",
    "ignore_unavailable": "true",
    "include_global_state": false }'
    0x04:
    查看备份状态:
    curl –XGET  http://elasticsearch.master:9200/_snapshot/backup/logstash-security-2016.01.01
    0x05:
    删除备份
    curl -XDELETE  http://elasticsearch.master:9200/_snapshot/backup/logstash-security-2016.01.01
    0x06:
    恢复备份
    curl -XPOST http://elasticsearch.master:9200/_snapshot/backup/logstash-security-2016.01.01/_restore -d ' { "indices" : "logstash-security-2016.01.01"}'


