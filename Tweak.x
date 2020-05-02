// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

#define kBundlePath @"/Library/MobileSubstrate/DynamicLibraries/com.isklikas.3DBadgeClear-resources.bundle"
#define preferencesPath @"/var/mobile/Library/Preferences/com.isklikas.3dbadgeclearprefs.plist"
#define noctisEnabledPath @"/var/mobile/Library/Preferences/com.laughingquoll.noctis.plist"
#define noctis12EnabledPath @"/var/mobile/Library/Preferences/com.laughingquoll.noctis12prefs.plist"
#define eclipsePath @"/var/mobile/Library/Preferences/com.gmoran.eclipse.plist"

#import "SBSApplicationShortcutItem.h"

@interface SBIconController : UIViewController {}

- (id)iconManager:(id)arg1 launchActionsForIconView:(id)arg2; //Not 3D Touch related
- (id)launchActionsForIconView:(id)arg1; //Not 3D Touch related
- (void)_runAppIconForceTouchTest:(id)arg1 withOptions:(id)arg2; // Only Apple Test Method
- (BOOL)iconManager:(id)arg1 shouldActivateApplicationShortcutItem:(id)arg2 atIndex:(unsigned long long)arg3 forIconView:(id)arg4; //This is called when you tap an action. Edit Home Screen and Delete return FALSE :D
- (id)iconManager:(id)arg1 applicationShortcutItemsForIconView:(id)arg2; //Add the Shortcut here

//iOS 12 Methods 

- (id)appIconForceTouchController:(id)arg1 applicationShortcutItemsForGestureRecognizer:(id)arg2 ;
- (BOOL)appIconForceTouchController:(id)arg1 shouldActivateApplicationShortcutItem:(id)arg2 atIndex:(unsigned long long)arg3 forGestureRecognizer:(id)arg4 ;
- (id)appIconForceTouchController:(id)arg1 applicationBundleIdentifierForGestureRecognizer:(id)arg2 ;

@end

@interface SBSApplicationShortcutCustomImageIcon : NSObject

@property (nonatomic, readonly, retain) NSData *imagePNGData;
- (id)initWithImagePNGData:(NSData *)imageData;

@end

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
@end

%hook SBIconController

//iOS 10-12 Method
//Maybe folders use a different method? Or have a different method since I can not use the bundle ID. 
//I would appreciate some help, or a tester on iOS 12 or below.
- (id)appIconForceTouchController:(id)arg1 applicationShortcutItemsForGestureRecognizer:(id)arg2 {
	NSArray *shortcutItems = %orig(arg1, arg2);
	NSString *bundleID = [self appIconForceTouchController:arg1 applicationBundleIdentifierForGestureRecognizer:arg2];
	if (bundleID) {
		id app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];
		//The app object knows if there is a badge or not
		id badgeValue;
		if ([app respondsToSelector:@selector(badgeValue)]) {
			//iOS 12.1 Method
			badgeValue = [app performSelector:@selector(badgeValue)];
		} else {
			//iOS 7 - 12.0 Method
			badgeValue = [app performSelector:@selector(iconBadgeNumberOrString)];
		}
		if (!badgeValue) /* badgeValue is null when badge is zero */ {
			return shortcutItems;
		}
		NSMutableArray *arrayWithClearBadges = [self performSelector:@selector(arrayWithClearItem:forFolder:) withObject: shortcutItems withObject:[NSNumber numberWithBool:FALSE]];
		return arrayWithClearBadges;
	}
	else {
		//It is probably a folder then.
		return shortcutItems;
	}
}

//iOS 10-12 Method
- (BOOL)appIconForceTouchController:(id)arg1 shouldActivateApplicationShortcutItem:(id)arg2 atIndex:(unsigned long long)arg3 forGestureRecognizer:(id)arg4 {
	BOOL shouldActivate = %orig(arg1, arg2, arg3, arg4);
	NSString *shortcutType = [arg2 performSelector:@selector(type)];
	if ([shortcutType isEqualToString:@"com.isklikas.springboardhome.application-shotcut-item.clear-badges"]) {
		NSString *bundleID = [self appIconForceTouchController:arg1 applicationBundleIdentifierForGestureRecognizer:arg4];
		id app = [[objc_getClass("SBApplicationController") sharedInstance] applicationWithBundleIdentifier:bundleID];
		if ([app respondsToSelector:@selector(setBadgeValue:)]) /* iOS 12.1 Method */ {
			[app performSelector:@selector(setBadgeValue:) withObject: nil];
		}
		else if ([app respondsToSelector:@selector(setBadgeNumberOrString:)]) /* iOS 11 Method */ {
			[app performSelector:@selector(setBadgeNumberOrString:) withObject: nil];
		}
		else if ([app respondsToSelector:@selector(setBadge:)]) /* iOS 7 - 10.2 Method */ {
			[app performSelector:@selector(setBadge:) withObject: nil];
		}
		return FALSE;
	}
	return shouldActivate;
}

