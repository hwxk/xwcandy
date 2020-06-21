# -*- coding: UTF-8 -*-
################################################################################
#
#
################################################################################
"""
cpu和内存分析工具

"""

import os
import sys
import subprocess
import time
import re

'''
CPU内存统计工具
v1.0

'''

DEFAULT_APP = "com.xxxxxxxxxxxxm"

CMD_CPU_TPL = "adb shell top -o %%CPU,CMDLINE -s 1 -n 1 | grep --line-buffer -E %s | awk -F ' ' '{print $1}'"
#CMD_CPU_TPL = "adb shell top  -n 1 | grep -E '%s' | head -1 | awk -F ' ' '{print $3}'"
#CMD_MEM_TPL = "adb shell dumpsys meminfo %s | grep -i --line-buffer 'TOTAL SWAP PSS' | awk -F ' ' '{print $2}'"
CMD_MEM_TPL = "adb shell dumpsys meminfo %s | grep 'TOTAL' | awk -F ' ' '{print $2}'"
STAT_TPL = "%s【CPU】实时:%s%% 均值:%s%% 峰值:%s%% 【内存】实时:%sM 均值:%sM 峰值:%sM 历时:%s 次数:%d"
STAT_TPL1 = "%s【CPU】实时:%s%%"

def main():
    parse_args()
    start_stat()
    return


def parse_args():
    global target_app
    if len(sys.argv) > 1:
        target_app = sys.argv[1]
    else:
        target_app = DEFAULT_APP
    return


def start_stat():
    print_stat_info()
    total_cpu = 0
    total_mem = 0
    max_cpu = 0
    max_mem = 0

    stat_count = 0
    start_time = time.time()

    print("统计：" + target_app + "\n")

    # 组装命令
    cmd_cpu=CMD_CPU_TPL % target_app
    cmd_mem=CMD_MEM_TPL % target_app

    print(cmd_cpu)
    print(cmd_mem)

    # cmd_cpu = "adb shell top | grep --line-buffer -E 'baidu'"
    # ps = subprocess.Popen(cmd_cpu, stdin=subprocess.PIPE, stdout = subprocess.PIPE, shell = True)
    # while True:
    #     cpu_line = ps.stdout.readline()
    #     cpu_line = cpu_line.decode("utf8")
    #     print(cpu_line)

    file_name = open("stat-" + target_app + ".txt", 'w', 2)
    file_name.write("==========" + target_app + "=================\n")
    while True:
        try:
            # CPU
            cpu_fd = os.popen(cmd_cpu, 'r')
            cpu_line = cpu_fd.readline()
            #print(cpu_line)
            if len(cpu_line) == 0:
                # print("进程未启动")
                continue
            temp_cpu_line = re.sub('[\\r\\n\\t%]', '', cpu_line)
            cpu = float(temp_cpu_line)
            #print(cpu)
            if cpu > max_cpu:
                max_cpu = cpu
                pass
            total_cpu += cpu
            cpu_fd.close()

            # 内存
            mem_fd = os.popen(cmd_mem, 'r')
            mem_line = mem_fd.readline()
            mem = float(mem_line)/1024
            # print(mem)
            if mem > max_mem:
                max_mem = mem
                pass
            total_mem += mem
            mem_fd.close()
            stat_count += 1
            # 统计
            # 21:11:12【CPU】实时:9.3% 均值:9.3% 峰值:9.3% 【内存】实时:149.2M 均值:149.2M 峰值:149.2M 历时:0时0分0秒
            avg_cpu = total_cpu / stat_count
            avg_mem = total_mem / stat_count

            spend_time = get_spend_time(start_time)

            out_result = STAT_TPL % (cur_time(), str(round(cpu, 2)), str(round(avg_cpu, 2)), str(round(max_cpu, 2)) , str(round(mem, 2)), str(round(avg_mem, 2)), str(round(max_mem, 2)), spend_time, stat_count)
            print(out_result)
            file_name.write(out_result + "\n")
            
        except KeyboardInterrupt:
            file_name.close
            sys.exit(1)
        except Exception as e:
            file_name.close 
            print("exception:" + e.message)
        time.sleep(10)

    file_name.close

    return


def cur_time():
    return time.strftime('%H:%M:%S', time.localtime(time.time()))


def get_spend_time(start_time):
    total_time = time.time() - start_time
    m, s = divmod(total_time, 60)
    h, m = divmod(m, 60)
    return "%02d:%02d:%02d" % (h, m, s)

def print_stat_info():

    print("====================================")
    print("Android性能测试统计工具 v4.0")
    print("")
    print("本工具基于top命令统计CPU的实时、均值和峰值")
    print("CPU计算方法，CPU均值=周期内每次CPU占用之和/总次数")
    print("内存统计基于dumpsys meminfo中TOTAL SWAP PSS的值")
    print("内存计算方法，内存均值=周期内每次内存占用之和/总次数")
    print("")
    print("停止统计按下ctrl+c（MAC下）")
    print("====================================")
    return

if __name__ == "__main__":
    sys.exit(main())
