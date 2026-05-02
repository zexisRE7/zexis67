#import "menu.h"

// MARK: - SF Symbol Helper (iOS 13+ safe)

static UIImage *MenuSFImage(NSString *name, CGFloat size) {
    if (@available(iOS 13.0, *)) {
        UIImageSymbolConfiguration *cfg = [UIImageSymbolConfiguration
            configurationWithPointSize:size weight:UIImageSymbolWeightMedium];
        return [UIImage systemImageNamed:name withConfiguration:cfg];
    }
    return nil;
}

// MARK: - Color Constants

UIColor *MenuColorBackground(void)   { return [UIColor colorWithRed:0.071 green:0.122 blue:0.196 alpha:1.0]; }
UIColor *MenuColorSidebar(void)      { return [UIColor colorWithRed:0.047 green:0.090 blue:0.153 alpha:1.0]; }
UIColor *MenuColorButtonNormal(void) { return [UIColor colorWithRed:0.102 green:0.165 blue:0.259 alpha:1.0]; }
UIColor *MenuColorButtonActive(void) { return [UIColor colorWithRed:0.106 green:0.231 blue:0.392 alpha:1.0]; }
UIColor *MenuColorAccentCyan(void)   { return [UIColor colorWithRed:0.251 green:0.698 blue:0.929 alpha:1.0]; }
UIColor *MenuColorAccentGreen(void)  { return [UIColor colorWithRed:0.255 green:0.835 blue:0.396 alpha:1.0]; }
UIColor *MenuColorAccentOrange(void) { return [UIColor colorWithRed:0.980 green:0.600 blue:0.200 alpha:1.0]; }
UIColor *MenuColorTextPrimary(void)  { return [UIColor colorWithRed:0.871 green:0.906 blue:0.949 alpha:1.0]; }
UIColor *MenuColorTextSecondary(void){ return [UIColor colorWithRed:0.576 green:0.659 blue:0.761 alpha:1.0]; }
UIColor *MenuColorBorder(void)       { return [UIColor colorWithRed:0.180 green:0.282 blue:0.420 alpha:1.0]; }
UIColor *MenuColorRowBackground(void){ return [UIColor colorWithRed:0.086 green:0.149 blue:0.239 alpha:1.0]; }

// MARK: - MenuSidebarButton

@implementation MenuSidebarButton {
    UIImageView *_iconImageView;
}

- (instancetype)initWithSystemImageName:(NSString *)imageName {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = MenuColorButtonNormal();
        self.layer.cornerRadius = 22.0;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = MenuColorBorder().CGColor;

        UIImage *icon = MenuSFImage(imageName, 20.0);
        _iconImageView = [[UIImageView alloc] initWithImage:icon];
        _iconImageView.tintColor = [UIColor colorWithRed:0.502 green:0.659 blue:0.851 alpha:1.0];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _iconImageView.userInteractionEnabled = NO;
        [self addSubview:_iconImageView];

        [NSLayoutConstraint activateConstraints:@[
            [_iconImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [_iconImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [_iconImageView.widthAnchor constraintEqualToConstant:22.0],
            [_iconImageView.heightAnchor constraintEqualToConstant:22.0],
            [self.widthAnchor constraintEqualToConstant:44.0],
            [self.heightAnchor constraintEqualToConstant:44.0],
        ]];
    }
    return self;
}

- (void)setActiveState:(BOOL)active { [self setActiveState:active animated:NO]; }

- (void)setActiveState:(BOOL)active animated:(BOOL)animated {
    _activeState = active;
    void (^upd)(void) = ^{
        self.backgroundColor = active ? MenuColorButtonActive() : MenuColorButtonNormal();
        self->_iconImageView.tintColor = active
            ? MenuColorAccentCyan()
            : [UIColor colorWithRed:0.502 green:0.659 blue:0.851 alpha:1.0];
        self.layer.borderColor = active ? MenuColorAccentCyan().CGColor : MenuColorBorder().CGColor;
    };
    animated ? [UIView animateWithDuration:0.18 animations:upd] : upd();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.10 animations:^{ self.transform = CGAffineTransformMakeScale(0.92, 0.92); self.alpha = 0.85; }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{ self.transform = CGAffineTransformIdentity; self.alpha = 1.0; } completion:nil];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [UIView animateWithDuration:0.15 animations:^{ self.transform = CGAffineTransformIdentity; self.alpha = 1.0; }];
}
@end

// MARK: - MenuTabButton

@implementation MenuTabButton {
    UIImageView *_iconView;
}

