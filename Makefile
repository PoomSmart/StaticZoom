DEBUG = 0
PACKAGE_VERSION = 0.0.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = StaticZoom
StaticZoom_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk


