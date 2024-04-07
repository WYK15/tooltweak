TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

# rootful越狱需要注释此配置
THEOS_PACKAGE_SCHEME=rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = airdropOn

airdropOn_FILES = Tweak.x
airdropOn_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
