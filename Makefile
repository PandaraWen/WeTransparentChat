THEOS_DEVICE_IP = 192.168.0.137
ARCH = arm64
TARGET = iphone:9.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WeTransparentChat
WeTransparentChat_FILES = Tweak.xm AVManager.m
WeTransparentChat_FRAMEWORKS = UIKit AVFoundation
AVManager.m_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 WeChat"
