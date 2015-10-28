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
  
  NSString *label = [[self tastes] objectAtIndex:[indexPath row]];
  
  cell.textLabel.text = [self capitalize:label];
  
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
    for (NSString *key in _selectedCharacteristics) {
      
      NSString *text = @"";
      
      if (![key isEqualToString:@"general aromas"]) {
        text = [NSString stringWithFormat:@"%@ of ", key];
      }
      
      NSInteger c = 1;
      NSInteger count = [[_selectedAromas objectForKey:key] count];
      for (NSString *value in [_selectedAromas objectForKey:key]) {
        if (count == 2 && c == 2) {
          text = [NSString stringWithFormat:@"%@ and ", [text substringToIndex:[text length]-2]];
        } else if (count > 2 && (c == count)) {
          text = [NSString stringWithFormat:@"%@and ", text];
        }
        text = [NSString stringWithFormat:@"%@%@, ", text, value];
        
        c++;
      }
      
      if ([key isEqualToString:@"general aromas"]) {
        self.item.itemAromas = [NSString stringWithFormat:@"%@ aromas; %@", [text substringToIndex:[text length]-2], self.item.itemAromas];
      } else {
        self.item.itemAromas = [NSString stringWithFormat:@"%@%@; ", self.item.itemAromas, [text substringToIndex:[text length]-2]];
      }
      
    }
    self.item.itemAromas = [NSString stringWithFormat:@"%@", [self.item.itemAromas substringToIndex:[self.item.itemAromas length]-2]];
    self.item.itemAromas = [self.item.itemAromas stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.item.itemAromas = [self.item.itemAromas stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self.item.itemAromas substringToIndex:1] uppercaseString]];
  }
}

-(NSString *)capitalize:(NSString *)string {
  return [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[string substringToIndex:1] uppercaseString]];
}

@end
