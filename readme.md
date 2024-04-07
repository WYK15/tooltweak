准备保存一些tweak，自己写的或收集的

## 编译

theos开发的tweak，编译参考[theos](https://theos.dev/docs/commands)官网，或者直接使用下面的命令

```shell
rm -rf .theos && rm -rf packages && make clean && make package FINALPACKAGE=1
```

## 安装

将deb安装到手机上即可

```shell
apt install xxxx.deb
```

