#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - Color Constants
extern UIColor *MenuColorBackground(void);
extern UIColor *MenuColorSidebar(void);
extern UIColor *MenuColorButtonNormal(void);
extern UIColor *MenuColorButtonActive(void);
extern UIColor *MenuColorAccentCyan(void);
extern UIColor *MenuColorAccentGreen(void);
extern UIColor *MenuColorAccentOrange(void);
extern UIColor *MenuColorTextPrimary(void);
extern UIColor *MenuColorTextSecondary(void);
extern UIColor *MenuColorBorder(void);
extern UIColor *MenuColorRowBackground(void);

// MARK: - MenuSidebarButton
@interface MenuSidebarButton : UIButton
@property (nonatomic, assign, getter=isActiveState) BOOL activeState;
- (instancetype)initWithSystemImageName:(NSString *)imageName;
- (void)setActiveState:(BOOL)active animated:(BOOL)animated;
@end

// MARK: - MenuTabButton
typedef NS_ENUM(NSInteger, MenuTabType) {
    MenuTabTypeProfile = 0,
    MenuTabTypeDownload,
    MenuTabTypeMoon,
    MenuTabTypeClose
};

@interface MenuTabButton : UIButton
@property (nonatomic, assign) MenuTabType tabType;
@property (nonatomic, assign, getter=isActiveTab) BOOL activeTab;
- (instancetype)initWithTabType:(MenuTabType)type;
- (void)setActiveTab:(BOOL)active animated:(BOOL)animated;
@end

// MARK: - MenuTabTitleButton (for dynamic tab titles like "AIMBOT", "PROFILE")
@interface MenuTabTitleButton : UIButton
@property (nonatomic, assign, getter=isActiveTab) BOOL activeTab;
- (instancetype)initWithTitle:(NSString *)title sfImageName:(NSString *)sfName;
- (void)setTitle:(NSString *)title sfImageName:(NSString *)sfName;
- (void)setActiveTab:(BOOL)active animated:(BOOL)animated;
@end

// MARK: - MenuInfoRow
@interface MenuInfoRow : UIView
@property (nonatomic, strong, readonly) UILabel *keyLabel;
@property (nonatomic, strong, readonly) UILabel *valueLabel;
- (instancetype)initWithKey:(NSString *)key value:(NSString *)value valueColor:(UIColor *)color;
- (void)updateValue:(NSString *)value;
@end

// MARK: - MenuToggleItem (data model)
@interface MenuToggleItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong, nullable) NSString *subtitle;
@property (nonatomic, strong, nullable) NSString *warningText;
@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, copy, nullable) void (^onChange)(BOOL enabled);
- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithTitle:(NSString *)title subtitle:(nullable NSString *)subtitle;
- (instancetype)initWithTitle:(NSString *)title subtitle:(nullable NSString *)subtitle warning:(nullable NSString *)warning;
@end

// MARK: - MenuToggleRow
@interface MenuToggleRow : UIView
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, strong, readonly) UILabel *warningLabel;
@property (nonatomic, strong, readonly) UISwitch *toggleSwitch;
@property (nonatomic, copy, nullable) void (^onChange)(BOOL enabled);
- (instancetype)initWithItem:(MenuToggleItem *)item;
- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated;
- (BOOL)isEnabled;
@end

// MARK: - MenuFeaturesPage
@interface MenuFeaturesPage : UIView
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) NSArray<MenuToggleRow *> *toggleRows;
- (void)setItems:(NSArray<MenuToggleItem *> *)items;
- (void)addItem:(MenuToggleItem *)item;
- (nullable MenuToggleRow *)rowAtIndex:(NSUInteger)index;
- (NSDictionary<NSString *, NSNumber *> *)allStates;
@end

// MARK: - MenuPage enum
typedef NS_ENUM(NSInteger, MenuPage) {
    MenuPageProfile  = 0,
    MenuPageFeatures = 1,
};

// MARK: - MenuViewController delegate
@protocol MenuViewControllerDelegate <NSObject>
@optional
- (void)menuViewControllerDidTapClose:(UIViewController *)menuVC;
- (void)menuViewControllerDidTapDownload:(UIViewController *)menuVC;
- (void)menuViewControllerDidTapMoon:(UIViewController *)menuVC;
- (void)menuViewControllerDidSelectSidebarIndex:(NSInteger)index;
- (void)menuViewController:(UIViewController *)menuVC didChangePage:(MenuPage)page;
- (void)menuViewController:(UIViewController *)menuVC didToggleItem:(MenuToggleItem *)item enabled:(BOOL)enabled;
@end

// MARK: - MenuViewController
@interface MenuViewController : UIViewController

@property (nonatomic, assign, nullable) id<MenuViewControllerDelegate> delegate;

// Info display properties
@property (nonatomic, assign) NSInteger fps;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *iosVersion;
@property (nonatomic, strong) NSString *profileName;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong, nullable) NSString *licenseKey;

// Current page
@property (nonatomic, assign) MenuPage currentPage;

// Feature items (set before presenting or anytime)
@property (nonatomic, strong) NSArray<MenuToggleItem *> *featureItems;

// UI Components
@property (nonatomic, strong, readonly) UIView *containerView;
@property (nonatomic, strong, readonly) UIView *sidebarView;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIStackView *sidebarStack;
@property (nonatomic, strong, readonly) NSArray<MenuSidebarButton *> *sidebarButtons;
@property (nonatomic, strong, readonly) MenuTabTitleButton *mainTabButton;
@property (nonatomic, strong, readonly) MenuTabButton *downloadTabButton;
@property (nonatomic, strong, readonly) MenuTabButton *moonTabButton;
@property (nonatomic, strong, readonly) MenuTabButton *closeTabButton;

// Pages
@property (nonatomic, strong, readonly) UIView *profilePage;
@property (nonatomic, strong, readonly) MenuFeaturesPage *featuresPage;

// Info rows
@property (nonatomic, strong, readonly) MenuInfoRow *fpsRow;
@property (nonatomic, strong, readonly) MenuInfoRow *timeRow;
@property (nonatomic, strong, readonly) MenuInfoRow *deviceRow;
@property (nonatomic, strong, readonly) MenuInfoRow *iosRow;
@property (nonatomic, strong, readonly) MenuInfoRow *nameRow;
@property (nonatomic, strong, readonly) MenuInfoRow *versionRow;
@property (nonatomic, strong, readonly) MenuInfoRow *licenseRow;

// Selected sidebar index
@property (nonatomic, assign) NSInteger selectedSidebarIndex;

// Clock
- (void)startClock;
- (void)stopClock;

// Page switching
- (void)showPage:(MenuPage)page animated:(BOOL)animated;

// Presentation helpers
+ (instancetype)presentFromViewController:(UIViewController *)parent
                                 delegate:(nullable id<MenuViewControllerDelegate>)delegate;
- (void)dismissAnimated:(BOOL)animated;

@end

// MARK: - Tweak Entry Points
#ifdef __cplusplus
extern "C" {
#endif

void OpenMenu(void);
void CloseMenu(void);
BOOL IsMenuVisible(void);
MenuViewController *GetSharedMenu(void);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
