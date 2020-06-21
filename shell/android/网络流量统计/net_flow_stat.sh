#/sh/bin
#
# 适用于Android O以下
# 自 Android P 开始，已经检查 NET_CAPABILITY_NOT_METERED 的应用开发者将收到关于 VPN 网络能力和底层网络的信息。
# 
# 应用无法再访问 xt_qtaguid 文件夹中的文件
# 
# 不再允许应用直接读取 /proc/net/xt_qtaguid 文件夹中的文件。 这样做是为了确保与某些在发布时运行 Android P、但未提供这些文件的设备保持一致。
# ————————————————
#############

if [[ $1 == '' ]]; then
    echo "请输入包名"
    exit;
fi
cmd=`adb shell ps -ef | grep $1 | head -n 1 | awk -F ' ' '{print $2}'`
pid=$cmd
echo "pid:"$pid
cmd=`adb shell cat /proc/$pid/status | grep -i uid | awk -F ' ' '{print $2}'`
uid=$cmd
echo "uid:"$uid

index=1
first_data=0

while true
do

	#result_data=`adb shell grep $uid /proc/net/xt_qtaguid/stats | awk '{for(i=6;i<=NF;i++) sum+=$i} END {print sum}'`
	result_data=`adb shell grep $uid /proc/net/xt_qtaguid/stats | awk '{sum+=$6;sum+=$8;} END {print sum}'`
	if [[ $index == 1 ]]; then
		first_data=$result_data;
		echo "原始数据："$first_data;
	fi

	offset_data=$[result_data - first_data];

	f_result=`awk -v n=$result_data 'BEGIN{printf "%0.4f", n/1024/1024}'`
	f_offset=`awk -v n=$offset_data 'BEGIN{printf "%0.4f", n/1024/1024}'`
    time=$(date "+%Y-%m-%d %H:%M:%S")
	echo $time "  次数:"$index " 实时:"$f_result "M  增加:" $f_offset "M";

	sleep 2s
	index=$[index+1]

done
