脚本<font color=red>只适用于Android O 以下</font>。
> 自 Android P 开始，已经检查 NET_CAPABILITY_NOT_METERED 的应用开发者将收到关于 VPN 网络能力和底层网络的信息，应用无法再访问 xt_qtaguid 文件夹中的文件,不再允许应用直接读取 /proc/net/xt_qtaguid 文件夹中的文件。 
> 这样做是为了确保与某些在发布时运行 Android P、但未提供这些文件的设备保持一致。