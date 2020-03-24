ARCHS = arm64 arm64e
TARGET = iphone:clang::10.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = 3DBadgeClear
BUNDLE_NAME = com.isklikas.3DBadgeClear-resources

3DBadgeClear_FILES = Tweak.x
3DBadgeClear_CFLAGS = -fobjc-arc
com.isklikas.3DBadgeClear-resources_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += 3dbadgeclearprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
