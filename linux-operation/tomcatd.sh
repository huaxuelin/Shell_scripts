#!/bin/bash
#chkconfig: 345 99 10
# /etc/init.d/tomcatd
# Tomcat auto-start

RETVAL=0

### if you want to use in you system ,please change the PATH about JAVA_HOME  CATALINA_HOME CATALINA_BASE ....#####
#获取当前应用所在目录
##basepath=$(cd `dirname $0`; cd .. ; pwd)
#

basepath=$(cd `dirname $0`; cd .. ; pwd)

# CATALINA_HOME="/opt/apache-tomcat"
javahome=`dirname $(dirname $(which java))`
export JAVA_HOME=$javahome
export CATALINA_HOME=$basepath
export CATALINA_BASE=$basepath

### The below is using the tomcat user.and ,if you want to use root, please change the scripts 
#TOMCATUSER=tomcat

##这个地方可以写成一个函数，带返回那种，调用一次函数，变量的值就会跟着变化的，现在是一个变量，就不再变化了。整个脚本运行过程都是。。。
PID=$(ps -aux |grep $CATALINA_HOME|grep java  |grep -v grep |awk '{print $2}')

start_tomcat()
{
    if [ -z  ${PID} ]
    then
        if [ -f $CATALINA_HOME/bin/startup.sh ];
        then
            echo "Starting Tomcat"
            /bin/sh $CATALINA_HOME/bin/startup.sh
            ##$?获取shell中命令的结束代码
            RETVAL=$?
            echo " OK"
            return $RETVAL
        else
            echo "the start scripts is not exit"
        fi

    else
        echo $PID
        echo "The tomcat service is already running "
    fi
}
stop_tomcat()
{
   if [ -z  ${PID} ]
   then
       echo "The tomcat service is already stop "
   else
       if [ -f $CATALINA_HOME/bin/shutdown.sh ];
       then
           echo "Stopping Tomcat"
           /bin/sh $CATALINA_HOME/bin/shutdown.sh
           #            /bin/su $TOMCATUSER -c $CATALINA_HOME/bin/shutdown.sh
           sleep 3
           if [ -z  $(ps -aux |grep $CATALINA_HOME|grep java  |grep -v grep |awk '{print $2}') ]
           then
               echo "The tomcat service is already stop "
           else
               echo "kill java PID"
               ps -aux |grep $CATALINA_HOME |grep -v grep |awk '{print $2}' |xargs kill -9 >/dev/null
           fi
           RETVAL=$?
           return $RETVAL

       fi
   fi
}
case "$1" in
start)
        start_tomcat
        ;;
stop)
        stop_tomcat
        ;;
restart)
    echo $"Restaring Tomcat"
    stop_tomcat
    sleep 1
    start_tomcat
    ;;
checkPID)
    ps -aux |grep $CATALINA_HOME|grep java  |grep -v grep |awk '{print $2}'
    ;;
*)
        echo $"Usage: $0 {start|stop|restart|checkPID}"
        exit 1
        ;;
esac
exit $RETVAL
