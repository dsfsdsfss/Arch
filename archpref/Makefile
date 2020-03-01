include $(THEOS)/makefiles/common.mk
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
BUNDLE_NAME = ArchPrefs
ARCHS = arm64 arm64e
ArchPrefs_FILES = archprefscontroller.m
ArchPrefs_INSTALL_PATH = /Library/PreferenceBundles
ArchPrefs_FRAMEWORKS = UIKit LocalAuthentication
ArchPrefs_PRIVATE_FRAMEWORKS = Preferences
ArchPrefs_CFLAGS = -fobjc-arc
ArchPrefs_LIBRARIES = sparkapplist

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ArcPreferences.plist$(ECHO_END)