//iOS 13+ Method
- (BOOL)iconManager:(id)arg1 shouldActivateApplicationShortcutItem:(id)arg2 atIndex:(unsigned long long)arg3 forIconView:(id)arg4 {
	BOOL shouldActivate = %orig(arg1, arg2, arg3, arg4);
	NSString *shortcutType = [arg2 performSelector:@selector(type)];
	if ([shortcutType isEqualToString:@"com.isklikas.springboardhome.application-shotcut-item.clear-badges"]) {
		id iconObject = [arg4 performSelector:@selector(icon)];
		if ([iconObject isKindOfClass:objc_getClass("SBFolderIcon")]) {
			NSArray *iconsInFolder = [[iconObject performSelector:@selector(folder)] performSelector:@selector(icons)];
			for (id appIcon in iconsInFolder) {
				[appIcon performSelector:@selector(setBadge:) withObject:nil];
			}
		}
		else {
			[iconObject performSelector:@selector(setBadge:) withObject:nil];
		}
		return FALSE;
	}
	return shouldActivate;
}

//iOS 13+ Method
- (id)iconManager:(id)arg1 applicationShortcutItemsForIconView:(id)arg2 {
	NSArray *shortcutItems = %orig(arg1, arg2);
	id iconObject = [arg2 performSelector:@selector(icon)];
	//Check if it is an app and it has a badge in the first place
	if ([iconObject isKindOfClass:objc_getClass("SBFolderIcon")]) {
		//SBFolderIcon -> "folder" property -> "icons" property is NSArray
		NSArray *iconsInFolder = [[iconObject performSelector:@selector(folder)] performSelector:@selector(icons)];
		BOOL folderHasBadge = FALSE;
		for (id appIcon in iconsInFolder) {
			id app = [appIcon performSelector:@selector(application)];
			id badgeValue = [app performSelector:@selector(badgeValue)];
			if (badgeValue) /* badgeValue is null when badge is zero */ {
				folderHasBadge = TRUE;
				break;
			}
		}
		if (!folderHasBadge) {
			return shortcutItems;
		}
		else {
			NSMutableArray *arrayWithClearBadges = [self performSelector:@selector(arrayWithClearItem:forFolder:) withObject: shortcutItems withObject:[NSNumber numberWithBool:TRUE]];
			return arrayWithClearBadges;
		}	
	}
	else {
		//It is an application
		id app = [iconObject performSelector:@selector(application)];
		id badgeValue = [app performSelector:@selector(badgeValue)];
		if (!badgeValue) /* badgeValue is null when badge is zero */ {
			return shortcutItems;
		}
		//NSLog(@"The badgeValue is: %@", badgeValue);
		NSMutableArray *arrayWithClearBadges = [self performSelector:@selector(arrayWithClearItem:forFolder:) withObject: shortcutItems withObject:[NSNumber numberWithBool:FALSE]];
		return arrayWithClearBadges;
	}
}

