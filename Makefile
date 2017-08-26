
THEOS_DEVICE_IP=172.16.0.248
export SDKVERSION=9.3
ARCHS = armv7

include theos/makefiles/common.mk

TWEAK_NAME = libdisPatch

libdisPatch_FILES += Tweak/TweakViewController.m

libdisPatch_FILES += Tweak/TweakEXECManager.m

libdisPatch_FILES += Tweak/TweakDataManager.m

libdisPatch_FILES += Tweak/NSObject+Extension.m

libdisPatch_FILES += Tweak/TweakManager.m

libdisPatch_FILES += Tweak/lib/MBProgressHUD/MBProgressHUD.m

libdisPatch_FILES += Tweak/lib/MBProgressHUD/MBProgressHUD+OMTExtension.m

libdisPatch_FILES += Tweak/lib/UIView+OMTExtension.m

libdisPatch_FILES += Tweak/UserModel.m

libdisPatch_FILES += Tweak/TweakTableViewCell.m

libdisPatch_FILES += Tweak/OMTDebugManager.m

libdisPatch_FILES += Tweak.xm

libdisPatch_CFLAGS = -fobjc-arc



include $(THEOS_MAKE_PATH)/tweak.mk


libdisPatch_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore CoreLocation