- (instancetype)initWithTabType:(MenuTabType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _tabType = type;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.2;
        self.layer.cornerRadius = 18.0;
        self.backgroundColor = MenuColorButtonNormal();
        self.layer.borderColor = MenuColorBorder().CGColor;

        NSString *sysName;
        if (type == MenuTabTypeDownload) sysName = @"square.and.arrow.down";
        else if (type == MenuTabTypeMoon) sysName = @"moon.fill";
        else sysName = @"xmark";

        UIImage *icon = MenuSFImage(sysName, 17.0);
        _iconView = [[UIImageView alloc] initWithImage:icon];
        _iconView.tintColor = MenuColorTextPrimary();
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.translatesAutoresizingMaskIntoConstraints = NO;
        _iconView.userInteractionEnabled = NO;
        [self addSubview:_iconView];

        [NSLayoutConstraint activateConstraints:@[
            [_iconView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [_iconView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [_iconView.widthAnchor constraintEqualToConstant:18.0],
            [_iconView.heightAnchor constraintEqualToConstant:18.0],
            [self.widthAnchor constraintEqualToConstant:36.0],
            [self.heightAnchor constraintEqualToConstant:36.0],
        ]];
    }
    return self;
}

- (void)setActiveTab:(BOOL)active { [self setActiveTab:active animated:NO]; }
- (void)setActiveTab:(BOOL)active animated:(BOOL)animated {
    _activeTab = active;
    void (^upd)(void) = ^{ self.backgroundColor = active ? MenuColorButtonActive() : MenuColorButtonNormal(); };
    animated ? [UIView animateWithDuration:0.18 animations:upd] : upd();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.10 animations:^{ self.transform = CGAffineTransformMakeScale(0.93, 0.93); self.alpha = 0.80; }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{ self.transform = CGAffineTransformIdentity; self.alpha = 1.0; } completion:nil];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [UIView animateWithDuration:0.15 animations:^{ self.transform = CGAffineTransformIdentity; self.alpha = 1.0; }];
}
@end

// MARK: - MenuTabTitleButton

@implementation MenuTabTitleButton {
    UIImageView *_iconView;
    UILabel     *_titleLabel;
    UIStackView *_stack;
}

- (instancetype)initWithTitle:(NSString *)title sfImageName:(NSString *)sfName {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.layer.cornerRadius = 16.0;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.2;
        self.backgroundColor = MenuColorButtonActive();
        self.layer.borderColor = MenuColorAccentCyan().CGColor;

        UIImage *icon = MenuSFImage(sfName, 15.0);
        _iconView = [[UIImageView alloc] initWithImage:icon];
        _iconView.tintColor = MenuColorAccentCyan();
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.translatesAutoresizingMaskIntoConstraints = NO;

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.font = [UIFont systemFontOfSize:12.5 weight:UIFontWeightBold];
        _titleLabel.textColor = MenuColorAccentCyan();
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

        _stack = [[UIStackView alloc] initWithArrangedSubviews:@[_iconView, _titleLabel]];
        _stack.axis = UILayoutConstraintAxisHorizontal;
        _stack.spacing = 5.0;
        _stack.alignment = UIStackViewAlignmentCenter;
        _stack.translatesAutoresizingMaskIntoConstraints = NO;
        _stack.userInteractionEnabled = NO;
        [self addSubview:_stack];

        [NSLayoutConstraint activateConstraints:@[
            [_stack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10.0],
            [_stack.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10.0],
            [_stack.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [_iconView.widthAnchor constraintEqualToConstant:16.0],
            [_iconView.heightAnchor constraintEqualToConstant:16.0],
            [self.heightAnchor constraintEqualToConstant:36.0],
            [self.widthAnchor constraintGreaterThanOrEqualToConstant:90.0],
        ]];
    }
    return self;
}

- (void)setTitle:(NSString *)title sfImageName:(NSString *)sfName {
    _titleLabel.text = title;
    _iconView.image = MenuSFImage(sfName, 15.0);
}

- (void)setActiveTab:(BOOL)active { [self setActiveTab:active animated:NO]; }
- (void)setActiveTab:(BOOL)active animated:(BOOL)animated {
    _activeTab = active;
    void (^upd)(void) = ^{
        self.backgroundColor = active ? MenuColorButtonActive() : MenuColorButtonNormal();
        self->_iconView.tintColor = active ? MenuColorAccentCyan() : MenuColorTextSecondary();
        self->_titleLabel.textColor = active ? MenuColorAccentCyan() : MenuColorTextSecondary();
        self.layer.borderColor = active ? MenuColorAccentCyan().CGColor : MenuColorBorder().CGColor;
    };
    animated ? [UIView animateWithDuration:0.18 animations:upd] : upd();
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [UIView animateWithDuration:0.10 animations:^{ self.transform = CGAffineTransformMakeScale(0.93, 0.93); self.alpha = 0.80; }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [UIView animateWithDuration:0.15 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{ self.transform = CGAffineTransformIdentity; self.alpha = 1.0; } completion:nil];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [UIView animateWithDuration:0.15 animations:^{ self.transform = CGAffineTransformIdentity; self.alpha = 1.0; }];
}
@end

// MARK: - MenuInfoRow

@implementation MenuInfoRow

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value valueColor:(UIColor *)color {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _keyLabel = [[UILabel alloc] init];
        _keyLabel.text = key;
        _keyLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular];
        _keyLabel.textColor = MenuColorTextSecondary();
        _keyLabel.translatesAutoresizingMaskIntoConstraints = NO;

        _valueLabel = [[UILabel alloc] init];
        _valueLabel.text = value;
        _valueLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
        _valueLabel.textColor = color;
        _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_keyLabel];
        [self addSubview:_valueLabel];

        [NSLayoutConstraint activateConstraints:@[
            [_keyLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_keyLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [_keyLabel.widthAnchor constraintEqualToConstant:88.0],
            [_valueLabel.leadingAnchor constraintEqualToAnchor:_keyLabel.trailingAnchor constant:8.0],
            [_valueLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [_valueLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor],
            [self.heightAnchor constraintEqualToConstant:38.0],
        ]];
    }
    return self;
}

