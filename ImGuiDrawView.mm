//Require standard library
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
#include <iostream>
#include <UIKit/UIKit.h>
#include <vector>
#import <sys/sysctl.h>
#import "pthread.h"
#include <array>
#import <os/log.h>
#include <cmath>
#include <deque>
#include <fstream>
#include <algorithm>
#include <string>
#include <sstream>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include <cstdint>
#include <cinttypes>
#include <cerrno>
#include <cctype>
//Imgui library
#import "Esp/CaptainHook.h"
#import "Esp/ImGuiDrawView.h"
#import "IMGUI/imgui.h"
#import "IMGUI/imgui_internal.h"
#import "IMGUI/imgui_impl_metal.h"
#import "IMGUI/zzz.h"
//#import "Hosts/NSObject+URL.h"
#include "oxorany/oxorany_include.h"
#import "Helper/Mem.h"
#include "font.h"
#import "Helper/Vector3.h"
#import "Helper/Vector2.h"
#import "Helper/Quaternion.h"
#import "Helper/Monostring.h"
#include "Helper/font.h"
#include "Helper/data.h"
ImFont* verdana_smol;
ImFont* pixel_big = {};
ImFont* pixel_smol = {};
#include "Helper/Obfuscate.h"
#import "Helper/Hooks.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <unistd.h>
#include <string.h>
#include "Other/dobby_defines.h"
#import "Other/H5hook.h"
#include "Other/Paste.h"
#import "NativeMenuBridge.h"
#import "menu.h"

#define Hook(x, y, z) \
{ \
    NSString* result_##y = StaticInlineHookPatch(("Frameworks/UnityFramework.framework/UnityFramework"), x, nullptr); \
    if (result_##y) { \
        void* result = StaticInlineHookFunction(("Frameworks/UnityFramework.framework/UnityFramework"), x, (void *) y); \
        *(void **) (&z) = (void*) result; \
    } \
}

static float fixLoginTimeout = 60.0f;
static bool MenDeal = true;

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale  [UIScreen mainScreen].scale

BOOL isJailbroken() {
    NSArray *jailbreakPaths = @[
        @"/Applications/Cydia.app",
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/bin/bash",
        @"/usr/sbin/sshd",
        @"/etc/apt",
        @"/private/var/lib/apt/"
    ];
    for (NSString *path in jailbreakPaths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    NSError *error;
    NSString *testPath = @"/private/jb_test.txt";
    [@"test" writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        [[NSFileManager defaultManager] removeItemAtPath:testPath error:nil];
        return YES;
    }
    return NO;
}

@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@property (nonatomic, assign) CGRect menuBounds;
@property (nonatomic, strong) UIButton *ninjaRunButtonView;
@property (nonatomic, strong) UISwitch *ninjaRunSwitch;
@property (nonatomic, assign) BOOL ninjaRunButtonVisible;
@property (nonatomic, strong) UIView *menu;

@end


@implementation ImGuiDrawView
ImFont *_espFont;
ImFont* verdanab;
ImFont* icons;
ImFont* interb;
ImFont* Urbanist;

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    g_DrawView = self;
    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];
    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    ImGui::StyleColorsDark();

    auto& s = ImGui::GetStyle();
    s.WindowPadding     = ImVec2(0, 0);
    s.ItemSpacing       = ImVec2(0, 0);
    s.WindowRounding    = 8.0f;
    s.ChildRounding     = 0.0f;
    s.FrameRounding     = 4.0f;
    s.ScrollbarRounding = 4.0f;
    s.WindowBorderSize  = 0.0f;

    ImVec4* c = s.Colors;
    c[ImGuiCol_WindowBg]             = ImVec4(0.118f, 0.118f, 0.125f, 1.00f);
    c[ImGuiCol_ChildBg]              = ImVec4(0.000f, 0.000f, 0.000f, 0.00f);
    c[ImGuiCol_Border]               = ImVec4(0.000f, 0.000f, 0.000f, 0.00f);
    c[ImGuiCol_ScrollbarBg]          = ImVec4(0.000f, 0.000f, 0.000f, 0.00f);
    c[ImGuiCol_ScrollbarGrab]        = ImVec4(0.55f, 0.20f, 0.22f, 0.85f);
    c[ImGuiCol_ScrollbarGrabHovered] = ImVec4(0.75f, 0.28f, 0.30f, 1.00f);
    c[ImGuiCol_ScrollbarGrabActive]  = ImVec4(0.45f, 0.16f, 0.18f, 1.00f);

    ImFont* font = io.Fonts->AddFontFromMemoryTTF(sansbold, sizeof(sansbold), 18.0f, NULL, io.Fonts->GetGlyphRangesCyrillic());
    verdana_smol = io.Fonts->AddFontFromMemoryTTF(verdana, sizeof verdana, 40, NULL, io.Fonts->GetGlyphRangesCyrillic());
    pixel_big    = io.Fonts->AddFontFromMemoryTTF((void*)smallestpixel, sizeof smallestpixel, 128, NULL, io.Fonts->GetGlyphRangesCyrillic());
    pixel_smol   = io.Fonts->AddFontFromMemoryTTF((void*)smallestpixel, sizeof smallestpixel, 20,  NULL, io.Fonts->GetGlyphRangesCyrillic());
    ImGui_ImplMetal_Init(_device);
    return self;
}

