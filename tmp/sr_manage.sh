#!/bin/bash
# TODO 尝试添加 systemctl 服务, https://blog.csdn.net/weixin_45971974/article/details/127850077

# check env SR_HOME 
if [ -z $SR_HOME ]; then
    echo "SR_HOME is not set"
    exit 1
else
    echo "SR_HOME: $SR_HOME"
fi

# sr_path="/opt/apps/StarRocks-3.1.3"

# 定义start函数, 服务restart
function start() {
    echo " ============ start SR cluster ==================== "
    echo " -------- 启动 FE -------"
    $SR_HOME/fe/bin/start_fe.sh --daemon
    echo " -------- 启动 BE -------"
    /opt/apps/l3_script/xcall.sh "$SR_HOME/be/bin/start_be.sh --daemon"
    echo " -------- 启动 Broker -------"
    $SR_HOME/apache_hdfs_broker/bin/start_broker.sh --daemon
}

function stop() {
    echo " ============ stop SR cluster ==================== "
    echo " -------- 停止 FE -------"
    $SR_HOME/fe/bin/stop_fe.sh --daemon
    echo " -------- 停止 BE -------"
    /opt/apps/l3_script/xcall.sh "$SR_HOME/be/bin/stop_be.sh --daemon"
    echo " -------- 停止 Broker -------"
    $SR_HOME/apache_hdfs_broker/bin/stop_broker.sh --daemon
}

function restart() {
    echo " ============ restart SR cluster ==================== "
    stop
    start
}

function status() {
    # 进程状态
    # 日志查询
    # mysql查询
    echo " ============ status SR cluster ==================== "
    # fe check ps StarRocksFE
    echo " -------- FE -------"
    jps | grep StarRocksFE
    # be check ps starrocks_be
    echo " -------- BE -------"
    /opt/apps/l3_script/xcall.sh "ps -ef | grep starrocks_be | grep -v grep"
    # check broker 
    echo " -------- Broker -------"
    jps | grep Broker
}

case $1 in
"start")
    start
;;
"stop")
    stop
;;
"restart")
    restart
;;
"status")
    status
;;
*)
    echo "Input Args: $i Error...: please input [start|stop|status|restart]"
;;
esac



