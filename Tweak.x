// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

#import "SBSApplicationShortcutItem.h"

@interface SBApplicationController : NSObject
+ (id)sharedInstance;
- (id)applicationWithBundleIdentifier:(id)arg1;
@end

@interface SBIconController : UIViewController {}

- (id)iconManager:(id)arg1 launchActionsForIconView:(id)arg2; //Not 3D Touch related
- (id)launchActionsForIconView:(id)arg1; //Not 3D Touch related
- (void)_runAppIconForceTouchTest:(id)arg1 withOptions:(id)arg2; // Only Apple Test Method
- (BOOL)iconManager:(id)arg1 shouldActivateApplicationShortcutItem:(id)arg2 atIndex:(unsigned long long)arg3 forIconView:(id)arg4; //This is called when you tap an action. Edit Home Screen and Delete return FALSE :D
- (id)iconManager:(id)arg1 applicationShortcutItemsForIconView:(id)arg2; //Add the Shortcut here

@end

%hook SBIconController

- (BOOL)iconManager:(id)arg1 shouldActivateApplicationShortcutItem:(id)arg2 atIndex:(unsigned long long)arg3 forIconView:(id)arg4 {
	BOOL shouldActivate = %orig(arg1, arg2, arg3, arg4);
	NSLog(@"iconManager:shouldActivateApplicationShortcutItem: %@ atIndex: %llu forIconView: %@ \n %d", arg2, arg3, arg4, shouldActivate);
	NSString *shortcutType = [arg2 performSelector:@selector(type)];
	if ([shortcutType isEqualToString:@"com.isklikas.springboardhome.application-shotcut-item.clear-badges"]) {
		id iconObject = [arg4 performSelector:@selector(icon)];
		[iconObject performSelector:@selector(setBadge:) withObject:nil];
		return FALSE;
	}
	return shouldActivate;
}

- (id)iconManager:(id)arg1 applicationShortcutItemsForIconView:(id)arg2 {
	NSArray *shortcutItems = %orig(arg1, arg2);
	id iconObject = [arg2 performSelector:@selector(icon)];
	//Check if it is an app and it has a badge in the first place
	if ([iconObject isKindOfClass:objc_getClass("SBFolderIcon")]) {
		//This is a folder, not an app. For now, do nothing!
		return shortcutItems;
	}
	else {
		//It is an application
		id app = [iconObject performSelector:@selector(application)];
		id badgeValue = [app performSelector:@selector(badgeValue)];
		if (!badgeValue) /* badgeValue is null when badge is zero */ {
			return shortcutItems;
		}
		/*
			For creation of the delete item, we are based on:
			<SBSApplicationShortcutItem: 0x283137750; type: com.apple.springboardhome.application-shotcut-item.rearrange-icons; localizedTitle: "Edit Home Screen"; localizedSubtitle: 0x0; targetContentIdentifier: 0x0; icon: <SBSApplicationShortcutSystemIcon: 0x2810263c0>; bundleIdentifierToLaunch: 0x0; activationMode: 0>
		*/
		id previousItem = shortcutItems[shortcutItems.count-1];
		id shortcutIcon = [previousItem performSelector:@selector(icon)];
		id clearItem = [previousItem copy];
		[clearItem performSelector:@selector(setType:) withObject:@"com.isklikas.springboardhome.application-shotcut-item.clear-badges"];
		[clearItem performSelector:@selector(setLocalizedTitle:) withObject:@"Clear Badge"];
		[clearItem performSelector:@selector(setLocalizedSubtitle:) withObject:nil];
		[clearItem performSelector:@selector(setTargetContentIdentifier:) withObject:nil];
		[clearItem performSelector:@selector(setIcon:) withObject:shortcutIcon];
		[clearItem performSelector:@selector(setBundleIdentifierToLaunch:) withObject:nil];

		NSMutableArray *arrayWithClearBadges = [NSMutableArray arrayWithArray: shortcutItems];
		[arrayWithClearBadges addObject:clearItem];
		return arrayWithClearBadges;
	}
}

%end