+ (void)showChange:(BOOL)open { MenDeal = open; }
- (MTKView *)mtkView { return (MTKView *)self.view; }

- (void)loadView {
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.clipsToBounds = YES;
    Hook(0x4EB3E88, BLAGCMCGEJG1, old_BLAGCMCGEJG1);
    // Native menu setup — replaces all floating buttons & IMGUI menu window
    NativeMenuSetup();
}

// ── ZX_ STATE variables ────────────────────────────────────────────────────
// Note: non-static so NativeMenuBridge.mm can link to them via extern
static int   ZX_Tab            = 0;
bool  ZX_FlyAlt         = false;
static float ZX_FlySpeed       = 5.0f;
bool  ZX_FastFire       = false;
bool  ZX_LongRange      = false;
bool  ZX_BulletThru     = false;
bool  ZX_FastSwitch     = false;
bool  ZX_ChainDamage    = false;
static float ZX_ChainDmgValue  = 1000.0f;
bool  ZX_Telekill       = false;
bool  ZX_FreeFly        = false;
static float ZX_FreeFlySpeed   = 8.0f;
bool  ZX_AimKill        = false;
bool  ZX_NoRecoil       = false;
bool  ZX_NoReload       = false;
bool  ZX_AIPlayerAim    = false;
static bool  ZX_FAKE           = false;
static bool  ZX_UNDER          = false;
static bool  ZX_RUN            = false;
static bool  ZX_FLYV2          = false;
static bool  ZX_GHOSTVIP       = false;
static bool  ZX_XMOVE          = false;
bool  ZX_MarkTeleport   = false;
bool  ZX_AutoTeleport   = false;
bool  ZX_AmmoSpeedFast  = false;
bool  ZX_BlueMap        = false;
static bool  ZX_SetMark        = false;
static bool  ZX_ResetAcc       = false;
static bool  ZX_Esp2DCorner    = true;
static bool  ZX_Esp3DBox       = true;
static bool  ZX_CameraLeft     = false;
static float ZX_CameraHeight   = 5.0f;
static float ZX_CameraSide     = 0.0f;
bool  ZX_GhostVip       = false;
bool  ZX_NinjaDash      = false;
bool  ZX_FlyUltira      = false;
bool  ZX_EnemiesPull    = false;
bool  ZX_UnderKill      = false;
bool  ZX_MovePlayer     = false;
bool  ZX_SpinePlayer    = false;
bool  ZX_EnemiesAir     = false;
bool  ZX_FlyMap         = false;
bool  ZX_FlySky         = false;
bool  ZX_SpeedRun       = false;
bool  ZX_SpeedTime      = false;
static bool  ZX_AimRadius180   = false;
static bool  ZX_AimRadius360   = false;
static int   ZX_WhenShootIdx   = 0;
static int   ZX_HitboxIdx      = 0;
bool  SilentAim         = false;
bool  CheckWall1        = false;

