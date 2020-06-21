#!/bin/bash
# 
# 把采集信息到当前目录fps.info.log文件中。
# 可以把采集的原始信息导入EXCEL中，通过Excel的插入图表的方式直观展示采样数据。


# 设置Monkey的事件之间的时长。默认1s一次。
throttle=1000
# 以秒（s）的方式，设置Monkey执行的总时间。 默认5分钟。
monkey_time=(5 * 60 * 1000)

function set_monkey_param() {
	monkey_time=`expr $2 \* 60 \* 1000`
	echo "Monkey 执行时间 ${monkey_time}"
	#重度使用
	if [[ $1 -eq 0 ]];then
		echo "重度使用场景：每0.5s触发一次事件"
		throttle=500
	elif [[ $1 -eq 1 ]]; then
		echo "轻度使用场景：每2s触发一次事件"
		throttle=2000
	else
		echo "普通使用场景：每1s触发一次事件"
		throttle=1000
	fi

}

function help_info() {
cat <<EOF
.
-
-------------------------------

通过monkey操作进行自动化测试，同时后台采集前台应用的帧率，
把采集信息到当前目录fps.info.log文件中。
可以把采集的原始信息导入EXCEL中，通过Excel的插入图表的方式直观展示采样数据。

注意：
使用前请打开系统采样开关。
    ”开发者选项->GPU呈现模式分析->在 adb shell dumpsys gfxinfo中"

使用方法：
	参数1：指定信息采集场景: 0=重度使用，1=轻度使用，2=正常使用；
	参数2：指定采样时长，以分钟为单位。如果不指定默认为5分钟。

	./capture-fps.sh 0      #重度使用，默认采样5分钟
	./capture-fps.sh 1 10   #轻度使用，采样10分钟

-------------------------------
EOF
}

#配置Monkey的参数
if [ $# -eq 1 ]; then
	echo "指定场景: $1 采集5分钟"
	set_monkey_param $1 5	
elif [ $# -eq 2 ]; then
	echo "使用场景 $1 / 时长： $2 分钟----"
	set_monkey_param $1 $2
else
	help_info
	exit 0
fi

echo " >>>>>>开始时间 $(date +%Y/%m/%d %H:%M:%S)"

sh auto_fps.sh $monkey_time $1 &

echo "=== Start monkey：throttle:${throttle} ==="
adb shell monkey --throttle ${throttle} \
                 --ignore-crashes --ignore-timeouts --ignore-security-exceptions \
                 --ignore-native-crashes \
                 --pct-syskeys 0 \
                 -s 100 -v -v 100000

echo "===  monkey END ==="
exit 0