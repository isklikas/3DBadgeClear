#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <substrate.h>
#include <objc/runtime.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

@interface SBSApplicationShortcutItem : NSObject {}

@property (nonatomic,retain) NSData * userInfoData;
@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSString * localizedTitle;
@property (nonatomic,copy) NSString * localizedSubtitle;
@property (nonatomic,copy) id icon;
@property (nonatomic,copy) NSDictionary * userInfo;
@property (assign,nonatomic) unsigned long long activationMode;
@property (nonatomic,copy) NSString * bundleIdentifierToLaunch;
@property (nonatomic,copy) NSString * targetContentIdentifier;
- (NSString *)description;
- (NSString *)type;
- (void)setType:(NSString *)arg1 ;
- (NSDictionary *)userInfo;
- (void)setUserInfo:(NSDictionary *)arg1 ;
- (NSString *)targetContentIdentifier;
- (void)setTargetContentIdentifier:(NSString *)arg1 ;
- (void)setBundleIdentifierToLaunch:(NSString *)arg1 ;
- (NSString *)localizedTitle;
- (void)setLocalizedTitle:(NSString *)arg1 ;
- (id)icon;
- (NSString *)localizedSubtitle;
- (NSData *)userInfoData;
- (unsigned long long)activationMode;
- (void)setLocalizedSubtitle:(NSString *)arg1 ;
- (void)setIcon:(id)arg1 ;
- (void)setActivationMode:(unsigned long long)arg1 ;
- (void)setUserInfoData:(NSData *)arg1 ;

@end
