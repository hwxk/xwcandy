# 统计平均帧率。
eval `awk '{total += ($1 + $2 + $3 + $4)} END {printf("frame_total=%0.2f;frame_count=%d;frame_avage=%0.2f", total, NR, total/NR)}' $1`

# 输出结果
cat <<EOF

---------
|-------------------------------- 
|  总时长:       ${frame_total}
|  总帧数:       ${frame_count}
|--------------------------------
|  平均帧长:     ${frame_avage}
|________________________________


CTRL+C 退出
=========END==========

EOF