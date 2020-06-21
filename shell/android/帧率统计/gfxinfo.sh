#!/bin/bash
# dump当前app的gfxinfo

curAppPkg=`adb shell dumpsys window windows | grep -E 'mCurrentFocus' |awk  -F ' '  '{print $3}'|awk -F '/' '{print $1}'`
echo  $i $curAppPkg

echo  '\n----gfxinfo-----\n'
adb shell dumpsys gfxinfo $curAppPkg

echo  '\n----SurfaceFlinger-----\n'
adb shell dumpsys SurfaceFlinger --latency $curAppPkg
