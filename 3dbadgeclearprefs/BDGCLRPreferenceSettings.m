#include "BDGCLRRootListController.h"

@implementation BDGCLRPreferenceSettings
+ (instancetype)sharedInstance {
  static BDGCLRPreferenceSettings *sharedInstance = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [BDGCLRPreferenceSettings alloc];
  });

  return sharedInstance;
}

- (id)init {
  return [BDGCLRPreferenceSettings sharedInstance];
}
@end
