//
//  ItemStore.m
//  WineTastingJournal
//
//  Created by David Westgate on 6/15/15.
//  Copyright (c) 2015 Refabricants. All rights reserved.
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
    [aroma setValue:@"Acacia" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Floral" forKey:@"category"];
    [aroma setValue:@"Chamomile" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Floral" forKey:@"category"];
    [aroma setValue:@"Elderflower" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Floral" forKey:@"category"];
    [aroma setValue:@"Rose" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Floral" forKey:@"category"];
    [aroma setValue:@"Violet" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                         inManagedObjectContext:self.context];
    [aroma setValue:@"Green Fruit" forKey:@"category"];
    [aroma setValue:@"Apple" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Green Fruit" forKey:@"category"];
    [aroma setValue:@"Gooseberry" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Green Fruit" forKey:@"category"];
    [aroma setValue:@"Pear" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Green Fruit" forKey:@"category"];
    [aroma setValue:@"Grape" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                         inManagedObjectContext:self.context];
    [aroma setValue:@"Citrus Fruit" forKey:@"category"];
    [aroma setValue:@"Grapefruit" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Citrus Fruit" forKey:@"category"];
    [aroma setValue:@"Lemon" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Citrus Fruit" forKey:@"category"];
    [aroma setValue:@"Lime" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Stone Fruit" forKey:@"category"];
    [aroma setValue:@"Peach" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Stone Fruit" forKey:@"category"];
    [aroma setValue:@"Apricot" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Stone Fruit" forKey:@"category"];
    [aroma setValue:@"Nectarine" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Tropical Fruit" forKey:@"category"];
    [aroma setValue:@"Banana" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Tropical Fruit" forKey:@"category"];
    [aroma setValue:@"Kiwi" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Tropical Fruit" forKey:@"category"];
    [aroma setValue:@"Lychee" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Tropical Fruit" forKey:@"category"];
    [aroma setValue:@"Mango" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Tropical Fruit" forKey:@"category"];
    [aroma setValue:@"Melon" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Tropical Fruit" forKey:@"category"];
    [aroma setValue:@"Passion fruit" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Tropical Fruit" forKey:@"category"];
    [aroma setValue:@"Pineapple" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Red Fruit" forKey:@"category"];
    [aroma setValue:@"Redcurrant" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Red Fruit" forKey:@"category"];
    [aroma setValue:@"Cranberry" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Red Fruit" forKey:@"category"];
    [aroma setValue:@"Raspberry" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Red Fruit" forKey:@"category"];
    [aroma setValue:@"Strawberry" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Red Fruit" forKey:@"category"];
    [aroma setValue:@"Red cherry" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Red Fruit" forKey:@"category"];
    [aroma setValue:@"Plum" forKey:@"taste"];
    [_allAromas addObject:aroma];

    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Black Fruit" forKey:@"category"];
    [aroma setValue:@"Blackcurrent" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Black Fruit" forKey:@"category"];
    [aroma setValue:@"Blackberry" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Black Fruit" forKey:@"category"];
    [aroma setValue:@"Blueberry" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Black Fruit" forKey:@"category"];
    [aroma setValue:@"Black cherry" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dried Fruit" forKey:@"category"];
    [aroma setValue:@"Fig" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dried Fruit" forKey:@"category"];
    [aroma setValue:@"Prune" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dried Fruit" forKey:@"category"];
    [aroma setValue:@"Raisin" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dried Fruit" forKey:@"category"];
    [aroma setValue:@"Sultana" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dried Fruit" forKey:@"category"];
    [aroma setValue:@"Kirsch" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dried Fruit" forKey:@"category"];
    [aroma setValue:@"Stewed fruit" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Under-Ripeness" forKey:@"category"];
    [aroma setValue:@"Bell pepper" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Under-Ripeness" forKey:@"category"];
    [aroma setValue:@"Grass" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Under-Ripeness" forKey:@"category"];
    [aroma setValue:@"White pepper" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Under-Ripeness" forKey:@"category"];
    [aroma setValue:@"Greens" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Under-Ripeness" forKey:@"category"];
    [aroma setValue:@"Tomato" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Under-Ripeness" forKey:@"category"];
    [aroma setValue:@"Potato" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbaceous" forKey:@"category"];
    [aroma setValue:@"Grass" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbaceous" forKey:@"category"];
    [aroma setValue:@"Asparagus" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbaceous" forKey:@"category"];
    [aroma setValue:@"Blackcurrant leaf" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbal" forKey:@"category"];
    [aroma setValue:@"Eucalyptus" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbal" forKey:@"category"];
    [aroma setValue:@"Mint" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbal" forKey:@"category"];
    [aroma setValue:@"Medicine" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbal" forKey:@"category"];
    [aroma setValue:@"Lavender" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbal" forKey:@"category"];
    [aroma setValue:@"Fennel" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Herbal" forKey:@"category"];
    [aroma setValue:@"Dill" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Vegetable" forKey:@"category"];
    [aroma setValue:@"Cabbage" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Vegetable" forKey:@"category"];
    [aroma setValue:@"Peas" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Vegetable" forKey:@"category"];
    [aroma setValue:@"Beans" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Vegetable" forKey:@"category"];
    [aroma setValue:@"Olive" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Sweet Spice" forKey:@"category"];
    [aroma setValue:@"Cinnamon" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Sweet Spice" forKey:@"category"];
    [aroma setValue:@"Cloves" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Sweet Spice" forKey:@"category"];
    [aroma setValue:@"Ginger" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Sweet Spice" forKey:@"category"];
    [aroma setValue:@"Nutmeg" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Sweet Spice" forKey:@"category"];
    [aroma setValue:@"Vanilla" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Pungent Spice" forKey:@"category"];
    [aroma setValue:@"Black pepper" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Pungent Spice" forKey:@"category"];
    [aroma setValue:@"White pepper" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Pungent Spice" forKey:@"category"];
    [aroma setValue:@"Liquorice" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Pungent Spice" forKey:@"category"];
    [aroma setValue:@"Juniper" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Neutrality" forKey:@"category"];
    [aroma setValue:@"Simple" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Neutrality" forKey:@"category"];
    [aroma setValue:@"Neutral" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Neutrality" forKey:@"category"];
    [aroma setValue:@"Indistinct" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Autolytic" forKey:@"category"];
    [aroma setValue:@"Yeast" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Autolytic" forKey:@"category"];
    [aroma setValue:@"Biscuit" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Autolytic" forKey:@"category"];
    [aroma setValue:@"Bread" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Autolytic" forKey:@"category"];
    [aroma setValue:@"Toast" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Autolytic" forKey:@"category"];
    [aroma setValue:@"Lees" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dairy" forKey:@"category"];
    [aroma setValue:@"Butter" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dairy" forKey:@"category"];
    [aroma setValue:@"Cheese" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dairy" forKey:@"category"];
    [aroma setValue:@"Cream" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Dairy" forKey:@"category"];
    [aroma setValue:@"Yoghurt" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Oak" forKey:@"category"];
    [aroma setValue:@"Vanilla" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Oak" forKey:@"category"];
    [aroma setValue:@"Toast" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Oak" forKey:@"category"];
    [aroma setValue:@"Cedar" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Oak" forKey:@"category"];
    [aroma setValue:@"Charred wood" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Oak" forKey:@"category"];
    [aroma setValue:@"Smoke" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Oak" forKey:@"category"];
    [aroma setValue:@"Resin" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Kernal" forKey:@"category"];
    [aroma setValue:@"Almond" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Kernal" forKey:@"category"];
    [aroma setValue:@"Coconut" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Kernal" forKey:@"category"];
    [aroma setValue:@"Hazelnut" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Kernal" forKey:@"category"];
    [aroma setValue:@"Walnut" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Kernal" forKey:@"category"];
    [aroma setValue:@"Chocolate" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Kernal" forKey:@"category"];
    [aroma setValue:@"Coffee" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Vegetal" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Mushroom" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Hay" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Wet leaves" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Forest floor" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Game" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Savoury" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Tobacco" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Cedar" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Honey" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Maturity" forKey:@"category"];
    [aroma setValue:@"Cereal" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Animal" forKey:@"category"];
    [aroma setValue:@"Leather" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Animal" forKey:@"category"];
    [aroma setValue:@"Meaty" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Animal" forKey:@"category"];
    [aroma setValue:@"Farmyard" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Mineral" forKey:@"category"];
    [aroma setValue:@"Earth" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Mineral" forKey:@"category"];
    [aroma setValue:@"Petrol" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Mineral" forKey:@"category"];
    [aroma setValue:@"Rubber" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Mineral" forKey:@"category"];
    [aroma setValue:@"Tar" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Mineral" forKey:@"category"];
    [aroma setValue:@"Stone" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Mineral" forKey:@"category"];
    [aroma setValue:@"Steel" forKey:@"taste"];
    [_allAromas addObject:aroma];
    
    aroma = [NSEntityDescription insertNewObjectForEntityForName:@"Aromas"
                                          inManagedObjectContext:self.context];
    [aroma setValue:@"Mineral" forKey:@"category"];
    [aroma setValue:@"Wet wool" forKey:@"taste"];
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