- (void)updateValue:(NSString *)value { _valueLabel.text = value; }
@end

// MARK: - MenuToggleItem

@implementation MenuToggleItem

- (instancetype)initWithTitle:(NSString *)title {
    return [self initWithTitle:title subtitle:nil warning:nil];
}
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    return [self initWithTitle:title subtitle:subtitle warning:nil];
}
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle warning:(NSString *)warning {
    self = [super init];
    if (self) {
        _title = title;
        _subtitle = subtitle;
        _warningText = warning;
        _isEnabled = NO;
    }
    return self;
}
@end

// MARK: - MenuToggleRow

@implementation MenuToggleRow {
    MenuToggleItem *_item;
}

- (instancetype)initWithItem:(MenuToggleItem *)item {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _item = item;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = MenuColorRowBackground();
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = MenuColorBorder().CGColor;

        // Title
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = item.title;
        _titleLabel.font = [UIFont systemFontOfSize:14.5 weight:UIFontWeightSemibold];
        _titleLabel.textColor = MenuColorTextPrimary();
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

        // Subtitle
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.text = item.subtitle;
        _subtitleLabel.font = [UIFont systemFontOfSize:11.5 weight:UIFontWeightRegular];
        _subtitleLabel.textColor = MenuColorTextSecondary();
        _subtitleLabel.numberOfLines = 2;
        _subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _subtitleLabel.hidden = (item.subtitle.length == 0);

        // Warning
        _warningLabel = [[UILabel alloc] init];
        _warningLabel.text = item.warningText;
        _warningLabel.font = [UIFont systemFontOfSize:11.0 weight:UIFontWeightMedium];
        _warningLabel.textColor = MenuColorAccentOrange();
        _warningLabel.numberOfLines = 2;
        _warningLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _warningLabel.hidden = (item.warningText.length == 0);

        // Switch
        _toggleSwitch = [[UISwitch alloc] init];
        _toggleSwitch.on = item.isEnabled;
        _toggleSwitch.onTintColor = MenuColorAccentCyan();
        _toggleSwitch.transform = CGAffineTransformMakeScale(0.80, 0.80);
        _toggleSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [_toggleSwitch addTarget:self action:@selector(_switchChanged:) forControlEvents:UIControlEventValueChanged];

        // Text stack
        NSMutableArray *textViews = [NSMutableArray arrayWithObject:_titleLabel];
        if (!_subtitleLabel.hidden) [textViews addObject:_subtitleLabel];
        if (!_warningLabel.hidden)  [textViews addObject:_warningLabel];

        UIStackView *textStack = [[UIStackView alloc] initWithArrangedSubviews:textViews];
        textStack.axis = UILayoutConstraintAxisVertical;
        textStack.spacing = 2.0;
        textStack.alignment = UIStackViewAlignmentLeading;
        textStack.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:textStack];
        [self addSubview:_toggleSwitch];

        CGFloat minH = (!_subtitleLabel.hidden || !_warningLabel.hidden) ? 58.0 : 46.0;
        [NSLayoutConstraint activateConstraints:@[
            [textStack.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:12.0],
            [textStack.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [textStack.trailingAnchor constraintEqualToAnchor:_toggleSwitch.leadingAnchor constant:-8.0],
            [_toggleSwitch.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10.0],
            [_toggleSwitch.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
            [self.heightAnchor constraintGreaterThanOrEqualToConstant:minH],
        ]];
    }
    return self;
}

- (void)_switchChanged:(UISwitch *)sw {
    _item.isEnabled = sw.on;
    if (_onChange) _onChange(sw.on);
    if (_item.onChange) _item.onChange(sw.on);
    [UIView animateWithDuration:0.12 animations:^{
        self.backgroundColor = sw.on
            ? [UIColor colorWithRed:0.106 green:0.231 blue:0.392 alpha:0.6]
            : MenuColorRowBackground();
        self.layer.borderColor = sw.on ? MenuColorAccentCyan().CGColor : MenuColorBorder().CGColor;
    }];
}

