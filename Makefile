THEOS ?= $(CURDIR)/theos
include $(THEOS)/makefiles/common.mk

ARCHS = arm64
TARGET = iphone:clang:latest:14.0

TWEAK_NAME = CleanMenu
CleanMenu_FILES = Tweak.xm \
                  ImGuiDrawView.mm \
                  menu.m \
                  NativeMenuBridge.mm \
                  Esp/ImGuiLoad.m \
                  Esp/JHPP.m \
                  Esp/JHDragView.m \
                  Esp/JHUIViewControllerDecoupler.m \
                  Esp/PubgLoad.mm \
                  IMGUI/imgui.cpp \
                  IMGUI/imgui_draw.cpp \
                  IMGUI/imgui_tables.cpp \
                  IMGUI/imgui_widgets.cpp \
                  IMGUI/imgui_impl_metal.mm

CleanMenu_FRAMEWORKS = UIKit Foundation Metal MetalKit
CleanMenu_CFLAGS = -fobjc-arc -Wno-unguarded-availability-new
CleanMenu_LDFLAGS = -lz

include $(THEOS)/makefiles/tweak.mk
