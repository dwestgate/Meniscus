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
@property (nonatomic, strong) NSMutableArray *allTastes;
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

- (NSArray *)allTastes {
  
  if (!_allTastes) {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Tastes"
                                         inManagedObjectContext:self.context];
    request.entity = e;
    
    NSError *error;
    NSArray *result = [self.context executeFetchRequest:request
                                                  error:&error];
    if (!result) {
      [NSException raise:@"Fetch failed"
                  format:@"Reason: %@", [error localizedDescription]];
    }
    _allTastes = [result mutableCopy];
  }
  
  if ([_allTastes count] == 0) {
    NSManagedObject *taste;

    //
    // 0 - Herbal and floral (Aromas: herbal (acacia, chamomile); floral (dill
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Herbal and floral" forKey:@"category"];
    [taste setValue:@"floral" forKey:@"characteristic"];
    [taste setValue:@"acacia" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Herbal and floral" forKey:@"category"];
    [taste setValue:@"herbal" forKey:@"characteristic"];
    [taste setValue:@"dill" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Herbal and floral" forKey:@"category"];
    [taste setValue:@"floral" forKey:@"characteristic"];
    [taste setValue:@"chamomile" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Herbal and floral" forKey:@"category"];
    [taste setValue:@"floral" forKey:@"characteristic"];
    [taste setValue:@"elderflower" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Herbal and floral" forKey:@"category"];
    [taste setValue:@"herbal" forKey:@"characteristic"];
    [taste setValue:@"eucalyptus" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Herbal and floral" forKey:@"category"];
    [taste setValue:@"floral" forKey:@"characteristic"];
    [taste setValue:@"lavender" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Herbal and floral" forKey:@"category"];
    [taste setValue:@"herbal" forKey:@"characteristic"];
    [taste setValue:@"fennel" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Herbal and floral" forKey:@"category"];
    [taste setValue:@"herbal" forKey:@"characteristic"];
    [taste setValue:@"mint" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Herbal and floral" forKey:@"category"];
    [taste setValue:@"floral" forKey:@"characteristic"];
    [taste setValue:@"rose" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Herbal and floral" forKey:@"category"];
    [taste setValue:@"floral" forKey:@"characteristic"];
    [taste setValue:@"violet" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 1 - Citrus and tropical fruits
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical fruits" forKey:@"category"];
    [taste setValue:@"citrus" forKey:@"characteristic"];
    [taste setValue:@"grapefruit" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical fruits" forKey:@"category"];
    [taste setValue:@"citrus" forKey:@"characteristic"];
    [taste setValue:@"lemon" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical fruits" forKey:@"category"];
    [taste setValue:@"citrus" forKey:@"characteristic"];
    [taste setValue:@"lime" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical fruits" forKey:@"category"];
    [taste setValue:@"." forKey:@"characteristic"];
    [taste setValue:@"banana" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical fruits" forKey:@"category"];
    [taste setValue:@"tropical fruit" forKey:@"characteristic"];
    [taste setValue:@"kiwi" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical fruits" forKey:@"category"];
    [taste setValue:@"tropical fruit" forKey:@"characteristic"];
    [taste setValue:@"lychee" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical fruits" forKey:@"category"];
    [taste setValue:@"tropical fruit" forKey:@"characteristic"];
    [taste setValue:@"mango" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical fruits" forKey:@"category"];
    [taste setValue:@"tropical fruit" forKey:@"characteristic"];
    [taste setValue:@"melon" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical fruits" forKey:@"category"];
    [taste setValue:@"tropical fruit" forKey:@"characteristic"];
    [taste setValue:@"passion fruit" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical fruits" forKey:@"category"];
    [taste setValue:@"tropical fruit" forKey:@"characteristic"];
    [taste setValue:@"pineapple" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 2 - Green fruits and stone fruits
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruits and stone fruits" forKey:@"category"];
    [taste setValue:@"stone fruit" forKey:@"characteristic"];
    [taste setValue:@"nectarine" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruits and stone fruits" forKey:@"category"];
    [taste setValue:@"." forKey:@"characteristic"];
    [taste setValue:@"apple" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruits and stone fruits" forKey:@"category"];
    [taste setValue:@"." forKey:@"characteristic"];
    [taste setValue:@"gooseberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruits and stone fruits" forKey:@"category"];
    [taste setValue:@"." forKey:@"characteristic"];
    [taste setValue:@"pear" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruits and stone fruits" forKey:@"category"];
    [taste setValue:@"." forKey:@"characteristic"];
    [taste setValue:@"grape" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruits and stone fruits" forKey:@"category"];
    [taste setValue:@"stone fruit" forKey:@"characteristic"];
    [taste setValue:@"peach" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruits and stone fruits" forKey:@"category"];
    [taste setValue:@"stone fruit" forKey:@"characteristic"];
    [taste setValue:@"apricot" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 3 - Red and black fruits
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Red and black fruits" forKey:@"category"];
    [taste setValue:@"red fruit" forKey:@"characteristic"];
    [taste setValue:@"redcurrant" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Red and black fruits" forKey:@"category"];
    [taste setValue:@"red fruit" forKey:@"characteristic"];
    [taste setValue:@"cranberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Red and black fruits" forKey:@"category"];
    [taste setValue:@"red fruit" forKey:@"characteristic"];
    [taste setValue:@"raspberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Red and black fruits" forKey:@"category"];
    [taste setValue:@"." forKey:@"characteristic"];
    [taste setValue:@"strawberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Red and black fruits" forKey:@"category"];
    [taste setValue:@"red fruit" forKey:@"characteristic"];
    [taste setValue:@"red cherry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Red and black fruits" forKey:@"category"];
    [taste setValue:@"red fruit" forKey:@"characteristic"];
    [taste setValue:@"plum" forKey:@"taste"];
    [_allTastes addObject:taste];

    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Red and black fruits" forKey:@"category"];
    [taste setValue:@"black fruit" forKey:@"characteristic"];
    [taste setValue:@"blackcurrent" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Red and black fruits" forKey:@"category"];
    [taste setValue:@"black fruit" forKey:@"characteristic"];
    [taste setValue:@"blackberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Red and black fruits" forKey:@"category"];
    [taste setValue:@"black fruit" forKey:@"characteristic"];
    [taste setValue:@"blueberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Red and black fruits" forKey:@"category"];
    [taste setValue:@"black fruit" forKey:@"characteristic"];
    [taste setValue:@"black cherry" forKey:@"taste"];
    [_allTastes addObject:taste];

    //
    // 4 - Dried fruits
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Dried/baked fruit" forKey:@"category"];
    [taste setValue:@"dried fruit" forKey:@"characteristic"];
    [taste setValue:@"fig" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Dried/baked fruit" forKey:@"category"];
    [taste setValue:@"dried fruit" forKey:@"characteristic"];
    [taste setValue:@"prune" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Dried/baked fruit" forKey:@"category"];
    [taste setValue:@"dried fruit" forKey:@"characteristic"];
    [taste setValue:@"raisin" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Dried/baked fruit" forKey:@"category"];
    [taste setValue:@"dried fruit" forKey:@"characteristic"];
    [taste setValue:@"sultana" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Dried/baked fruit" forKey:@"category"];
    [taste setValue:@"dried fruit" forKey:@"characteristic"];
    [taste setValue:@"kirsch" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Dried/baked fruit" forKey:@"category"];
    [taste setValue:@"baked fruit" forKey:@"characteristic"];
    [taste setValue:@"stewed fruit" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Dried/baked fruit" forKey:@"category"];
    [taste setValue:@"bakekd fruit" forKey:@"characteristic"];
    [taste setValue:@"baked apple" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 5 - Vegetal and herbaceous
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Vegetal and herbaceous" forKey:@"category"];
    [taste setValue:@"vegetal" forKey:@"characteristic"];
    [taste setValue:@"cabbage" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Vegetal and herbaceous" forKey:@"category"];
    [taste setValue:@"vegetal" forKey:@"characteristic"];
    [taste setValue:@"peas" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Vegetal and herbaceous" forKey:@"category"];
    [taste setValue:@"vegetal" forKey:@"characteristic"];
    [taste setValue:@"beans" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Vegetal and herbaceous" forKey:@"category"];
    [taste setValue:@"vegetal" forKey:@"characteristic"];
    [taste setValue:@"olive" forKey:@"taste"];
    [_allTastes addObject:taste];

    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Vegetal and herbaceous" forKey:@"category"];
    [taste setValue:@"herbaceous" forKey:@"characteristic"];
    [taste setValue:@"grass" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Vegetal and herbaceous" forKey:@"category"];
    [taste setValue:@"herbaceous" forKey:@"characteristic"];
    [taste setValue:@"asparagus" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Vegetal and herbaceous" forKey:@"category"];
    [taste setValue:@"herbaceous" forKey:@"characteristic"];
    [taste setValue:@"blackcurrant leaf" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 7 - Spices
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Spices" forKey:@"category"];
    [taste setValue:@"sweet spice" forKey:@"characteristic"];
    [taste setValue:@"cinnamon" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Spices" forKey:@"category"];
    [taste setValue:@"sweet spice" forKey:@"characteristic"];
    [taste setValue:@"clove" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Spices" forKey:@"category"];
    [taste setValue:@"sweet spice" forKey:@"characteristic"];
    [taste setValue:@"ginger" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Spices" forKey:@"category"];
    [taste setValue:@"sweet spice" forKey:@"characteristic"];
    [taste setValue:@"nutmeg" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Spices" forKey:@"category"];
    [taste setValue:@"sweet spice" forKey:@"characteristic"];
    [taste setValue:@"vanilla" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Spices" forKey:@"category"];
    [taste setValue:@"pungent spice" forKey:@"characteristic"];
    [taste setValue:@"black pepper" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Spices" forKey:@"category"];
    [taste setValue:@"pungent spice" forKey:@"characteristic"];
    [taste setValue:@"white pepper" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Spices" forKey:@"category"];
    [taste setValue:@"pungent spice" forKey:@"characteristic"];
    [taste setValue:@"anise" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Spices" forKey:@"category"];
    [taste setValue:@"pungent spice" forKey:@"characteristic"];
    [taste setValue:@"liquorice" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Spices" forKey:@"category"];
    [taste setValue:@"pungent spice" forKey:@"characteristic"];
    [taste setValue:@"juniper" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 7 - Animal and dairy
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Animal and dairy" forKey:@"category"];
    [taste setValue:@"dairy" forKey:@"characteristic"];
    [taste setValue:@"butter" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Animal and dairy" forKey:@"category"];
    [taste setValue:@"dairy" forKey:@"characteristic"];
    [taste setValue:@"cheese" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Animal and dairy" forKey:@"category"];
    [taste setValue:@"dairy" forKey:@"characteristic"];
    [taste setValue:@"cream" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Animal and dairy" forKey:@"category"];
    [taste setValue:@"dairy" forKey:@"characteristic"];
    [taste setValue:@"yoghurt" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Animal and dairy" forKey:@"category"];
    [taste setValue:@"animal" forKey:@"characteristic"];
    [taste setValue:@"leather" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Animal and dairy" forKey:@"category"];
    [taste setValue:@"animal" forKey:@"characteristic"];
    [taste setValue:@"meaty" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Animal and dairy" forKey:@"category"];
    [taste setValue:@"animal" forKey:@"characteristic"];
    [taste setValue:@"bacon fat" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Animal and dairy" forKey:@"category"];
    [taste setValue:@"animal" forKey:@"characteristic"];
    [taste setValue:@"farmyard" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 8 - Minerality
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality" forKey:@"category"];
    [taste setValue:@"minerality" forKey:@"characteristic"];
    [taste setValue:@"earth" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality" forKey:@"category"];
    [taste setValue:@"minerality" forKey:@"characteristic"];
    [taste setValue:@"petrol" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality" forKey:@"category"];
    [taste setValue:@"minerality" forKey:@"characteristic"];
    [taste setValue:@"rubber" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality" forKey:@"category"];
    [taste setValue:@"minerality" forKey:@"characteristic"];
    [taste setValue:@"tar" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality" forKey:@"category"];
    [taste setValue:@"minerality" forKey:@"characteristic"];
    [taste setValue:@"wet stone" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality" forKey:@"category"];
    [taste setValue:@"minerality" forKey:@"characteristic"];
    [taste setValue:@"steel" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality" forKey:@"category"];
    [taste setValue:@"minerality" forKey:@"characteristic"];
    [taste setValue:@"wet wool" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 9 - Nutty and bready
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"bready" forKey:@"characteristic"];
    [taste setValue:@"yeast" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"bready" forKey:@"characteristic"];
    [taste setValue:@"biscuit" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"bready" forKey:@"characteristic"];
    [taste setValue:@"bread" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"bready" forKey:@"characteristic"];
    [taste setValue:@"toast" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"bready" forKey:@"characteristic"];
    [taste setValue:@"lees" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"nutty" forKey:@"characteristic"];
    [taste setValue:@"almond" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"nutty" forKey:@"characteristic"];
    [taste setValue:@"coconut" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"nutty" forKey:@"characteristic"];
    [taste setValue:@"hazelnut" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"nutty" forKey:@"characteristic"];
    [taste setValue:@"walnut" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"." forKey:@"characteristic"];
    [taste setValue:@"chocolate" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Nutty and bready" forKey:@"category"];
    [taste setValue:@"." forKey:@"characteristic"];
    [taste setValue:@"coffee" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 10 - Oak
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Oak" forKey:@"category"];
    [taste setValue:@"oaky" forKey:@"characteristic"];
    [taste setValue:@"vanilla" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Oak" forKey:@"category"];
    [taste setValue:@"oaky" forKey:@"characteristic"];
    [taste setValue:@"toast" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Oak" forKey:@"category"];
    [taste setValue:@"oaky" forKey:@"characteristic"];
    [taste setValue:@"cedar" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Oak" forKey:@"category"];
    [taste setValue:@"oaky" forKey:@"characteristic"];
    [taste setValue:@"charred wood" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Oak" forKey:@"category"];
    [taste setValue:@"oaky" forKey:@"characteristic"];
    [taste setValue:@"smoke" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Oak" forKey:@"category"];
    [taste setValue:@"oaky" forKey:@"characteristic"];
    [taste setValue:@"resin" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 11 - Ripeness/maturity characteristics
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"un-ripeness" forKey:@"characteristic"];
    [taste setValue:@"bell pepper" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"un-ripeness" forKey:@"characteristic"];
    [taste setValue:@"grass" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"un-ripeness" forKey:@"characteristic"];
    [taste setValue:@"white pepper" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"un-ripeness" forKey:@"characteristic"];
    [taste setValue:@"leafiness" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"un-ripeness" forKey:@"characteristic"];
    [taste setValue:@"tomato" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"un-ripeness" forKey:@"characteristic"];
    [taste setValue:@"potato" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"vegetal" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"mushroom" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"hay" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"wet leaves" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"forest floor" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"game" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"savoury" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"tobacco" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"cedar" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"honey" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Ripeness/maturity characteristics" forKey:@"category"];
    [taste setValue:@"maturity" forKey:@"characteristic"];
    [taste setValue:@"cereal" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    //
    // 12 - Other
    //
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes"
                                          inManagedObjectContext:self.context];
    [taste setValue:@12 forKey:@"categoryOrder"];
    [taste setValue:@"Other" forKey:@"category"];
    [taste setValue:@"." forKey:@"characteristic"];
    [taste setValue:@"medicinal" forKey:@"taste"];
    [_allTastes addObject:taste];
  }
  return _allTastes;
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