- (void)setEnabled:(BOOL)enabled animated:(BOOL)animated {
    [_toggleSwitch setOn:enabled animated:animated];
    _item.isEnabled = enabled;
    self.backgroundColor = enabled
        ? [UIColor colorWithRed:0.106 green:0.231 blue:0.392 alpha:0.6]
        : MenuColorRowBackground();
    self.layer.borderColor = enabled ? MenuColorAccentCyan().CGColor : MenuColorBorder().CGColor;
}

- (BOOL)isEnabled { return _toggleSwitch.isOn; }
@end

// MARK: - MenuFeaturesPage

@implementation MenuFeaturesPage {
    UIStackView *_stack;
    NSMutableArray<MenuToggleRow *> *_rows;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _rows = [NSMutableArray array];
        self.translatesAutoresizingMaskIntoConstraints = NO;

        _scrollView = [[UIScrollView alloc] init];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = YES;
        [self addSubview:_scrollView];

        _stack = [[UIStackView alloc] init];
        _stack.axis = UILayoutConstraintAxisVertical;
        _stack.spacing = 6.0;
        _stack.translatesAutoresizingMaskIntoConstraints = NO;
        [_scrollView addSubview:_stack];

        [NSLayoutConstraint activateConstraints:@[
            [_scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
            [_scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [_scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [_scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

            [_stack.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor constant:12.0],
            [_stack.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor constant:-12.0],
            [_stack.topAnchor constraintEqualToAnchor:_scrollView.topAnchor constant:8.0],
            [_stack.bottomAnchor constraintEqualToAnchor:_scrollView.bottomAnchor constant:-8.0],
            [_stack.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor constant:-24.0],
        ]];
    }
    return self;
}

- (void)setItems:(NSArray<MenuToggleItem *> *)items {
    for (UIView *v in _stack.arrangedSubviews) [_stack removeArrangedSubview:v];
    [_rows removeAllObjects];
    for (MenuToggleItem *item in items) [self addItem:item];
}

- (void)addItem:(MenuToggleItem *)item {
    MenuToggleRow *row = [[MenuToggleRow alloc] initWithItem:item];
    [_rows addObject:row];
    [_stack addArrangedSubview:row];
}

- (MenuToggleRow *)rowAtIndex:(NSUInteger)index {
    return index < _rows.count ? _rows[index] : nil;
}

- (NSArray<MenuToggleRow *> *)toggleRows { return [_rows copy]; }

- (NSDictionary<NSString *, NSNumber *> *)allStates {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (MenuToggleRow *row in _rows) {
        dict[row.titleLabel.text] = @(row.isEnabled);
    }
    return [dict copy];
}
@end

// MARK: - MenuViewController Private Interface

@interface MenuViewController ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *sidebarView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIStackView *sidebarStack;
@property (nonatomic, strong) NSArray<MenuSidebarButton *> *sidebarButtons;
@property (nonatomic, strong) MenuTabTitleButton *mainTabButton;
@property (nonatomic, strong) MenuTabButton *downloadTabButton;
@property (nonatomic, strong) MenuTabButton *moonTabButton;
@property (nonatomic, strong) MenuTabButton *closeTabButton;
@property (nonatomic, strong) UIView *profilePage;
@property (nonatomic, strong) MenuFeaturesPage *featuresPage;
@property (nonatomic, strong) MenuInfoRow *fpsRow;
@property (nonatomic, strong) MenuInfoRow *timeRow;
@property (nonatomic, strong) MenuInfoRow *deviceRow;
@property (nonatomic, strong) MenuInfoRow *iosRow;
@property (nonatomic, strong) MenuInfoRow *nameRow;
@property (nonatomic, strong) MenuInfoRow *versionRow;
@property (nonatomic, strong) MenuInfoRow *licenseRow;
@property (nonatomic, strong) NSTimer *clockTimer;
@property (nonatomic, strong) UIButton *licenseClipboardButton;
@property (nonatomic, strong) UIView *topDivider;
@end

// MARK: - MenuViewController

// Page title/icon mapping
static NSString *_pageTitles[] = { @"PROFILE", @"AIMBOT", @"COMBAT", @"MOVE", @"MORE" };
static NSString *_pageIcons[]  = { @"person.fill", @"scope", @"bolt.fill", @"figure.walk", @"ellipsis" };
static NSString *_sidebarIcons[] = {
    @"person.fill",
    @"scope",
    @"bolt.fill",
    @"figure.walk",
    @"ellipsis"
};

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self _buildLayout];
    [self _applyDefaultValues];
    [self _attachActions];
    self.selectedSidebarIndex = 0;
    [self showPage:MenuPageProfile animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopClock];
}

// MARK: Layout

- (void)_buildLayout {
    // Container
    _containerView = [[UIView alloc] init];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
    _containerView.backgroundColor = MenuColorBackground();
    _containerView.layer.cornerRadius = 20.0;
    _containerView.layer.masksToBounds = YES;
    _containerView.layer.borderWidth = 1.0;
    _containerView.layer.borderColor = MenuColorBorder().CGColor;
    [self.view addSubview:_containerView];

    [NSLayoutConstraint activateConstraints:@[
        [_containerView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [_containerView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [_containerView.widthAnchor constraintEqualToConstant:370.0],
        [_containerView.heightAnchor constraintEqualToConstant:360.0],
    ]];

    // Sidebar
    _sidebarView = [[UIView alloc] init];
    _sidebarView.translatesAutoresizingMaskIntoConstraints = NO;
    _sidebarView.backgroundColor = MenuColorSidebar();
    [_containerView addSubview:_sidebarView];

    [NSLayoutConstraint activateConstraints:@[
        [_sidebarView.leadingAnchor constraintEqualToAnchor:_containerView.leadingAnchor],
        [_sidebarView.topAnchor constraintEqualToAnchor:_containerView.topAnchor],
        [_sidebarView.bottomAnchor constraintEqualToAnchor:_containerView.bottomAnchor],
        [_sidebarView.widthAnchor constraintEqualToConstant:66.0],
    ]];

    UIView *sideDiv = [[UIView alloc] init];
    sideDiv.translatesAutoresizingMaskIntoConstraints = NO;
    sideDiv.backgroundColor = MenuColorBorder();
    [_containerView addSubview:sideDiv];
    [NSLayoutConstraint activateConstraints:@[
        [sideDiv.leadingAnchor constraintEqualToAnchor:_sidebarView.trailingAnchor],
        [sideDiv.topAnchor constraintEqualToAnchor:_containerView.topAnchor],
        [sideDiv.bottomAnchor constraintEqualToAnchor:_containerView.bottomAnchor],
        [sideDiv.widthAnchor constraintEqualToConstant:1.0],
    ]];

    // Sidebar buttons (5 icons)
    NSMutableArray *btns = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        MenuSidebarButton *b = [[MenuSidebarButton alloc] initWithSystemImageName:_sidebarIcons[i]];
        [btns addObject:b];
    }
    _sidebarButtons = [btns copy];

    _sidebarStack = [[UIStackView alloc] initWithArrangedSubviews:_sidebarButtons];
    _sidebarStack.axis = UILayoutConstraintAxisVertical;
    _sidebarStack.spacing = 10.0;
    _sidebarStack.alignment = UIStackViewAlignmentCenter;
    _sidebarStack.translatesAutoresizingMaskIntoConstraints = NO;
    [_sidebarView addSubview:_sidebarStack];

    [NSLayoutConstraint activateConstraints:@[
        [_sidebarStack.centerXAnchor constraintEqualToAnchor:_sidebarView.centerXAnchor],
        [_sidebarStack.centerYAnchor constraintEqualToAnchor:_sidebarView.centerYAnchor],
    ]];

    // Content
    _contentView = [[UIView alloc] init];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.clipsToBounds = YES;
    [_containerView addSubview:_contentView];

    [NSLayoutConstraint activateConstraints:@[
        [_contentView.leadingAnchor constraintEqualToAnchor:sideDiv.trailingAnchor],
        [_contentView.trailingAnchor constraintEqualToAnchor:_containerView.trailingAnchor],
        [_contentView.topAnchor constraintEqualToAnchor:_containerView.topAnchor],
        [_contentView.bottomAnchor constraintEqualToAnchor:_containerView.bottomAnchor],
    ]];

    // Top bar
    UIView *topBar = [[UIView alloc] init];
    topBar.translatesAutoresizingMaskIntoConstraints = NO;
    topBar.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:topBar];

    _mainTabButton  = [[MenuTabTitleButton alloc] initWithTitle:_pageTitles[0] sfImageName:_pageIcons[0]];
    _downloadTabButton = [[MenuTabButton alloc] initWithTabType:MenuTabTypeDownload];
    _moonTabButton     = [[MenuTabButton alloc] initWithTabType:MenuTabTypeMoon];
    _closeTabButton    = [[MenuTabButton alloc] initWithTabType:MenuTabTypeClose];

    UIStackView *topStack = [[UIStackView alloc] initWithArrangedSubviews:@[
        _mainTabButton, _downloadTabButton, _moonTabButton, _closeTabButton
    ]];
    topStack.axis = UILayoutConstraintAxisHorizontal;
    topStack.spacing = 8.0;
    topStack.alignment = UIStackViewAlignmentCenter;
    topStack.translatesAutoresizingMaskIntoConstraints = NO;
    [topBar addSubview:topStack];

    [NSLayoutConstraint activateConstraints:@[
        [topBar.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor],
        [topBar.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor],
        [topBar.topAnchor constraintEqualToAnchor:_contentView.topAnchor],
        [topBar.heightAnchor constraintEqualToConstant:58.0],
        [topStack.leadingAnchor constraintEqualToAnchor:topBar.leadingAnchor constant:12.0],
        [topStack.centerYAnchor constraintEqualToAnchor:topBar.centerYAnchor],
    ]];

    _topDivider = [[UIView alloc] init];
    _topDivider.translatesAutoresizingMaskIntoConstraints = NO;
    _topDivider.backgroundColor = MenuColorBorder();
    [_contentView addSubview:_topDivider];
    [NSLayoutConstraint activateConstraints:@[
        [_topDivider.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor],
        [_topDivider.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor],
        [_topDivider.topAnchor constraintEqualToAnchor:topBar.bottomAnchor],
        [_topDivider.heightAnchor constraintEqualToConstant:1.0],
    ]];

    // Profile page
    [self _buildProfilePage];

    // Features page
    _featuresPage = [[MenuFeaturesPage alloc] initWithFrame:CGRectZero];
    _featuresPage.hidden = YES;
    [_contentView addSubview:_featuresPage];
    [NSLayoutConstraint activateConstraints:@[
        [_featuresPage.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor],
        [_featuresPage.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor],
        [_featuresPage.topAnchor constraintEqualToAnchor:_topDivider.bottomAnchor],
        [_featuresPage.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor],
    ]];

    // Default feature items
    if (!_featureItems || _featureItems.count == 0) {
        [self _loadDefaultFeatureItems];
    }
}

- (void)_buildProfilePage {
    _profilePage = [[UIView alloc] init];
    _profilePage.translatesAutoresizingMaskIntoConstraints = NO;
    _profilePage.backgroundColor = [UIColor clearColor];
    [_contentView addSubview:_profilePage];

    [NSLayoutConstraint activateConstraints:@[
        [_profilePage.leadingAnchor constraintEqualToAnchor:_contentView.leadingAnchor constant:16.0],
        [_profilePage.trailingAnchor constraintEqualToAnchor:_contentView.trailingAnchor constant:-16.0],
        [_profilePage.topAnchor constraintEqualToAnchor:_topDivider.bottomAnchor constant:4.0],
        [_profilePage.bottomAnchor constraintEqualToAnchor:_contentView.bottomAnchor constant:-8.0],
    ]];

    _fpsRow     = [[MenuInfoRow alloc] initWithKey:@"FPS"         value:@"0"             valueColor:MenuColorAccentGreen()];
    _timeRow    = [[MenuInfoRow alloc] initWithKey:@"Time"        value:@"00:00:00"       valueColor:MenuColorAccentCyan()];
    _deviceRow  = [[MenuInfoRow alloc] initWithKey:@"Device"      value:@"iPhone"         valueColor:MenuColorTextPrimary()];
    _iosRow     = [[MenuInfoRow alloc] initWithKey:@"iOS"         value:@"--"             valueColor:MenuColorTextPrimary()];
    _nameRow    = [[MenuInfoRow alloc] initWithKey:@"Name"        value:@"iPhone"         valueColor:MenuColorTextPrimary()];
    _versionRow = [[MenuInfoRow alloc] initWithKey:@"Version"     value:@"1.118.1"        valueColor:MenuColorAccentGreen()];
    _licenseRow = [[MenuInfoRow alloc] initWithKey:@"License Key" value:@"Not Available"  valueColor:MenuColorTextPrimary()];

    NSArray *rows = @[_fpsRow, _timeRow, _deviceRow, _iosRow, _nameRow, _versionRow, _licenseRow];
    UIStackView *rowStack = [[UIStackView alloc] initWithArrangedSubviews:rows];
    rowStack.axis = UILayoutConstraintAxisVertical;
    rowStack.spacing = 0.0;
    rowStack.distribution = UIStackViewDistributionFillEqually;
    rowStack.translatesAutoresizingMaskIntoConstraints = NO;
    [_profilePage addSubview:rowStack];

    [NSLayoutConstraint activateConstraints:@[
        [rowStack.leadingAnchor constraintEqualToAnchor:_profilePage.leadingAnchor],
        [rowStack.trailingAnchor constraintEqualToAnchor:_profilePage.trailingAnchor],
        [rowStack.topAnchor constraintEqualToAnchor:_profilePage.topAnchor],
        [rowStack.bottomAnchor constraintEqualToAnchor:_profilePage.bottomAnchor],
    ]];

    UIImage *clipIcon = MenuSFImage(@"doc.on.doc", 14.0);
    _licenseClipboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _licenseClipboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_licenseClipboardButton setImage:clipIcon forState:UIControlStateNormal];
    _licenseClipboardButton.tintColor = [UIColor colorWithRed:0.502 green:0.659 blue:0.851 alpha:0.7];
    [_licenseRow addSubview:_licenseClipboardButton];

    [NSLayoutConstraint activateConstraints:@[
        [_licenseClipboardButton.trailingAnchor constraintEqualToAnchor:_licenseRow.trailingAnchor constant:-4.0],
        [_licenseClipboardButton.centerYAnchor constraintEqualToAnchor:_licenseRow.centerYAnchor],
        [_licenseClipboardButton.widthAnchor constraintEqualToConstant:28.0],
        [_licenseClipboardButton.heightAnchor constraintEqualToConstant:28.0],
    ]];
}

