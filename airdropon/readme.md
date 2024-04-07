hook了"/usr/libexec/sharingd"

## 关于sharingd

次程序被`launchctl`加载到系统的守护进程中，利用`launchctl list`可以看到它一直在运行。

经过google，发现它的plist配置文件在/System/Library/LaunchDaemons/com.apple.sharingd.plist



## 逆向sharingd

利用hopper disassembler，可以看到方法名，10分钟系统自动关闭airdrop时，系统log有提示，看到是sharingd打印的，通过打印的日志字符串，发现关闭airdrop时，执行了

`-[SDStatusMonitor _expireEveryoneModeAndOnlySetDefault:`方法，改方法接收一个参数，int类型。

若此方法参数为0，则执行`-[SDStatusMonitor setDiscoverableMode:]`方法，关闭airdrop；

若此方法参数为0，则写userdefault，记录，但是不关闭airdrop。

因此，hook`expireEveryoneModeAndOnlySetDefault`方法，设置参数为1即可，则10分钟时，不会关闭airdrop



## 定时关闭

hook `-[SDStatusMonitor _everyoneModeExpiryDate]`可以设置airdrop所有人开启的时间







