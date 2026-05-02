// NativeMenuBridge.mm
// Drop this file into your project alongside menu.h / menu.m
// It reads your existing ZX_ variables from ImGuiDrawView.mm and wires them to our native UI.
//
// USAGE in ImGuiDrawView.mm (or Tweak.xm / PubgLoad.mm):
//
//   #import "NativeMenuBridge.h"
//   ...
//   NativeMenuSetup();   // call once after app launches
//   // Then call OpenMenu() / CloseMenu() as normal

#import "menu.h"
#import "NativeMenuBridge.h"

// ── Pull in the ZX_ variables defined in ImGuiDrawView.mm ────────────────────
// These are declared as `static` in ImGuiDrawView.mm, so we forward-declare
// them here as extern. Make sure ImGuiDrawView.mm is compiled in the same
// link unit (it is, via CleanMenu_FILES in the Makefile).

// If your linker complains, remove `static` from each ZX_ variable in
// ImGuiDrawView.mm and add `extern bool ZX_xxx;` declarations in a shared header.

// For now we use a pointer-based approach: the bridge holds NSBlocks that
// read/write the variables via captured references passed at setup time.

// ── Feature descriptor ───────────────────────────────────────────────────────

struct BridgeFeature {
    const char *title;
    const char *subtitle;
    const char *warning;
    bool *varPtr;   // pointer to the ZX_ bool
};

// ── The bridge ───────────────────────────────────────────────────────────────

@interface _NativeMenuBridgeController : NSObject <MenuViewControllerDelegate>
+ (instancetype)shared;
- (void)setupWithFeatures:(NSArray<NSValue *> *)featurePtrs
                   titles:(NSArray<NSString *> *)titles
                subtitles:(NSArray<NSString *> *)subtitles
                 warnings:(NSArray<NSString *> *)warnings;
- (void)syncStates;
@end

@implementation _NativeMenuBridgeController {
    NSMutableArray<NSValue *> *_ptrs;
    NSMutableArray<MenuToggleItem *> *_items;
}

+ (instancetype)shared {
    static _NativeMenuBridgeController *s;
    static dispatch_once_t t;
    dispatch_once(&t, ^{ s = [[_NativeMenuBridgeController alloc] init]; });
    return s;
}

- (void)setupWithFeatures:(NSArray<NSValue *> *)ptrs
                   titles:(NSArray<NSString *> *)titles
                subtitles:(NSArray<NSString *> *)subs
                 warnings:(NSArray<NSString *> *)warns {
    _ptrs  = [ptrs mutableCopy];
    _items = [NSMutableArray array];

    NSMutableArray<MenuToggleItem *> *items = [NSMutableArray array];
    for (NSUInteger i = 0; i < titles.count; i++) {
        NSString *sub  = (i < subs.count)  ? subs[i]  : nil;
        NSString *warn = (i < warns.count) ? warns[i] : nil;
        if ([sub  isEqual:@""]) sub  = nil;
        if ([warn isEqual:@""]) warn = nil;

        MenuToggleItem *item = [[MenuToggleItem alloc] initWithTitle:titles[i]
                                                            subtitle:sub
                                                             warning:warn];

        // Capture pointer to bool so toggle writes directly to ZX_ variable
        bool *boolPtr = (bool *)[ptrs[i] pointerValue];
        item.isEnabled = *boolPtr;

        __weak MenuToggleItem *wItem = item;
        item.onChange = ^(BOOL enabled) {
            *boolPtr = enabled;
            wItem.isEnabled = enabled;
            // Notify delegate if needed
            MenuViewController *menu = GetSharedMenu();
            if (menu && [menu.delegate respondsToSelector:@selector(menuViewController:didToggleItem:enabled:)]) {
                [menu.delegate menuViewController:menu didToggleItem:wItem enabled:enabled];
            }
        };

        [items addObject:item];
        [_items addObject:item];
    }

    // Push items into the features page (if menu already exists)
    MenuViewController *menu = GetSharedMenu();
    if (menu) {
        dispatch_async(dispatch_get_main_queue(), ^{
            menu.featureItems = items;
        });
    }
    // Store for when menu opens later
    // Override OpenMenu to inject items on first present
    // (handled in menuViewControllerDidPresent via the delegate)
}

- (void)syncStates {
    for (NSUInteger i = 0; i < _ptrs.count && i < _items.count; i++) {
        bool *boolPtr = (bool *)[_ptrs[i] pointerValue];
        MenuToggleRow *row = [GetSharedMenu().featuresPage rowAtIndex:i];
        if (row) [row setEnabled:*boolPtr animated:NO];
        _items[i].isEnabled = *boolPtr;
    }
}

// MARK: MenuViewControllerDelegate

- (void)menuViewControllerDidTapClose:(UIViewController *)menuVC {
    CloseMenu();
}

- (void)menuViewControllerDidTapDownload:(UIViewController *)menuVC {
    // optional: save config
}

- (void)menuViewControllerDidTapMoon:(UIViewController *)menuVC {
    // optional: toggle ESP / stream mode
}

@end

// ── C Entry Points ────────────────────────────────────────────────────────────