- (void)_loadDefaultFeatureItems {
    self.featureItems = @[
        [[MenuToggleItem alloc] initWithTitle:@"Aim Kill"     subtitle:@"Auto aim + kill on target"    warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Aim Bot"      subtitle:@"Automatic aim assist"         warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Silent Aim"   subtitle:@"Hides aim from killcam"       warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Fly Alt"      subtitle:@"Fly mode alternative"         warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Free Fly"     subtitle:@"Fly in any direction"         warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Telekill"     subtitle:@"Teleport to enemy and kill"   warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"No Recoil"    subtitle:@"Removes weapon recoil"        warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"No Reload"    subtitle:@"Infinite ammo clip"           warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Auto Fire"    subtitle:@"Fires automatically on aim"   warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Fast Fire"    subtitle:@"Maximum fire rate"            warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Ghost VIP"    subtitle:@"Ghost VIP mode"               warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Ninja Dash"   subtitle:@"Ninja dash movement"          warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Enemies Pull" subtitle:@"Pull enemies toward you"      warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Under Kill"   subtitle:@"Kill from below"              warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Move Player"  subtitle:@"Move enemy player position"   warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Spine Player" subtitle:@"Spine hit detection"          warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Enemies Air"  subtitle:@"Lift enemies into air"        warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Fly Map"      subtitle:@"Fly through the map"          warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Fly Sky"      subtitle:@"Fly to sky"                   warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Auto Teleport"subtitle:@"Auto-teleport to nearest enemy"warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Mark Teleport"subtitle:@"Teleport to marked position"  warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Chain Damage" subtitle:@"Damages chain to all enemies" warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Bullet Thru"  subtitle:@"Bullets penetrate walls"      warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Long Range"   subtitle:@"Increased bullet range"       warning:nil],
        [[MenuToggleItem alloc] initWithTitle:@"Fast Switch"  subtitle:@"Fast weapon switch"           warning:nil],
    ];
}

- (void)setFeatureItems:(NSArray<MenuToggleItem *> *)featureItems {
    _featureItems = featureItems;
    [_featuresPage setItems:featureItems];
}

// MARK: Actions

- (void)_attachActions {
    [_closeTabButton addTarget:self action:@selector(_didTapClose) forControlEvents:UIControlEventTouchUpInside];
    [_downloadTabButton addTarget:self action:@selector(_didTapDownload) forControlEvents:UIControlEventTouchUpInside];
    [_moonTabButton addTarget:self action:@selector(_didTapMoon) forControlEvents:UIControlEventTouchUpInside];
    [_licenseClipboardButton addTarget:self action:@selector(_didTapClipboard) forControlEvents:UIControlEventTouchUpInside];
    [_mainTabButton addTarget:self action:@selector(_didTapMainTab) forControlEvents:UIControlEventTouchUpInside];

    for (NSUInteger i = 0; i < _sidebarButtons.count; i++) {
        _sidebarButtons[i].tag = (NSInteger)i;
        [_sidebarButtons[i] addTarget:self action:@selector(_didTapSidebar:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)_didTapClose {
    if ([_delegate respondsToSelector:@selector(menuViewControllerDidTapClose:)])
        [_delegate menuViewControllerDidTapClose:self];
    else
        [self dismissAnimated:YES];
}
- (void)_didTapDownload {
    if ([_delegate respondsToSelector:@selector(menuViewControllerDidTapDownload:)])
        [_delegate menuViewControllerDidTapDownload:self];
}
- (void)_didTapMoon {
    if ([_delegate respondsToSelector:@selector(menuViewControllerDidTapMoon:)])
        [_delegate menuViewControllerDidTapMoon:self];
}
- (void)_didTapMainTab {
    // Cycle through pages or stay on current
}
- (void)_didTapSidebar:(MenuSidebarButton *)sender {
    self.selectedSidebarIndex = sender.tag;
    MenuPage page = (sender.tag == 0) ? MenuPageProfile : MenuPageFeatures;
    [self showPage:page animated:YES];
    if ([_delegate respondsToSelector:@selector(menuViewControllerDidSelectSidebarIndex:)])
        [_delegate menuViewControllerDidSelectSidebarIndex:sender.tag];
    if ([_delegate respondsToSelector:@selector(menuViewController:didChangePage:)])
        [_delegate menuViewController:self didChangePage:page];
}
- (void)_didTapClipboard {
    [UIPasteboard generalPasteboard].string = _licenseKey ?: @"Not Available";
    [UIView animateWithDuration:0.12 animations:^{ self->_licenseClipboardButton.alpha = 0.3; }
                     completion:^(BOOL f) { [UIView animateWithDuration:0.20 animations:^{ self->_licenseClipboardButton.alpha = 1.0; }]; }];
}

// MARK: Page Switching

- (void)showPage:(MenuPage)page animated:(BOOL)animated {
    _currentPage = page;
    NSInteger sideIdx = (page == MenuPageProfile) ? 0 : _selectedSidebarIndex;
    NSString *title = (page == MenuPageProfile)
        ? _pageTitles[0]
        : (sideIdx < 5 ? _pageTitles[sideIdx] : @"FEATURES");
    NSString *icon = (page == MenuPageProfile)
        ? _pageIcons[0]
        : (sideIdx < 5 ? _pageIcons[sideIdx] : @"scope");

    [_mainTabButton setTitle:title sfImageName:icon];

    void (^swap)(void) = ^{
        self->_profilePage.hidden  = (page != MenuPageProfile);
        self->_featuresPage.hidden = (page != MenuPageFeatures);
    };

    if (animated) {
        [UIView transitionWithView:_contentView duration:0.20
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:swap completion:nil];
    } else {
        swap();
    }
}

// MARK: Setters

- (void)setSelectedSidebarIndex:(NSInteger)idx {
    _selectedSidebarIndex = idx;
    for (NSUInteger i = 0; i < _sidebarButtons.count; i++)
        [_sidebarButtons[i] setActiveState:(NSInteger)i == idx animated:YES];
}

- (void)setFps:(NSInteger)fps { _fps = fps; [_fpsRow updateValue:[NSString stringWithFormat:@"%ld", (long)fps]]; }
- (void)setDeviceName:(NSString *)v  { _deviceName  = v; [_deviceRow  updateValue:v]; }
- (void)setIosVersion:(NSString *)v  { _iosVersion  = v; [_iosRow     updateValue:v]; }
- (void)setProfileName:(NSString *)v { _profileName = v; [_nameRow    updateValue:v]; }
- (void)setAppVersion:(NSString *)v  { _appVersion  = v; [_versionRow updateValue:v]; }
- (void)setLicenseKey:(NSString *)v  { _licenseKey  = v; [_licenseRow updateValue:v ?: @"Not Available"]; }

// MARK: Defaults

- (void)_applyDefaultValues {
    _fps         = 0;
    _deviceName  = [[UIDevice currentDevice] model];
    _iosVersion  = [[UIDevice currentDevice] systemVersion];
    _profileName = [[UIDevice currentDevice] name];
    _appVersion  = @"1.118.1";
    _licenseKey  = nil;
    [_fpsRow     updateValue:[NSString stringWithFormat:@"%ld", (long)_fps]];
    [_deviceRow  updateValue:_deviceName];
    [_iosRow     updateValue:_iosVersion];
    [_nameRow    updateValue:_profileName];
    [_versionRow updateValue:_appVersion];
    [_licenseRow updateValue:@"Not Available"];
    [self _tickClock];
}

// MARK: Clock

- (void)startClock {
    [self stopClock];
    _clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                    selector:@selector(_tickClock) userInfo:nil repeats:YES];
}
- (void)stopClock { [_clockTimer invalidate]; _clockTimer = nil; }
- (void)_tickClock {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"HH:mm:ss";
    [_timeRow updateValue:[fmt stringFromDate:[NSDate date]]];
}

// MARK: Presentation

+ (instancetype)presentFromViewController:(UIViewController *)parent
                                 delegate:(nullable id<MenuViewControllerDelegate>)delegate {
    MenuViewController *vc = [[MenuViewController alloc] init];
    vc.delegate = delegate;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
    [parent presentViewController:vc animated:YES completion:^{ [vc startClock]; }];
    return vc;
}

- (void)dismissAnimated:(BOOL)animated {
    [self stopClock];
    [self dismissViewControllerAnimated:animated completion:nil];
}

@end

// MARK: - Tweak Entry Points

static MenuViewController *_sharedMenuVC = nil;

static UIViewController *_topViewController(void) {
    UIWindow *window = nil;
    if (@available(iOS 13.0, *)) {
        for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                    if (w.isKeyWindow) { window = w; break; }
                }
            }
        }
    }
    if (!window) window = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = window.rootViewController;
    while (vc.presentedViewController) vc = vc.presentedViewController;
    return vc;
}

void OpenMenu(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_sharedMenuVC) return;
        UIViewController *top = _topViewController();
        if (!top) return;
        _sharedMenuVC = [MenuViewController presentFromViewController:top delegate:nil];
    });
}

void CloseMenu(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_sharedMenuVC) return;
        [_sharedMenuVC dismissAnimated:YES];
        _sharedMenuVC = nil;
    });
}

BOOL IsMenuVisible(void) { return _sharedMenuVC != nil; }

MenuViewController *GetSharedMenu(void) { return _sharedMenuVC; }
