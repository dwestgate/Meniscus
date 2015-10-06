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
      
      _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
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
  double order = 1.0;

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
  item.itemMeniscus = [defaults objectForKey:NextItemMeniscusPrefsKey];
  item.itemMeniscusValue = [[defaults objectForKey:NextItemMeniscusValuePrefsKey] intValue];
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
  item.itemAlcohol = [defaults objectForKey:NextItemAlcoholPrefsKey];
  item.itemAlcoholValue = [[defaults objectForKey:NextItemAlcoholValuePrefsKey] intValue];
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
  
  [self.privateItems insertObject:item atIndex:0];
  
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

    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"tropical aromas" forKey:@"characteristic"];
    [taste setValue:@"banana" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"tropical aromas" forKey:@"characteristic"];
    [taste setValue:@"coconut" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"tropical aromas" forKey:@"characteristic"];
    [taste setValue:@"kiwi" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"tropical aromas" forKey:@"characteristic"];
    [taste setValue:@"lychee" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"tropical aromas" forKey:@"characteristic"];
    [taste setValue:@"mango" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"tropical aromas" forKey:@"characteristic"];
    [taste setValue:@"melon" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"tropical aromas" forKey:@"characteristic"];
    [taste setValue:@"passion fruit" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"tropical aromas" forKey:@"characteristic"];
    [taste setValue:@"pineapple" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"tropical aromas" forKey:@"characteristic"];
    [taste setValue:@"vanilla" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"citrus aromas" forKey:@"characteristic"];
    [taste setValue:@"grapefruit" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"citrus aromas" forKey:@"characteristic"];
    [taste setValue:@"lemon" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"citrus aromas" forKey:@"characteristic"];
    [taste setValue:@"lime" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@0 forKey:@"categoryOrder"];
    [taste setValue:@"Citrus and tropical notes" forKey:@"category"];
    [taste setValue:@"citrus aromas" forKey:@"characteristic"];
    [taste setValue:@"orange" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruit and stone fruit notes" forKey:@"category"];
    [taste setValue:@"green fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"apple" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruit and stone fruit notes" forKey:@"category"];
    [taste setValue:@"green fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"gooseberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruit and stone fruit notes" forKey:@"category"];
    [taste setValue:@"green fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"grape" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruit and stone fruit notes" forKey:@"category"];
    [taste setValue:@"green fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"muscat" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruit and stone fruit notes" forKey:@"category"];
    [taste setValue:@"green fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"pear" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruit and stone fruit notes" forKey:@"category"];
    [taste setValue:@"green fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"quince" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruit and stone fruit notes" forKey:@"category"];
    [taste setValue:@"stone fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"apricot" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruit and stone fruit notes" forKey:@"category"];
    [taste setValue:@"stone fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"nectarine" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@1 forKey:@"categoryOrder"];
    [taste setValue:@"Green fruit and stone fruit notes" forKey:@"category"];
    [taste setValue:@"stone fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"peach" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Dark fruit and red fruit" forKey:@"category"];
    [taste setValue:@"dark fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"blackberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Dark fruit and red fruit" forKey:@"category"];
    [taste setValue:@"dark fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"blueberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Dark fruit and red fruit" forKey:@"category"];
    [taste setValue:@"dark fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"cassis" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Dark fruit and red fruit" forKey:@"category"];
    [taste setValue:@"dark fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"cherry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Dark fruit and red fruit" forKey:@"category"];
    [taste setValue:@"red fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"cherry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Dark fruit and red fruit" forKey:@"category"];
    [taste setValue:@"red fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"cranberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Dark fruit and red fruit" forKey:@"category"];
    [taste setValue:@"red fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"plum" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Dark fruit and red fruit" forKey:@"category"];
    [taste setValue:@"red fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"raspberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Dark fruit and red fruit" forKey:@"category"];
    [taste setValue:@"red fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"redcurrant" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@2 forKey:@"categoryOrder"];
    [taste setValue:@"Dark fruit and red fruit" forKey:@"category"];
    [taste setValue:@"red fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"strawberry" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Dried fruit, baked fruit, and candy" forKey:@"category"];
    [taste setValue:@"dried fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"fig" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Dried fruit, baked fruit, and candy" forKey:@"category"];
    [taste setValue:@"dried fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"kirsch" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Dried fruit, baked fruit, and candy" forKey:@"category"];
    [taste setValue:@"dried fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"prune" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Dried fruit, baked fruit, and candy" forKey:@"category"];
    [taste setValue:@"dried fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"raisin" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Dried fruit, baked fruit, and candy" forKey:@"category"];
    [taste setValue:@"dried fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"sultana" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Dried fruit, baked fruit, and candy" forKey:@"category"];
    [taste setValue:@"baked fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"apple" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Dried fruit, baked fruit, and candy" forKey:@"category"];
    [taste setValue:@"baked fruit aromas" forKey:@"characteristic"];
    [taste setValue:@"stewed fruit" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Dried fruit, baked fruit, and candy" forKey:@"category"];
    [taste setValue:@"sweet notes" forKey:@"characteristic"];
    [taste setValue:@"cotton candy" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Dried fruit, baked fruit, and candy" forKey:@"category"];
    [taste setValue:@"sweet notes" forKey:@"characteristic"];
    [taste setValue:@"bubble gum" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@3 forKey:@"categoryOrder"];
    [taste setValue:@"Dried fruit, baked fruit, and candy" forKey:@"category"];
    [taste setValue:@"sweet notes" forKey:@"characteristic"];
    [taste setValue:@"cola" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"floral notes" forKey:@"characteristic"];
    [taste setValue:@"acacia" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"floral notes" forKey:@"characteristic"];
    [taste setValue:@"chamomile" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"floral notes" forKey:@"characteristic"];
    [taste setValue:@"elderflower" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"floral notes" forKey:@"characteristic"];
    [taste setValue:@"geranium" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"floral notes" forKey:@"characteristic"];
    [taste setValue:@"hawthorn" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"floral notes" forKey:@"characteristic"];
    [taste setValue:@"honey" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"floral notes" forKey:@"characteristic"];
    [taste setValue:@"lavender" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"floral notes" forKey:@"characteristic"];
    [taste setValue:@"linden" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"floral notes" forKey:@"characteristic"];
    [taste setValue:@"rose" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"floral notes" forKey:@"characteristic"];
    [taste setValue:@"violet" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"herbal notes" forKey:@"characteristic"];
    [taste setValue:@"dill" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"herbal notes" forKey:@"characteristic"];
    [taste setValue:@"eucalyptus" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"herbal notes" forKey:@"characteristic"];
    [taste setValue:@"fennel" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"herbal notes" forKey:@"characteristic"];
    [taste setValue:@"mint" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@4 forKey:@"categoryOrder"];
    [taste setValue:@"Floral and herbal notes" forKey:@"category"];
    [taste setValue:@"herbal notes" forKey:@"characteristic"];
    [taste setValue:@"sage" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"brick" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"chalk" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"charcoal" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"concrete" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"earth" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"flint" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"graphite" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"gravel" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"pencil lead" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"slate" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"steel" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"mineral notes" forKey:@"characteristic"];
    [taste setValue:@"wet stone" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"petroleum smells" forKey:@"characteristic"];
    [taste setValue:@"diesel" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"petroleum smells" forKey:@"characteristic"];
    [taste setValue:@"new plastic" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"petroleum smells" forKey:@"characteristic"];
    [taste setValue:@"petrol" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"petroleum smells" forKey:@"characteristic"];
    [taste setValue:@"rubber" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"petroleum smells" forKey:@"characteristic"];
    [taste setValue:@"tar" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@5 forKey:@"categoryOrder"];
    [taste setValue:@"Minerality and petroleum notes" forKey:@"category"];
    [taste setValue:@"petroleum smells" forKey:@"characteristic"];
    [taste setValue:@"wet asphalt" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"toasty notes" forKey:@"characteristic"];
    [taste setValue:@"caramel" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"toasty notes" forKey:@"characteristic"];
    [taste setValue:@"charred wood" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"toasty notes" forKey:@"characteristic"];
    [taste setValue:@"coffee" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"toasty notes" forKey:@"characteristic"];
    [taste setValue:@"dark chocolate" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"toasty notes" forKey:@"characteristic"];
    [taste setValue:@"roasted almond" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"toasty notes" forKey:@"characteristic"];
    [taste setValue:@"roasted hazelnut" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"toasty notes" forKey:@"characteristic"];
    [taste setValue:@"smoke" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"toasty notes" forKey:@"characteristic"];
    [taste setValue:@"toast" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"toasty notes" forKey:@"characteristic"];
    [taste setValue:@"walnut" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"woody notes" forKey:@"characteristic"];
    [taste setValue:@"cedar" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"woody notes" forKey:@"characteristic"];
    [taste setValue:@"oaky" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"woody notes" forKey:@"characteristic"];
    [taste setValue:@"pine" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@6 forKey:@"categoryOrder"];
    [taste setValue:@"Woody, nutty, and toasty notes" forKey:@"category"];
    [taste setValue:@"woody notes" forKey:@"characteristic"];
    [taste setValue:@"resin" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"anise" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"black pepper" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"juniper" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"liquorice" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"menthol" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"white pepper" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"cinnamon" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"clove" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"ginger" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"nutmeg" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"saffron" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@7 forKey:@"categoryOrder"];
    [taste setValue:@"Spicy notes" forKey:@"category"];
    [taste setValue:@"spicy aromas" forKey:@"characteristic"];
    [taste setValue:@"vanilla" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"animal notes" forKey:@"characteristic"];
    [taste setValue:@"barnyard" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"animal notes" forKey:@"characteristic"];
    [taste setValue:@"farmyard" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"animal notes" forKey:@"characteristic"];
    [taste setValue:@"forest-floor" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"animal notes" forKey:@"characteristic"];
    [taste setValue:@"leather" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"animal notes" forKey:@"characteristic"];
    [taste setValue:@"musk" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"animal notes" forKey:@"characteristic"];
    [taste setValue:@"old saddle leather" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"animal notes" forKey:@"characteristic"];
    [taste setValue:@"wet wool" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"savory notes" forKey:@"characteristic"];
    [taste setValue:@"bacon fat" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"savory notes" forKey:@"characteristic"];
    [taste setValue:@"salami" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"savory notes" forKey:@"characteristic"];
    [taste setValue:@"tobacco" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@8 forKey:@"categoryOrder"];
    [taste setValue:@"Savory and Animal notes" forKey:@"category"];
    [taste setValue:@"savory notes" forKey:@"characteristic"];
    [taste setValue:@"truffle" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Yeast notes" forKey:@"category"];
    [taste setValue:@"yeasty aromas" forKey:@"characteristic"];
    [taste setValue:@"biscuit" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Yeast notes" forKey:@"category"];
    [taste setValue:@"yeasty aromas" forKey:@"characteristic"];
    [taste setValue:@"rising bread" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Yeast notes" forKey:@"category"];
    [taste setValue:@"yeasty aromas" forKey:@"characteristic"];
    [taste setValue:@"buttery" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Yeast notes" forKey:@"category"];
    [taste setValue:@"yeasty aromas" forKey:@"characteristic"];
    [taste setValue:@"cheese" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Yeast notes" forKey:@"category"];
    [taste setValue:@"yeasty aromas" forKey:@"characteristic"];
    [taste setValue:@"sweet cream" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Yeast notes" forKey:@"category"];
    [taste setValue:@"yeasty aromas" forKey:@"characteristic"];
    [taste setValue:@"lees" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@9 forKey:@"categoryOrder"];
    [taste setValue:@"Yeast notes" forKey:@"category"];
    [taste setValue:@"yeasty aromas" forKey:@"characteristic"];
    [taste setValue:@"sourdough" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"herbaceous notes" forKey:@"characteristic"];
    [taste setValue:@"cut hay" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"herbaceous notes" forKey:@"characteristic"];
    [taste setValue:@"freshly cut grass" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"herbaceous notes" forKey:@"characteristic"];
    [taste setValue:@"stalk" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"herbaceous notes" forKey:@"characteristic"];
    [taste setValue:@"stem" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"vegetal notes" forKey:@"characteristic"];
    [taste setValue:@"asparagus" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"vegetal notes" forKey:@"characteristic"];
    [taste setValue:@"cabbage" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"vegetal notes" forKey:@"characteristic"];
    [taste setValue:@"canned peas" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"vegetal notes" forKey:@"characteristic"];
    [taste setValue:@"green bean" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"vegetal notes" forKey:@"characteristic"];
    [taste setValue:@"green olive" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"vegetal notes" forKey:@"characteristic"];
    [taste setValue:@"green pepper" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@10 forKey:@"categoryOrder"];
    [taste setValue:@"Herbaceous and vegetal notes" forKey:@"category"];
    [taste setValue:@"vegetal notes" forKey:@"characteristic"];
    [taste setValue:@"mushroom" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"antiseptic" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"cat’s pee" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"cork" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"glue" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"green pepper" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"horse" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"moldy earth" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"nail polish remover" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"onion" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"rotten apple" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"rotten egg" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"soap" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"sulpher" forKey:@"taste"];
    [_allTastes addObject:taste];
    
    taste = [NSEntityDescription insertNewObjectForEntityForName:@"Tastes" inManagedObjectContext:self.context];
    [taste setValue:@11 forKey:@"categoryOrder"];
    [taste setValue:@"Faults" forKey:@"category"];
    [taste setValue:@"off-putting smells" forKey:@"characteristic"];
    [taste setValue:@"vinegar" forKey:@"taste"];
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
