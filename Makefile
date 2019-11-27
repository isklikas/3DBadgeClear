INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 3DBadgeClear

3DBadgeClear_FILES = Tweak.x
3DBadgeClear_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
