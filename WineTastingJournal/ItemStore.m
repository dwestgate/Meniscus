//
//  ItemStore.m
//  WineTastingJournal
//
//  Created by David Westgate on 6/15/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "ItemStore.h"
#import "Item.h"
#import "ImageStore.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface ItemStore ()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSMutableArray *allAromas;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation ItemStore

+ (instancetype)sharedStore
{
    static ItemStore *sharedStore;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[ItemStore sharedStore]"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
      _model = [NSManagedObjectModel mergedModelFromBundles:nil];
      
      NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
      
      NSString *path = self.itemArchivePath;
      NSURL *storeURL = [NSURL fileURLWithPath:path];
      
      NSError *error;
      
      if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                             configuration:nil
                                       URL:storeURL
                                   options:nil
                                     error:&error]) {
        [NSException raise:@"Open Failure"
                    format:@"Reason: %@", [error localizedDescription]];
      }
      
      _context = [[NSManagedObjectContext alloc] init];
      _context.persistentStoreCoordinator = psc;
      
      [self loadAllItems];
      
    }
    return self;
}

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (Item *)createItem
{
  double order;
  if ([self.allItems count] == 0) {
    order = 1.0;
  } else {
    order = [[self.privateItems lastObject] orderingValue] + 1.0;
  }
  NSLog(@"Adding after %lu items, order %.2f", (unsigned long)[self.privateItems count], order);
  Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                                inManagedObjectContext:self.context];
  item.orderingValue = order;
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  item.valueInDollars = [[defaults objectForKey:NextItemValuePrefsKey] intValue];
  item.itemName = [defaults objectForKey:NextItemNamePrefsKey];
  item.itemTastingID = [defaults objectForKey:NextItemTastingIDPrefsKey];
  item.itemNotes = [defaults objectForKey:NextItemNotesPrefsKey];
  item.itemClarity = [defaults objectForKey:NextItemClarityPrefsKey];
  item.itemClarityValue = [[defaults objectForKey:NextItemClarityValuePrefsKey] intValue];
  item.itemColor = [defaults objectForKey:NextItemColorPrefsKey];
  item.itemColorValue = [[defaults objectForKey:NextItemColorValuePrefsKey] intValue];
  item.itemColorIntensity = [defaults objectForKey:NextItemColorIntensityPrefsKey];
  item.itemColorIntensityValue = [[defaults objectForKey:NextItemColorIntensityValuePrefsKey] intValue];
  item.itemColorShade = [defaults objectForKey:NextItemColorShadePrefsKey];
  item.itemColorShadeValue = [[defaults objectForKey:NextItemColorShadeValuePrefsKey] intValue];
  item.itemPetillance = [defaults objectForKey:NextItemPetillancePrefsKey];
  item.itemPetillanceValue = [[defaults objectForKey:NextItemPetillanceValuePrefsKey] intValue];
  item.itemViscosity = [defaults objectForKey:NextItemViscosityPrefsKey];
  item.itemViscosityValue = [[defaults objectForKey:NextItemViscosityValuePrefsKey] intValue];
  item.itemSediment = [defaults objectForKey:NextItemSedimentPrefsKey];
  item.itemSedimentValue = [[defaults objectForKey:NextItemSedimentValuePrefsKey] intValue];
  item.itemCondition = [defaults objectForKey:NextItemConditionPrefsKey];
  item.itemConditionSliderValue = [[defaults objectForKey:NextItemConditionSliderValuePrefsKey] intValue];
  item.itemAromaIntensity = [defaults objectForKey:NextItemAromaIntensityPrefsKey];
  item.itemAromaIntensityValue = [[defaults objectForKey:NextItemAromaIntensityValuePrefsKey] intValue];
  item.itemAromas = [defaults objectForKey:NextItemAromasPrefsKey];
  item.itemDevelopment = [defaults objectForKey:NextItemDevelopmentPrefsKey];
  item.itemDevelopmentValue = [[defaults objectForKey:NextItemDevelopmentValuePrefsKey] intValue];
  item.itemSweetness = [defaults objectForKey:NextItemSweetnessPrefsKey];
  item.itemSweetnessValue = [[defaults objectForKey:NextItemSweetnessValuePrefsKey] intValue];
  item.itemAcidity = [defaults objectForKey:NextItemAcidityPrefsKey];
  item.itemAcidityValue = [[defaults objectForKey:NextItemAcidityValuePrefsKey] intValue];
  item.itemTannin = [defaults objectForKey:NextItemTanninPrefsKey];
  item.itemTanninValue = [[defaults objectForKey:NextItemTanninValuePrefsKey] intValue];
  item.itemAlchohol = [defaults objectForKey:NextItemAlchoholPrefsKey];
  item.itemAlchoholValue = [[defaults objectForKey:NextItemAlchoholValuePrefsKey] intValue];
  item.itemBody = [defaults objectForKey:NextItemBodyPrefsKey];
  item.itemBodyValue = [[defaults objectForKey:NextItemBodyValuePrefsKey] intValue];
  item.itemFlavorIntensity = [defaults objectForKey:NextItemFlavorIntensityPrefsKey];
  item.itemFlavorIntensityValue = [[defaults objectForKey:NextItemFlavorIntensityValuePrefsKey] intValue];
  item.itemFlavors = [defaults objectForKey:NextItemFlavorsPrefsKey];
  item.itemBalance = [defaults objectForKey:NextItemBalancePrefsKey];
  item.itemMousse = [defaults objectForKey:NextItemMoussePrefsKey];
  item.itemMousseValue = [[defaults objectForKey:NextItemMousseValuePrefsKey] intValue];
  item.itemFinish = [defaults objectForKey:NextItemFinishPrefsKey];
  item.itemFinishValue = [[defaults objectForKey:NextItemFinishValuePrefsKey] intValue];
  item.itemQuality = [defaults objectForKey:NextItemQualityPrefsKey];
  item.itemQualityValue = [[defaults objectForKey:NextItemQualityValuePrefsKey] intValue];
  item.itemReadiness = [defaults objectForKey:NextItemReadinessPrefsKey];
  item.itemHundredPointScore = [defaults objectForKey:NextItemHundredPointScorePrefsKey];
  item.itemHundredPointScoreValue = [[defaults objectForKey:NextItemHundredPointScoreValuePrefsKey] intValue];
  item.itemFivePointScore = [defaults objectForKey:NextItemFivePointScorePrefsKey];
  item.itemFivePointScoreValue = [[defaults objectForKey:NextItemFivePointScoreValuePrefsKey] intValue];
  item.itemOtherScores = [defaults objectForKey:NextItemOtherScoresPrefsKey];
  item.itemWinemaker = [defaults objectForKey:NextItemWinemakerPrefsKey];
  item.itemVintage = [defaults objectForKey:NextItemVintagePrefsKey];
  item.itemAppellation = [defaults objectForKey:NextItemAppellationPrefsKey];

  NSLog(@"defaults = %@", [defaults dictionaryRepresentation]);
  
  [self.privateItems addObject:item];
  
  return item;
}

