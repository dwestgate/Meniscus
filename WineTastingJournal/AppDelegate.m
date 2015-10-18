//
//  AppDelegate.m
//  WineTastingJournal
//
//  Created by David Westgate on 6/15/15.
//  Copyright (c) 2015 David Westgate. All rights reserved.
//

#import "AppDelegate.h"
#import "ItemsViewController.h"
#import "ItemStore.h"

NSString * const NextItemValuePrefsKey = @"NextItemValue";
NSString * const NextItemNamePrefsKey = @"NextItemName";
NSString * const NextItemTastingIDPrefsKey = @"NextItemTastingID";
NSString * const NextItemNotesPrefsKey = @"NextItemNotes";
NSString * const NextItemClarityPrefsKey = @"NextItemClarity";
NSString * const NextItemClarityValuePrefsKey = @"NextItemClarityValuePrefsKey";
NSString * const NextItemMeniscusPrefsKey = @"NextItemMeniscus";
NSString * const NextItemMeniscusValuePrefsKey = @"NextItemMeniscusValuePrefsKey";
NSString * const NextItemColorPrefsKey = @"NextItemColorPrefsKey";
NSString * const NextItemColorValuePrefsKey = @"NextItemColorValuePrefsKey";
NSString * const NextItemColorIntensityPrefsKey = @"NextItemColorIntensityPrefsKey";
NSString * const NextItemColorIntensityValuePrefsKey = @"NextItemColorIntensityValuePrefsKey";
NSString * const NextItemColorShadePrefsKey = @"NextItemColorShadePrefsKey";
NSString * const NextItemColorShadeValuePrefsKey = @"NextItemColorShadeValuePrefsKey";
NSString * const NextItemPetillancePrefsKey = @"NextItemPetillancePrefsKey";
NSString * const NextItemPetillanceValuePrefsKey = @"NextItemPetillanceValuePrefsKey";
NSString * const NextItemViscosityPrefsKey = @"NextItemViscosityPrefsKey";
NSString * const NextItemViscosityValuePrefsKey = @"NextItemViscosityValuePrefsKey";
NSString * const NextItemSedimentPrefsKey = @"NextItemSedimentPrefsKey";
NSString * const NextItemSedimentValuePrefsKey = @"NextItemSedimentValuePrefsKey";
NSString * const NextItemConditionPrefsKey = @"NextItemConditionPrefsKey";
NSString * const NextItemConditionSliderValuePrefsKey = @"NextItemConditionSliderValuePrefsKey";
NSString * const NextItemAromaIntensityPrefsKey = @"NextItemAromaIntensityPrefsKey";
NSString * const NextItemAromaIntensityValuePrefsKey = @"NextItemAromaIntensityValuePrefsKey";
NSString * const NextItemAromasPrefsKey = @"NextItemAromasPrefsKey";
NSString * const NextItemDevelopmentPrefsKey = @"NextItemDevelopmentPrefsKey";
NSString * const NextItemDevelopmentValuePrefsKey = @"NextItemDevelopmentValuePrefsKey";
NSString * const NextItemSweetnessPrefsKey = @"NextItemSweetnessPrefsKey";
NSString * const NextItemSweetnessValuePrefsKey = @"NextItemSweetnessValuePrefsKey";
NSString * const NextItemAcidityPrefsKey = @"NextItemAcidityPrefsKey";
NSString * const NextItemAcidityValuePrefsKey = @"NextItemAcidityValuePrefsKey";
NSString * const NextItemTanninPrefsKey = @"NextItemTanninPrefsKey";
NSString * const NextItemTanninValuePrefsKey = @"NextItemTanninValuePrefsKey";
NSString * const NextItemAlcoholPrefsKey = @"NextItemAlcoholPrefsKey";
NSString * const NextItemAlcoholValuePrefsKey = @"NextItemAlcoholValuePrefsKey";
NSString * const NextItemBodyPrefsKey = @"NextItemBodyPrefsKey";
NSString * const NextItemBodyValuePrefsKey = @"NextItemBodyValuePrefsKey";
NSString * const NextItemFlavorIntensityPrefsKey = @"NextItemFlavorIntensityPrefsKey";
NSString * const NextItemFlavorIntensityValuePrefsKey = @"NextItemFlavorIntensityValuePrefsKey";
NSString * const NextItemFlavorsPrefsKey = @"NextItemFlavorsPrefsKey";
NSString * const NextItemBalancePrefsKey = @"NextItemBalancePrefsKey";
NSString * const NextItemMoussePrefsKey = @"NextItemMoussePrefsKey";
NSString * const NextItemMousseValuePrefsKey = @"NextItemMousseValuePrefsKey";
NSString * const NextItemFinishPrefsKey = @"NextItemFinishPrefsKey";
NSString * const NextItemFinishValuePrefsKey = @"NextItemFinishValuePrefsKey";
NSString * const NextItemQualityPrefsKey = @"NextItemQualityPrefsKey";
NSString * const NextItemQualityValuePrefsKey = @"NextItemQualityValuePrefsKey";
NSString * const NextItemReadinessPrefsKey = @"NextItemReadinessPrefsKey";