static void ZX_ApplyAndRun() {
    Vars.AimbotEnable = Vars.Aimbot;
    Vars.isAimFov = (Vars.AimFov > 0);
    Vars.fovLineColor[0] = 0.90f;
    Vars.fovLineColor[1] = 0.22f;
    Vars.fovLineColor[2] = 0.24f;
    Vars.fovLineColor[3] = 1.00f;
    Vars.FastFire = ZX_FastFire;
    FireDelay = ZX_FastFire ? 0.0f : 0.001f;
    Vars.LongRange = ZX_LongRange;
    Vars.BulletPenetration = ZX_BulletThru;
    Vars.ChainDamage = ZX_ChainDamage;
    Vars.ChainDamageValue = (int)ZX_ChainDmgValue;
    Vars.FastSwitch = ZX_FastSwitch;
    if (ZX_BulletThru) { SilentAim = true; CheckWall1 = false; }
    Vars.FlyUp = ZX_FlyAlt;
    Vars.FlySpeed = ZX_FlySpeed;
    Vars.Telekill = ZX_Telekill;
    Vars.FreeFly = ZX_FreeFly;
    Vars.FreeFlySpeed = ZX_FreeFlySpeed;
    Vars.AimKill = ZX_AimKill;
    Vars.NoRecoil = ZX_NoRecoil;
    Vars.NoReload = ZX_NoReload;
    Vars.AIPlayerAim = ZX_AIPlayerAim;
    Vars.CurrentTab = ZX_Tab;
    Vars.MarkTeleport = ZX_MarkTeleport;
    Vars.AutoTeleport = ZX_AutoTeleport;
    Vars.AmmoSpeedFast = ZX_AmmoSpeedFast;
    Vars.BlueMap = ZX_BlueMap;
    Vars.GhostVip    = ZX_GhostVip;
    Vars.NinjaDash   = ZX_NinjaDash;
    Vars.FlyUltira   = ZX_FlyUltira;
    Vars.EnemiesPull = ZX_EnemiesPull;
    Vars.UnderKill   = ZX_UnderKill;
    Vars.MovePlayer  = ZX_MovePlayer;
    Vars.SpinePlayer = ZX_SpinePlayer;
    Vars.EnemiesAir  = ZX_EnemiesAir;
    Vars.FlyMap      = ZX_FlyMap;
    Vars.FlySky      = ZX_FlySky;
    Vars.SpeedRun    = ZX_SpeedRun;
    Vars.SpeedTime   = ZX_SpeedTime;
    if (ZX_SetMark) { SetMarkAtCurrentPos(); ZX_SetMark = false; }
    if (ZX_ResetAcc) { DoResetAccount(); ZX_ResetAcc = false; }
    if (ZX_BlueMap && Vars.Enable) RunBlueMap();
    if (ZX_AmmoSpeedFast && Vars.Enable) RunAmmoSpeedFast();
    if (ZX_MarkTeleport && Vars.Enable) RunMarkTeleport();
    if (ZX_AutoTeleport && Vars.Enable) RunAutoTeleport();
    if (ZX_FlyAlt && Vars.Enable) {
        void* match = game_sdk->Curent_Match();
        if (match) {
            void* local = game_sdk->GetLocalPlayer(match);
            if (local) {
                void* tf = game_sdk->Component_GetTransform(local);
                if (tf) {
                    Vector3 cur = game_sdk->get_position(tf);
                    cur.y += ZX_FlySpeed * 0.1f;
                    Transform_INTERNAL_SetPosition(tf, Vvector3(cur.x, cur.y, cur.z));
                }
            }
        }
    }
    if ((ZX_AimKill || Vars.AutoFire) && Vars.Enable) {
        Vars.Aimbot = true;
        Vars.AimbotEnable = true;
        Vars.AimMode = 0;
        Vars.isAimFov = true;
        Vars.AimWhen = 0;
        Vars.AimHitbox = 0;
        Vars.AutoFire = true;
        Vars.FastFire = true;
        FireDelay = 0.0f;
        Vars.LongRange = true;
        Vars.BulletPenetration = true;
        Vars.ChainDamage = true;
        Vars.ChainDamageValue = 9999;
        Vars.VisibleCheck = false;
        Vars.IgnoreKnocked = true;
        Vars.UpPlayerOne = true;
        SilentAim = true;
        CheckWall1 = false;
        SetDamage = 1;
        if (Vars.AimFov < 500.0f) Vars.AimFov = 500.0f;
    }
    if (ZX_FreeFly && Vars.Enable) {
        void* match = game_sdk->Curent_Match();
        if (match) {
            void* local = game_sdk->GetLocalPlayer(match);
            void* cam = game_sdk->get_camera();
            if (local && cam) {
                void* tf = game_sdk->Component_GetTransform(local);
                void* camTF = game_sdk->Component_GetTransform(cam);
                if (tf && camTF) {
                    Vector3 cur = game_sdk->get_position(tf);
                    Vector3 fwd = game_sdk->GetForward(camTF);
                    float step = ZX_FreeFlySpeed * 0.1f;
                    cur.x += fwd.x * step;
                    cur.y += fwd.y * step;
                    cur.z += fwd.z * step;
                    Transform_INTERNAL_SetPosition(tf, Vvector3(cur.x, cur.y, cur.z));
                }
            }
        }
    }
    if (ZX_NoRecoil && Vars.Enable) {
        Vars.Aimbot = true;
        Vars.AimSpeed = (Vars.AimSpeed > 30.0f) ? Vars.AimSpeed : 50.0f;
        Vars.isAimFov = true;
        if (Vars.AimFov < 200.0f) Vars.AimFov = 200.0f;
    }
    if (ZX_NoReload && Vars.Enable) {
        Vars.FastFire = true;
        FireDelay = 0.0f;
    }
    if (ZX_AIPlayerAim && Vars.Enable) {
        Vars.Aimbot = true;
        Vars.AimMode = 0;
        Vars.isAimFov = true;
        Vars.AimSpeed = (Vars.AimSpeed > 20.0f) ? Vars.AimSpeed : 35.0f;
        Vars.AimManagerHitbox = 0;
        Vars.VisibleCheck = false;
        if (Vars.AimFov < 400.0f) Vars.AimFov = 400.0f;
        SilentAim = true;
    }
    if (ZX_Telekill && Vars.Enable) {
        void* match = game_sdk->Curent_Match();
        if (match) {
            void* local = game_sdk->GetLocalPlayer(match);
            void* enemy = GetClosestEnemy();
            if (local && enemy) {
                void* tf = game_sdk->Component_GetTransform(local);
                if (tf) {
                    Vector3 ePos = GetHeadPosition(enemy);
                    Transform_INTERNAL_SetPosition(tf, Vvector3(ePos.x + 1.5f, ePos.y - 1.0f, ePos.z + 1.5f));
                    SilentAim = true;
                    Vars.ChainDamage = true;
                }
            }
        }
    }
    // ✅ Camera Left – มุมสูงปรับได้ + ซ้าย/ขวา
    if (ZX_CameraLeft && Vars.Enable) {
        void* match = game_sdk->Curent_Match();
        if (match) {
            void* local = game_sdk->GetLocalPlayer(match);
            void* cam   = game_sdk->get_camera();
            if (local && cam) {
                void* pTF = game_sdk->Component_GetTransform(local);
                void* cTF = game_sdk->Component_GetTransform(cam);
                if (pTF && cTF) {
                    Vector3 p = game_sdk->get_position(pTF);
                    Transform_INTERNAL_SetPosition(cTF,
                        Vvector3(p.x + ZX_CameraSide, p.y + ZX_CameraHeight, p.z));
                }
            }
        }
    }
    // ══════════════════════════════════════════════════════════════
    // NEW FLOATING BUTTON FEATURES — เรียกทุกเฟรม
    // ══════════════════════════════════════════════════════════════
    RunFlyUltira();
    RunFlyMap();
    RunFlySky();
    RunSpinePlayer();
    RunGhostVip();
    RunNinjaDash();
    RunEnemiesPull();
    RunUnderKill();
    RunMovePlayer();
    RunEnemiesAir();
    RunSpeedRun();
    RunSpeedTime();
}

