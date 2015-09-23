//
//  AromasViewController.m
//  WineTastingJournal
//
//  Created by David Westgate on 9/7/15.
//  Copyright (c) 2015 Refabricants. All rights reserved.
//

#import "AromasViewController.h"
#import "ItemStore.h"
#import "Item.h"

@interface AromasViewController ()

@property (nonatomic, strong) NSMutableDictionary *itemAromas;
@property (nonatomic, strong) NSMutableOrderedSet *order;

@end

@implementation AromasViewController

- (instancetype)init {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.navigationItem.title = NSLocalizedString(@"Aromas", @"AromasViewController title");
  }
  return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
  return [super initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return  [_tastes count];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
  
  cell.textLabel.text = [[self tastes] objectAtIndex:[indexPath row]];
  
  Boolean found = NO;
  
  
  found = [self isAromaSelected:[_tastes objectAtIndex:[indexPath row]] withCharacteristic:[_characteristics objectAtIndex:[indexPath row]]];
  
  if (found) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
  // NSArray *allTastes = [[ItemStore sharedStore] allTastes];
  // NSManagedObject *aroma = allTastes[indexPath.row];
  
  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [self removeAroma:[_tastes objectAtIndex:[indexPath row]] withCharacteristic:[_characteristics objectAtIndex:[indexPath row]]];
    
  } else {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self addAroma:[_tastes objectAtIndex:[indexPath row]] withCharacteristic:[_characteristics objectAtIndex:[indexPath row]]];
  }
  
  // self.item.itemAromas = [self.item.itemAromas stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
  // self.item.itemAromas = [self.item.itemAromas stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  // self.item.itemAromas = [self.item.itemAromas stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
}


- (Boolean)isAromaSelected:(NSString *)aroma withCharacteristic:(NSString *)characteristic {
  
  Boolean found = YES;
  NSString *lastInList;
  NSMutableDictionary *itemAromas = [[NSMutableDictionary alloc] init];
  NSMutableOrderedSet *order = [[NSMutableOrderedSet alloc] init];
  
  NSArray *groupings = [self.item.itemAromas componentsSeparatedByString: @");"];
  // groupings = "tropical fruit (banana, pear" , "red fruit (red apple, red cherry)"
  
  if ([[groupings objectAtIndex:0] length] > 0) {
    for (NSString *grouping in groupings) {
      NSMutableOrderedSet *components = [NSMutableOrderedSet orderedSetWithArray:[grouping componentsSeparatedByString:@"("]];
      // components[0] = "tropical fruit" , "banana, pear"
      // components[1] = "red fruit" , "red apple, red cherry)"
      
      [itemAromas setObject:[NSMutableArray arrayWithArray:[[components objectAtIndex:1] componentsSeparatedByString:@", "]] forKey:[components objectAtIndex:0]];
      // itemAromas = (key: "tropical fruit" , value: "banana, pear") , (key: "red fruit" , value: "red apple, cherry)")
      [order addObject:[components objectAtIndex:0]];
      // order = "tropical fruit", "red fruit"
    }
    
    lastInList = [itemAromas objectForKey:[order lastObject]];
    
    [itemAromas setObject:[lastInList substringToIndex:[lastInList length]-1] forKey:[order lastObject]];
    
  }
  
  if ([itemAromas objectForKey:characteristic] == nil) {
    found = NO;
  }
  return found;
}


- (void)addAroma:(NSString *)aroma withCharacteristic:(NSString *)characteristic {
  
  [self populateArrays];
  
  if ([_itemAromas objectForKey:characteristic] == nil) {
    [_itemAromas setObject:[NSMutableArray arrayWithObject:aroma] forKey:characteristic];
    [_order addObject:characteristic];
  } else {
    [[_itemAromas objectForKey:characteristic] addObject:aroma];
  }

  self.item.itemAromas = @"";
  NSLog(@"Step 1: %@", self.item.itemAromas);
  for (NSString *key in _order) {
    self.item.itemAromas = [NSString stringWithFormat:@"%@ %@ (", self.item.itemAromas, key];
    NSLog(@"Step 2: %@", self.item.itemAromas);
    for (NSString *value in [_itemAromas objectForKey:key]) {
      self.item.itemAromas = [NSString stringWithFormat:@"%@%@, ", self.item.itemAromas, value];
      NSLog(@"Step 3: %@", self.item.itemAromas);
    }
    self.item.itemAromas = [NSString stringWithFormat:@"%@); ", [self.item.itemAromas substringToIndex:[self.item.itemAromas length]-2]];
          NSLog(@"Step 4: %@", self.item.itemAromas);
  }
  self.item.itemAromas = [NSString stringWithFormat:@"%@", [self.item.itemAromas substringToIndex:[self.item.itemAromas length]-2]];
  self.item.itemAromas = [self.item.itemAromas stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  NSLog(@"Step 5: %@", self.item.itemAromas);
}

- (void)removeAroma:(NSString *)aroma withCharacteristic:(NSString *)characteristic {

  self.item.itemAromas = [NSString stringWithFormat:@"%@, %@", self.item.itemAromas, aroma];
}

- (void)populateArrays {
  _itemAromas = [[NSMutableDictionary alloc] init];
  _order = [[NSMutableOrderedSet alloc] init];
  
  NSArray *groupings = [self.item.itemAromas componentsSeparatedByString: @");"];
  // groupings = "tropical fruit (banana, pear" , "red fruit (red apple, red cherry)"
  
  if ([[groupings objectAtIndex:0] length] > 0) {
    for (NSString *grouping in groupings) {
      NSMutableOrderedSet *components = [NSMutableOrderedSet orderedSetWithArray:[grouping componentsSeparatedByString:@"("]];
      // components[0] = "tropical fruit" , "banana, pear"
      // components[1] = "red fruit" , "red apple, red cherry)"
      
      components[0] = [components[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
      components[1] = [components[1] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
      
      [_itemAromas setObject:[NSMutableArray arrayWithArray:[[components objectAtIndex:1] componentsSeparatedByString:@", "]] forKey:[components objectAtIndex:0]];
      // itemAromas = (key: "tropical fruit" , value: "banana, pear") , (key: "red fruit" , value: "red apple, cherry)")
      [_order addObject:[components objectAtIndex:0]];
      // order = "tropical fruit", "red fruit"
    }
  }
}

@end
