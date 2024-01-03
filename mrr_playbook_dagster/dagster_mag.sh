#!/bin/bash
# TODO 尝试添加 systemctl 服务, https://blog.csdn.net/weixin_45971974/article/details/127850077

# check env DAGSTER_HOME
if [ -z $DAGSTER_HOME ]; then
    echo "DAGSTER_HOME is not set"
    exit 1
else
    echo "DAGSTER_HOME: $DAGSTER_HOME"
fi

# sr_path="/opt/apps/StarRocks-3.1.3"

# 定义start函数, 服务restart

function command_exec_status() {
    if [ $? -eq 0 ]; then
        echo "command exec success"
    else
        echo "command exec failed"
    fi
}

function start() {
    export DAGSTER_DBT_PARSE_PROJECT_ON_LOAD=1
    nohup dagster dev -h 0.0.0.0 2>&1 > dagster_dev.log 2>&1 &
    command_exec_status
    # todo 启动需要时间, 需要监控到3000端口正常运行.
}

function stop() {
    netstat -ntlp | grep -v grep | grep 3000 | awk '{print $7}' | awk -F"/" '{print $1}' | xargs kill -9
    command_exec_status
}

function restart() {
    echo " ============ restart SR cluster ==================== "
    stop
    start
}

function status() {
    netstat -ntlp | grep -v grep | grep 3000
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