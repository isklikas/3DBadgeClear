#import <Preferences/PSHeaderFooterView.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface BDGCLRHeaderCell : PSTableCell <PSHeaderFooterView>
@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) UILabel *subtitleLabel;
@property(nonatomic, retain) UIImageView *iconView;
@property(nonatomic, retain) UIStackView *containerStackView;
@property(nonatomic, retain) UIView *backgroundView;
@end

@interface BDGCLRPreferenceSettings : NSObject
@property(nonatomic) BOOL customizeNavbar;
@property(nonatomic, strong) UIColor *barTintColor;
@property(nonatomic, strong) UIColor *tintColor;

+ (instancetype)sharedInstance;
- (id)init;
@end

@interface BDGCLRListController : PSListController
@property(nonatomic, strong) BDGCLRPreferenceSettings *preferenceSettings;
@end

@interface BDGCLRTableCell : PSTableCell
@end

@interface BDGCLRRootListController : BDGCLRListController

@end

