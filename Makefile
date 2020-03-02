INSTALL_TARGET_PROCESSES = SpringBoard
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Arch
Arch_FRAMEWORKS = LocalAuthentication
ARCHS = arm64 arm64e
Arch_FILES = Tweak.xm
Arch_CFLAGS = -fobjc-arc
Arch_LIBRARIES = sparkapplist
include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += archpref
include $(THEOS_MAKE_PATH)/aggregate.mk
