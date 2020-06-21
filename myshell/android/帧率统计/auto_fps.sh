#!/bin/bash

FPS_FILS="fpsinfo.log"

if [ "$2" ];then
	FPS_FILS="fpsinfo_$2_$1_$(date +%Y%m%d%H%M_%S).log"
fi

count=`expr $1 / 2000`

echo "======\n 将采集 $count 次信息到 ${FPS_FILS} 中 \n======"

for((i=1; i<= $count; i++));
do 
    curAppPkg=`adb shell dumpsys window windows | grep -E 'mCurrentFocus' |awk  -F ' '  '{print $3}'|awk -F '/' '{print $1}'`
    echo  $i $curAppPkg
    adb shell dumpsys gfxinfo $curAppPkg | grep -E '[0-9]+\.[0-9]+\t[0-9]+\.[0-9]+\t[0-9]+\.[0-9]+\t[0-9]+\.[0-9]+' | grep '' >> ${FPS_FILS}
    sleep 2s 
done

echo "Stop monkey!!!"
adb shell ps | grep com.android.commands.monkey | awk '{print $2}' | xargs adb shell kill


# 统计平均帧率。
eval `awk '{total += ($1 + $2 + $3 + $4)} END {printf("frame_total=%0.2f;frame_count=%d;frame_avage=%0.2f", total, NR, total/NR)}' ${FPS_FILS}`

# 输出结果
cat > "${FPS_FILS}.stat" <<EOF

---------
结束时间：$(date +%Y%m%d%H%M_%S)
信息保存在${FPS_FILS}中，统计信息如下：

|-------------------------------- 
|  总时长:       ${frame_total}
|  总帧数:       ${frame_count}
|--------------------------------
|  平均帧长:     ${frame_avage}
|________________________________


CTRL+C 退出
=========END==========

EOF

cat "${FPS_FILS}.stat"

exit 0