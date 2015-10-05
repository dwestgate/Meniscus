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
  
  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [self removeAroma:[_tastes objectAtIndex:[indexPath row]] withCharacteristic:[_characteristics objectAtIndex:[indexPath row]]];
    
  } else {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self addAroma:[_tastes objectAtIndex:[indexPath row]] withCharacteristic:[_characteristics objectAtIndex:[indexPath row]]];
  }
}


- (void)addAroma:(NSString *)aroma withCharacteristic:(NSString *)characteristic {
  
  if ([_selectedAromas objectForKey:characteristic] == nil) {
    [_selectedAromas setObject:[NSMutableArray arrayWithObject:aroma] forKey:characteristic];
    [_selectedCharacteristics addObject:characteristic];
    [_selectedCategories addObject:_category];
  } else {
    [[_selectedAromas objectForKey:characteristic] addObject:aroma];
  }
  [self displaySelectedAromas];
}


- (void)removeAroma:(NSString *)aroma withCharacteristic:(NSString *)characteristic {
  
  if ([[_selectedAromas objectForKey:characteristic] count] > 1) {
    [[_selectedAromas objectForKey:characteristic] removeObject:aroma];
  } else {
    [_selectedAromas removeObjectForKey:characteristic];
    [_selectedCharacteristics removeObject:characteristic];
    [_selectedCategories removeObject:_category];
  }
  [self displaySelectedAromas];
}


- (Boolean)isAromaSelected:(NSString *)aroma withCharacteristic:(NSString *)characteristic {
  
  Boolean found = NO;
  
  if (!([_selectedAromas objectForKey:characteristic] == nil) && ([[_selectedAromas objectForKey:characteristic] containsObject:aroma])) {
    found = YES;
  }
  return found;
}


- (void)displaySelectedAromas {
  
  self.item.itemAromas = @"";
  if ([_selectedAromas count] > 0) {
    NSLog(@"Step 1: %@", self.item.itemAromas);
    for (NSString *key in _selectedCharacteristics) {
      self.item.itemAromas = [NSString stringWithFormat:@"%@ %@ aromas of ", self.item.itemAromas, key];
      NSLog(@"Step 2: %@", self.item.itemAromas);
      
      // if ([[_selectedAromas objectForKey:key] count] == 1)
      for (NSString *value in [_selectedAromas objectForKey:key]) {
        self.item.itemAromas = [NSString stringWithFormat:@"%@%@, ", self.item.itemAromas, value];
        NSLog(@"Step 3: %@", self.item.itemAromas);
      }
      
      self.item.itemAromas = [NSString stringWithFormat:@"%@; ", [self.item.itemAromas substringToIndex:[self.item.itemAromas length]-2]];
      NSLog(@"Step 4: %@", self.item.itemAromas);
    }
    self.item.itemAromas = [NSString stringWithFormat:@"%@", [self.item.itemAromas substringToIndex:[self.item.itemAromas length]-2]];
    self.item.itemAromas = [self.item.itemAromas stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"Step 5: %@", self.item.itemAromas);
  }
}

@end
