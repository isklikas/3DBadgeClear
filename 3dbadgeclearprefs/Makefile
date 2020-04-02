ARCHS = arm64 arm64e
TARGET = iphone:clang::10.0
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = 3DBadgeClearPrefs

3DBadgeClearPrefs_FILES = BDGCLRListController.m BDGCLRHeaderCell.m BDGCLRPreferenceSettings.m BDGCLRTableCell.m BDGCLRRootListController.m
3DBadgeClearPrefs_INSTALL_PATH = /Library/PreferenceBundles
3DBadgeClearPrefs_FRAMEWORKS = QuartzCore IOSurface OpenGLES CoreVideo UIKit
3DBadgeClearPrefs_PRIVATE_FRAMEWORKS = Preferences
3DBadgeClearPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/3DBadgeClearPrefs.plist$(ECHO_END)
