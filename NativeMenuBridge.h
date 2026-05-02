#pragma once
#import <UIKit/UIKit.h>

// Call once at startup to configure the native menu with all ZX_ feature toggles
// After calling this, use OpenMenu() / CloseMenu() from menu.h as usual
#ifdef __cplusplus
extern "C" {
#endif

void NativeMenuSetup(void);
void NativeMenuSyncStates(void); // Call to push current ZX_ state → switch UI

#ifdef __cplusplus
}
#endif