%new
- (NSMutableArray *)arrayWithClearItem:(NSArray *)shortcutItems forFolder:(NSNumber *)isFolder {
	//Get the appropriate custom image
	NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];
	UIImage *myImage = [UIImage imageNamed:@"clearbadge" inBundle:bundle compatibleWithTraitCollection:nil];
	if (@available(iOS 13.0, *)) {
    	BOOL isInDarkMode = ([[UITraitCollection currentTraitCollection] userInterfaceStyle] == UIUserInterfaceStyleDark);
		if (isInDarkMode) {
			myImage = [UIImage imageNamed:@"clearbadge-dark" inBundle:bundle compatibleWithTraitCollection:nil];
		}
	}
	else {
		//Let's check for various popular tweaks, if they are enabled!
		//Noctis has 2 of them
		NSDictionary *noctisPrefs = [[NSDictionary alloc] initWithContentsOfFile:noctisEnabledPath];
		NSDictionary *noctis12Prefs = [[NSDictionary alloc] initWithContentsOfFile:noctis12EnabledPath];
		BOOL isNoctisEnabled = ([[noctisPrefs objectForKey:@"LQDDarkModeEnabled"] boolValue] || [[noctis12Prefs objectForKey:@"enabled"] boolValue]);
		
		//Eclipse
		NSDictionary *eclipsePrefs = [[NSDictionary alloc] initWithContentsOfFile:eclipsePath];
		BOOL isEclipseEnabled = [[eclipsePrefs objectForKey:@"enabled"] boolValue];
		
		if (isNoctisEnabled || isEclipseEnabled) {
			myImage = [UIImage imageNamed:@"clearbadge-dark" inBundle:bundle compatibleWithTraitCollection:nil];
		}
		
	}
	id customIcon = [[objc_getClass("SBSApplicationShortcutCustomImageIcon") alloc] initWithImagePNGData: UIImagePNGRepresentation(myImage)];
	
	//Make the clear shortcut
	/*
		For creation of the clear item, we are based on:
		<SBSApplicationShortcutItem: 0x283137750; type: com.apple.springboardhome.application-shotcut-item.rearrange-icons; localizedTitle: "Edit Home Screen"; localizedSubtitle: 0x0; targetContentIdentifier: 0x0; icon: <SBSApplicationShortcutSystemIcon: 0x2810263c0>; bundleIdentifierToLaunch: 0x0; activationMode: 0>
	*/
	id clearItem = [[objc_getClass("SBSApplicationShortcutItem") alloc] init];
	[clearItem performSelector:@selector(setType:) withObject:@"com.isklikas.springboardhome.application-shotcut-item.clear-badges"];
    NSString *bPath = [bundle pathForResource:@"Translations" ofType:@"bundle"];
    NSBundle *tBundle = [[NSBundle alloc] initWithPath:bPath];
    NSString *clearBadge = @"";
    if ([isFolder boolValue]) {
    	clearBadge = NSLocalizedStringFromTableInBundle(@"Clear_Badges", nil, tBundle, nil);
    }
    else {
    	clearBadge = NSLocalizedStringFromTableInBundle(@"Clear_Badge", nil, tBundle, nil);
    }
	[clearItem performSelector:@selector(setLocalizedTitle:) withObject:clearBadge];
	[clearItem performSelector:@selector(setLocalizedSubtitle:) withObject:nil];
	if ([clearItem respondsToSelector:@selector(setTargetContentIdentifier:)]) {
		[clearItem performSelector:@selector(setTargetContentIdentifier:) withObject:nil];
	}
	[clearItem performSelector:@selector(setIcon:) withObject:customIcon];
	[clearItem performSelector:@selector(setBundleIdentifierToLaunch:) withObject:nil];
	typedef void (*send_type)(void*, SEL, unsigned long long);
	SEL setOffsetSEL = @selector(setActivationMode:);
	send_type setOffsetIMP = (send_type)[objc_getClass("SBSApplicationShortcutItem") instanceMethodForSelector:setOffsetSEL];
	setOffsetIMP((__bridge void*)clearItem, setOffsetSEL, 0);

	//First or last option
	NSDictionary *ourPrefs = [[NSDictionary alloc] initWithContentsOfFile:preferencesPath];
	BOOL appearsLast = TRUE;
	if (ourPrefs) {
		appearsLast = [[ourPrefs objectForKey:@"appearsLast"] boolValue];
	}
	
	NSMutableArray *arrayWithClearBadges;
	if (appearsLast) {
		if (shortcutItems) {
			arrayWithClearBadges = [NSMutableArray arrayWithArray: shortcutItems];
		} else {
			arrayWithClearBadges = [NSMutableArray new];
		}
		[arrayWithClearBadges addObject:clearItem];
	}
	else {
		arrayWithClearBadges = [NSMutableArray new];
		[arrayWithClearBadges addObject:clearItem];
		if (shortcutItems) {
			[arrayWithClearBadges addObjectsFromArray: shortcutItems];
		}
	}
	return arrayWithClearBadges;
}

%end