NSString * const NextItemHundredPointScorePrefsKey = @"NextItemHundredPointScorePrefsKey";
NSString * const NextItemHundredPointScoreValuePrefsKey = @"NextItemHundredPointScoreValuePrefsKey";
NSString * const NextItemFivePointScorePrefsKey = @"NextItemFivePointScorePrefsKey";
NSString * const NextItemFivePointScoreValuePrefsKey = @"NextItemFivePointScoreValuePrefsKey";
NSString * const NextItemOtherScoresPrefsKey = @"NextItemOtherScoresPrefsKey";

NSString * const NextItemWinemakerPrefsKey = @"NextItemWinemakerPrefsKey";
NSString * const NextItemVintagePrefsKey = @"NextItemVintagePrefsKey";
NSString * const NextItemAppellationPrefsKey = @"NextItemAppellationPrefsKey";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *factorySettings = @{NextItemNamePrefsKey : @"",
                                    NextItemTastingIDPrefsKey : @"",
                                    NextItemNotesPrefsKey : @"",
                                    NextItemClarityPrefsKey : @"Wine Clarity",
                                    NextItemClarityValuePrefsKey : @1,
                                    NextItemMeniscusPrefsKey : @"Meniscus",
                                    NextItemMeniscusValuePrefsKey : @1,
                                    NextItemColorPrefsKey : @"Wine Color",
                                    NextItemColorValuePrefsKey : @1,
                                    NextItemColorIntensityPrefsKey : @"Color Intensity",
                                    NextItemColorIntensityValuePrefsKey : @1,
                                    NextItemColorShadePrefsKey : @"Color Shade",
                                    NextItemColorShadeValuePrefsKey : @1,
                                    NextItemPetillancePrefsKey : @"Petillance",
                                    NextItemPetillanceValuePrefsKey : @1,
                                    NextItemViscosityPrefsKey : @"Viscosity",
                                    NextItemViscosityValuePrefsKey : @1,
                                    NextItemSedimentPrefsKey : @"Sediment",
                                    NextItemSedimentValuePrefsKey : @1,
                                    NextItemConditionPrefsKey : @"Condition",
                                    NextItemConditionSliderValuePrefsKey : @1,
                                    NextItemAromaIntensityPrefsKey : @"Aroma Intensity",
                                    NextItemAromaIntensityValuePrefsKey : @1,
                                    NextItemAromasPrefsKey : @"",
                                    NextItemDevelopmentPrefsKey : @"State of Development",
                                    NextItemDevelopmentValuePrefsKey : @1,
                                    NextItemSweetnessPrefsKey : @"Sweetness",
                                    NextItemSweetnessValuePrefsKey : @1,
                                    NextItemAcidityPrefsKey : @"Acidity",
                                    NextItemAcidityValuePrefsKey : @1,
                                    NextItemTanninPrefsKey : @"Tannin",
                                    NextItemTanninValuePrefsKey : @"1",
                                    NextItemAlcoholPrefsKey : @"Alcohol Level",
                                    NextItemAlcoholValuePrefsKey : @1,
                                    NextItemBodyPrefsKey : @"Body",
                                    NextItemBodyValuePrefsKey : @1,
                                    NextItemFlavorIntensityPrefsKey : @"Intensity of Flavor",
                                    NextItemFlavorIntensityValuePrefsKey : @1,
                                    NextItemFlavorsPrefsKey : @"",
                                    NextItemBalancePrefsKey : @"Balance",
                                    NextItemMoussePrefsKey : @"Mousse",
                                    NextItemMousseValuePrefsKey : @1,
                                    NextItemFinishPrefsKey : @"Length of Finish",
                                    NextItemFinishValuePrefsKey : @1,
                                    NextItemQualityPrefsKey : @"Quality",
                                    NextItemQualityValuePrefsKey : @1,
                                    NextItemReadinessPrefsKey : @"Readiness",
                                    NextItemHundredPointScorePrefsKey : @"100-Point Score",
                                    NextItemHundredPointScoreValuePrefsKey : @1,
                                    NextItemFivePointScorePrefsKey : @"5-Point Score",
                                    NextItemFivePointScoreValuePrefsKey : @1,
                                    NextItemOtherScoresPrefsKey : @"",
                                    NextItemWinemakerPrefsKey : @"",
                                    NextItemVintagePrefsKey : @"",
                                    NextItemAppellationPrefsKey : @"",
                                    NextItemValuePrefsKey : @0
                                    };
  [defaults registerDefaults:factorySettings];
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
  UIViewController *vc = [[UINavigationController alloc] init];
  vc.restorationIdentifier = [identifierComponents lastObject];
  
  if ([identifierComponents count] == 1) {
    self.window.rootViewController = vc;
  } else {
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
  }
  
  return vc;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
  return YES;
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
  return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  
  return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  if (!self.window.rootViewController) {
    
    ItemsViewController *itemsViewController = [[ItemsViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:itemsViewController];
    
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    self.window.rootViewController = navController;

  }
  self.window.tintColor = [UIColor colorWithRed:175.0f/255.0f green:33.0f/255.0f blue:59.0f/255.0f alpha:1.0];
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    BOOL success = [[ItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the Items");
    } else {
        NSLog(@"Could not save any of the Items");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
