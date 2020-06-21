# 使用方法：
通过不同参数模拟不同场景帧率信息。
```bash
# 参数1：指定信息采集场景: 0=重度使用，1=轻度使用，2=正常使用；
# 参数2：指定采样时长，以分钟为单位。如果不指定默认为5分钟。
./capture-fps.sh 0      #重度使用，默认采样5分钟
./capture-fps.sh 1 10   #轻度使用，采样10分
```
> 注意：使用前请打开系统采样开关
> "开发者选项->GPU呈现模式分析->在 adb shell dumpsys gfxinfo中"

# 原理介绍
通过monkey操作进行自动化测试，同时后台采集前台应用的帧率信息gfxinfo，把采集信息到当前目录fps.info.log文件中。然后通过awk分析输出结果并显示终端上。

>tips:
可以把采集的原始信息导入EXCEL中，通过Excel的插入图表的方式直观展示采样数据。

# 脚本介绍
## capture-fps.sh
封装了 [auto_fps.sh](#auto_fpssh), 方便使用。
1. 后台启动 auto_fps.sh 的方法
```bash
# 注意最后有“&”
sh auto_fps.sh $monkey_time $1 &
```
2. 根据使用场景配置monkey执行参数并执行

## auto_fps.sh
1. 每隔 2s dump gfxinfo 中帧率信息到fpsinfo.log中
2. 停止monkey
3. awk 统计fpsinfo.log中的信息

## gfxinof.sh
1. 通过命令获取当前应用的包名
2. dump当前应用的gfxinfo
3. dump当前应用的SurfaceFlinger获取帧率信息
   
## fps-stat.sh
对传入文件通过awk做做数据分析。
```bash
$ fps-stat.sh fpsinfo.log
$
|-------------------------------- 
|  总时长:       ${frame_total}
|  总帧数:       ${frame_count}
|--------------------------------
|  平均帧长:     ${frame_avage}
|________________________________

```
