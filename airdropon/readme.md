## 插件说明

原创，此tweak在iOS 16.4.1，iphone 8上测试正常，其他不确保生效

iOS 16上，隔空投送功能，选择对所有人开启时，最多10分钟，系统就会自动关闭。

**此插件可以在开启对所有人隔空投送后，不再自动关闭** 。

此插件针对无根越狱(rootless jailbreak)开发，rootful越狱需要修改Makefile，将`THEOS_PACKAGE_SCHEME=rootless`

注释即可

## 关于sharingd

此程序被`launchctl`加载到系统的守护进程中，利用`launchctl list`可以看到它一直在运行。

经过google，发现它的plist配置文件在/System/Library/LaunchDaemons/com.apple.sharingd.plist

## 逆向sharingd

利用hopper disassembler，可以看到方法名，10分钟系统自动关闭airdrop时，系统log有提示，看到是sharingd打印的，通过打印的日志字符串，发现关闭airdrop时，执行了

`-[SDStatusMonitor _expireEveryoneModeAndOnlySetDefault:`方法，改方法接收一个参数，int类型。

若此方法参数为0，则执行`-[SDStatusMonitor setDiscoverableMode:]`方法，关闭airdrop；

若此方法参数为0，则写userdefault，记录，但是不关闭airdrop。

因此，hook`expireEveryoneModeAndOnlySetDefault`方法，设置参数为1即可，则10分钟时，不会关闭airdrop

## 定时关闭

hook `-[SDStatusMonitor _everyoneModeExpiryDate]`可以设置airdrop所有人开启的时间

## 难点记录

1. 通过`launchctl`启动的守护进程，plist文件中，指定进程可能会没生效。因为守护进程一直处于运行状态，可以`kill`进程，或者使用launchctl重新挂载，以让程序重新运行一下，tweak才可以重新加载，以下两种方式都可以：

   ```shell
   killall sharingd
   ```

   ```shell
   launchctl unload /System/Library/LaunchDaemons/com.apple.sharingd.plist
   launchctl load /System/Library/LaunchDaemons/com.apple.sharingd.plist
   ```

2. **被调试的app需要具有`get-task-allow权限**。

   调试系统的守护进程往往不容易，且一些关键进程停止后，可能会造成系统崩溃，调试需要经过一下步骤：

   1. 使用`launchctl`停止运行，例如

      ```
      launchctl unload /System/Library/LaunchDaemons/com.apple.sharingd.plist
      ```

   2. 手动使用`debugserver`运行守护进程

      ```shell
      debugserver -x fork 127.0.0.1:12345 /usr/libexec/sharingd
      ```

   3. 使用lldb链接

      ```shell
      lldb
      process connect connect://127.0.0.1:12345
      ```

   但是，在第三步运行失败，网上有[相关讨论](https://github.com/pwn20wndstuff/Undecimus/issues/900)，**确认被调试的app需要具有`get-task-allow权限**，但是，sharingd并没有这个签名，因此无法运行：

   ```shell
    ldid -e /usr/libexec/sharingd | grep task
   ```

   