- (void)drawInMTKView:(MTKView*)view {
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;
    CGFloat fbScale = view.window.screen.nativeScale ?: UIScreen.mainScreen.nativeScale;
    io.DisplayFramebufferScale = ImVec2(fbScale, fbScale);
    io.DeltaTime = 1.0f / float(view.preferredFramesPerSecond ?: 60);
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    // IMGUI view is transparent overlay for ESP — user interaction disabled
    [self.view setUserInteractionEnabled:NO];
    MTLRenderPassDescriptor* rpd = view.currentRenderPassDescriptor;
    if (rpd) {
        id<MTLRenderCommandEncoder> enc = [commandBuffer renderCommandEncoderWithDescriptor:rpd];
        [enc pushDebugGroup:@"ImGui"];
        ImGui_ImplMetal_NewFrame(rpd);
        ImGui::NewFrame();
        ZX_ApplyAndRun();   // sync ZX_ → Vars every frame
        ImDrawList* draw_list = ImGui::GetBackgroundDrawList();
        get_players();
        draw_watermark();
        aimbot();
        game_sdk->init();
        Vars.isAimFov = (Vars.AimFov > 0);
        ImGui::Render();
        ImGui_ImplMetal_RenderDrawData(ImGui::GetDrawData(), commandBuffer, enc);
        [enc popDebugGroup];
        [enc endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    [commandBuffer commit];
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size {}

@end
