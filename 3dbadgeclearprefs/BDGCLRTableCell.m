#include "BDGCLRRootListController.h"

@implementation BDGCLRTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    specifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier
                    specifier:specifier];
  if (self) {
    if ([BDGCLRPreferenceSettings sharedInstance].tintColor) {
      self.textLabel.textColor =
          [BDGCLRPreferenceSettings sharedInstance].tintColor;
    }
  }
  return self;
}

- (void)tintColorDidChange {
  [super tintColorDidChange];

  if ([BDGCLRPreferenceSettings sharedInstance].tintColor) {
    self.textLabel.textColor = [BDGCLRPreferenceSettings sharedInstance].tintColor;
  }
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
  [super refreshCellContentsWithSpecifier:specifier];

  if ([BDGCLRPreferenceSettings sharedInstance].tintColor) {
    self.textLabel.textColor = [BDGCLRPreferenceSettings sharedInstance].tintColor;
  }
}
@end
