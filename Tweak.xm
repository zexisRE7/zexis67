#import "menu.h"
#import "NativeMenuBridge.h"

extern "C" void OpenMenu(void);
extern "C" void CloseMenu(void);

%ctor {
    NativeMenuSetup();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        OpenMenu();
    });
}