// Forward-declare the ZX_ variables from ImGuiDrawView.mm.
// Remove `static` from their declarations in ImGuiDrawView.mm, then they link here.
extern bool ZX_AimKill;
extern bool ZX_FlyAlt;
extern bool ZX_Telekill;
extern bool ZX_NoRecoil;
extern bool ZX_NoReload;
extern bool ZX_MarkTeleport;
extern bool ZX_AutoTeleport;
extern bool ZX_GhostVip;
extern bool ZX_NinjaDash;
extern bool ZX_FlyUltira;
extern bool ZX_EnemiesPull;
extern bool ZX_UnderKill;
extern bool ZX_MovePlayer;
extern bool ZX_SpinePlayer;
extern bool ZX_EnemiesAir;
extern bool ZX_FlyMap;
extern bool ZX_FlySky;
extern bool ZX_FastFire;
extern bool ZX_LongRange;
extern bool ZX_BulletThru;
extern bool ZX_ChainDamage;
extern bool ZX_FastSwitch;
extern bool ZX_FreeFly;
extern bool ZX_AmmoSpeedFast;
extern bool ZX_BlueMap;
extern bool ZX_SpeedRun;
extern bool SilentAim;
extern bool CheckWall1;
// Vars struct aimbot fields (from Hooks.h)
// We don't extern Vars directly — use ZX_ bools only for cleanliness

void NativeMenuSetup(void) {
    // ── Feature list: {title, subtitle, warning, &ZX_bool} ─────────────────
    struct BridgeFeature features[] = {
        // AIM
        { "Aim Kill",      "Auto aim + eliminate on target",    "",  &ZX_AimKill      },
        { "Silent Aim",    "Hides aimbot from killcam/replays", "",  &SilentAim       },
        { "Check Wall",    "Aim only through walls visible",    "",  &CheckWall1      },
        // MOVE
        { "Fly Alt",       "Alternative fly mode",              "",  &ZX_FlyAlt       },
        { "Free Fly",      "Fly in any direction via camera",   "",  &ZX_FreeFly      },
        { "Fly Ultira",    "Fly Ultira mode",                   "",  &ZX_FlyUltira    },
        { "Fly Map",       "Fly through the entire map",        "",  &ZX_FlyMap       },
        { "Fly Sky",       "Fly to maximum sky height",         "",  &ZX_FlySky       },
        { "Speed Run",     "Increased movement speed",          "",  &ZX_SpeedRun     },
        // TELEPORT
        { "Telekill",      "Teleport to enemy then kill",       "",  &ZX_Telekill     },
        { "Mark Teleport", "Teleport to saved mark position",   "",  &ZX_MarkTeleport },
        { "Auto Teleport", "Auto-tp to nearest enemy",          "",  &ZX_AutoTeleport },
        { "Enemies Pull",  "Pull all enemies toward you",       "",  &ZX_EnemiesPull  },
        { "Move Player",   "Move enemy player position",        "",  &ZX_MovePlayer   },
        // COMBAT
        { "No Recoil",     "Lock aim — no visible recoil",      "",  &ZX_NoRecoil     },
        { "No Reload",     "Infinite ammo clip",                "",  &ZX_NoReload     },
        { "Fast Fire",     "Maximum fire rate",                 "",  &ZX_FastFire     },
        { "Ammo Fast",     "Max reload speed + full clip",      "",  &ZX_AmmoSpeedFast},
        { "Long Range",    "Extended bullet range",             "",  &ZX_LongRange    },
        { "Bullet Thru",   "Bullets penetrate all surfaces",    "",  &ZX_BulletThru   },
        { "Chain Damage",  "Damage chains to nearby enemies",   "",  &ZX_ChainDamage  },
        { "Fast Switch",   "Instant weapon switch",             "",  &ZX_FastSwitch   },
        // MISC
        { "Ghost VIP",     "Ghost VIP invisible mode",          "",  &ZX_GhostVip     },
        { "Ninja Dash",    "Ninja dash movement boost",         "",  &ZX_NinjaDash    },
        { "Under Kill",    "Kill enemies from below ground",    "",  &ZX_UnderKill    },
        { "Spine Player",  "Spine bone hit precision",          "",  &ZX_SpinePlayer  },
        { "Enemies Air",   "Lift enemies into the air",         "",  &ZX_EnemiesAir   },
        { "Blue Map",      "Tint scene blue (visual mode)",     "",  &ZX_BlueMap      },
    };

    NSUInteger count = sizeof(features) / sizeof(features[0]);

    NSMutableArray<NSValue *>    *ptrs  = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray<NSString *>   *titles = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray<NSString *>   *subs   = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray<NSString *>   *warns  = [NSMutableArray arrayWithCapacity:count];

    for (NSUInteger i = 0; i < count; i++) {
        [ptrs   addObject:[NSValue valueWithPointer:features[i].varPtr]];
        [titles addObject:@(features[i].title)];
        [subs   addObject:@(features[i].subtitle)];
        [warns  addObject:@(features[i].warning)];
    }

    [[_NativeMenuBridgeController shared] setupWithFeatures:ptrs
                                                     titles:titles
                                                  subtitles:subs
                                                   warnings:warns];

    // Override the global menu delegate so close/download/moon work
    dispatch_async(dispatch_get_main_queue(), ^{
        MenuViewController *menu = GetSharedMenu();
        if (menu) menu.delegate = [_NativeMenuBridgeController shared];
    });
}

void NativeMenuSyncStates(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[_NativeMenuBridgeController shared] syncStates];
    });
}