- (void)removeItem:(Item *)item
{
  NSString *key = item.itemKey;
  [[ImageStore sharedStore] deleteImageForKey:key];
  [self.context deleteObject:item];
  [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger) fromIndex
                toIndex:(NSUInteger) toIndex
{
  if (fromIndex == toIndex) {
    return;
  }
  Item *item = self.privateItems[fromIndex];
  [self.privateItems removeObjectAtIndex:fromIndex];
  [self.privateItems insertObject:item atIndex:toIndex];
  
  double lowerBound = 0.0;
  
  if (toIndex > 0) {
    lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
  } else {
    lowerBound = [self.privateItems[1] orderingValue] - 2.0;
  }
  
  double upperBound = 0.0;
  
  if (toIndex < [self.privateItems count] -1) {
    upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
  } else {
    upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
  }
  
  double newOrderValue = (lowerBound + upperBound) / 2.0;
  
  NSLog(@"moving to order %f", newOrderValue);
  item.orderingValue = newOrderValue;
}

#pragma mark - Asset Types

- (NSArray *)allAssetTypes
{
  if (!_allAssetTypes) {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"AssetType"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request
                                                  error:&error];
    if (!result) {
      [NSException raise:@"Fetch failed"
                  format:@"Reason: %@", [error localizedDescription]];
    }
    _allAssetTypes = [result mutableCopy];
  }
  
  if ([_allAssetTypes count] == 0) {
    NSManagedObject *type;
    
    type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                         inManagedObjectContext:self.context];
    [type setValue:@"Furniture" forKey:@"label"];
    [_allAssetTypes addObject:type];
    
    type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                         inManagedObjectContext:self.context];
    [type setValue:@"Jewelry" forKey:@"label"];
    [_allAssetTypes addObject:type];
    
    type = [NSEntityDescription insertNewObjectForEntityForName:@"AssetType"
                                         inManagedObjectContext:self.context];
    [type setValue:@"Electronics" forKey:@"label"];
    [_allAssetTypes addObject:type];
  }
  return _allAssetTypes;
}

#pragma mark - Aromas

- (NSArray *)allAromas {
  
  if (!_allAromas) {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Aromas"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request
                                                  error:&error];
    if (!result) {
      [NSException raise:@"Fetch failed"
                  format:@"Reason: %@", [error localizedDescription]];
    }
    _allAromas = [result mutableCopy];
  }
  
  if ([_allAromas count] == 0) {
    NSManagedObject *aroma;
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                         inManagedObjectContext:self.context];
    [aroma setValue:@"Floral" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                         inManagedObjectContext:self.context];
    [aroma setValue:@"Green Fruit" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                         inManagedObjectContext:self.context];
    [aroma setValue:@"Citrus Fruit" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    [aroma setValue:@"Stone Fruit" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Tropical Fruit" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Red Fruit" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    [aroma setValue:@"Black Fruit" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dried Fruit" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Under-Ripeness" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbaceous" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbal" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Vegetable" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Sweet Spice" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Pungent Spice" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Neutrality" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Autolytic" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dairy" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Oak" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Kernal" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Animal" forKey:@"category"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Mineral" forKey:@"category"];
    [_allAromas addObject:aroma];
  }
  return _allAromas;
}

#pragma mark - Data Handling

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docuemtnDirectory = [documentDirectories firstObject];
    
    return [docuemtnDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
  NSError *error;
  BOOL successful = [self.context save:&error];
  if (!successful) {
    NSLog(@"Error saving: %@", [error localizedDescription]);
  }
  return successful;
}

- (void)loadAllItems
{
  if (!self.privateItems) {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Item"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    NSSortDescriptor *sd = [NSSortDescriptor
                            sortDescriptorWithKey:@"orderingValue"
                            ascending:YES];
    request.sortDescriptors = @[sd];
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request
                                                  error:&error];
    if (!result) {
      [NSException raise:@"Fetch failed"
                  format:@"Reason: %@", [error localizedDescription]];
    }
    
    self.privateItems = [[NSMutableArray alloc] initWithArray:result];
  }
}

@end
