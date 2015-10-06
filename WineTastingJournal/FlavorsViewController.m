//
//  FlavorsViewController.m
//  WineTastingJournal
//
//  Created by David Westgate on 9/7/15.
//  Copyright (c) 2015 Refabricants. All rights reserved.
//

#import "FlavorsViewController.h"
#import "ItemStore.h"
#import "Item.h"

@implementation FlavorsViewController

- (instancetype)init {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.navigationItem.title = NSLocalizedString(@"Flavors", @"FlavorsViewController title");
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
  
  
  found = [self isFlavorSelected:[_tastes objectAtIndex:[indexPath row]] withCharacteristic:[_characteristics objectAtIndex:[indexPath row]]];
  
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
    
    [self removeFlavor:[_tastes objectAtIndex:[indexPath row]] withCharacteristic:[_characteristics objectAtIndex:[indexPath row]]];
    
  } else {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [self addFlavor:[_tastes objectAtIndex:[indexPath row]] withCharacteristic:[_characteristics objectAtIndex:[indexPath row]]];
  }
}


- (void)addFlavor:(NSString *)Flavor withCharacteristic:(NSString *)characteristic {
  
  if ([_selectedFlavors objectForKey:characteristic] == nil) {
    [_selectedFlavors setObject:[NSMutableArray arrayWithObject:Flavor] forKey:characteristic];
    [_selectedCharacteristics addObject:characteristic];
    [_selectedCategories addObject:_category];
  } else {
    [[_selectedFlavors objectForKey:characteristic] addObject:Flavor];
  }
  [self displaySelectedFlavors];
}


- (void)removeFlavor:(NSString *)Flavor withCharacteristic:(NSString *)characteristic {
  
  if ([[_selectedFlavors objectForKey:characteristic] count] > 1) {
    [[_selectedFlavors objectForKey:characteristic] removeObject:Flavor];
  } else {
    [_selectedFlavors removeObjectForKey:characteristic];
    [_selectedCharacteristics removeObject:characteristic];
    [_selectedCategories removeObject:_category];
  }
  [self displaySelectedFlavors];
}


- (Boolean)isFlavorSelected:(NSString *)Flavor withCharacteristic:(NSString *)characteristic {
  
  Boolean found = NO;
  
  if (!([_selectedFlavors objectForKey:characteristic] == nil) && ([[_selectedFlavors objectForKey:characteristic] containsObject:Flavor])) {
    found = YES;
  }
  return found;
}


- (void)displaySelectedFlavors {
  
  self.item.itemFlavors = @"";
  if ([_selectedFlavors count] > 0) {
    NSLog(@"Step 1: %@", self.item.itemFlavors);
    for (NSString *key in _selectedCharacteristics) {
      self.item.itemFlavors = [NSString stringWithFormat:@"%@ %@ of ", self.item.itemFlavors, key];
      NSLog(@"Step 2: %@", self.item.itemFlavors);
      
      NSInteger c = 1;
      NSInteger count = [[_selectedFlavors objectForKey:key] count];
      for (NSString *value in [_selectedFlavors objectForKey:key]) {
        if (count == 2 && c == 2) {
          self.item.itemFlavors = [NSString stringWithFormat:@"%@ and ", [self.item.itemFlavors substringToIndex:[self.item.itemFlavors length]-2]];
        } else if (count > 2 && (c == count)) {
          self.item.itemFlavors = [NSString stringWithFormat:@"%@and ", self.item.itemFlavors];
        }
        self.item.itemFlavors = [NSString stringWithFormat:@"%@%@, ", self.item.itemFlavors, value];
        
        c++;
        NSLog(@"Step 3: %@", self.item.itemFlavors);
      }
      
      self.item.itemFlavors = [NSString stringWithFormat:@"%@;", [self.item.itemFlavors substringToIndex:[self.item.itemFlavors length]-2]];
      NSLog(@"Step 4: %@", self.item.itemFlavors);
    }
    self.item.itemFlavors = [NSString stringWithFormat:@"%@", [self.item.itemFlavors substringToIndex:[self.item.itemFlavors length]-1]];
    self.item.itemFlavors = [self.item.itemFlavors stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.item.itemFlavors = [self.item.itemFlavors stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.item.itemFlavors substringToIndex:1] uppercaseString]];
    NSLog(@"Step 5: %@", self.item.itemFlavors);
  }
}

@end
