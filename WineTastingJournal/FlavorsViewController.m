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
  
  return  [[[ItemStore sharedStore] allAromas] count];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
  
  NSArray *allFlavors = [[ItemStore sharedStore] allAromas];
  NSManagedObject *flavor = allFlavors[indexPath.row];
  
  NSString *flavorCategory = [flavor valueForKey:@"category"];
  cell.textLabel.text = flavorCategory;
  
  Boolean found = NO;
  
  for (NSString *itemFlavor in [self FlavorsArrayFromString]) {
    if ([[flavor valueForKey:@"category"] isEqualToString:itemFlavor]) {
      found = YES;
      break;
    }
  }
  
  if (found) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
  NSArray *allFlavors = [[ItemStore sharedStore] allAromas];
  NSManagedObject *flavor = allFlavors[indexPath.row];
  
  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    self.item.itemFlavors = [self.item.itemFlavors stringByReplacingOccurrencesOfString:[flavor valueForKey:@"category"] withString:@""];
    self.item.itemFlavors = [self.item.itemFlavors stringByReplacingOccurrencesOfString:@", , " withString:@", "];
  } else {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.item.itemFlavors = [NSString stringWithFormat:@"%@, %@", self.item.itemFlavors, [flavor valueForKey:@"category"]];
  }
  
  self.item.itemFlavors = [self.item.itemFlavors stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
  self.item.itemFlavors = [self.item.itemFlavors stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  self.item.itemFlavors = [self.item.itemFlavors stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
}

- (NSArray *)FlavorsArrayFromString {
  return [self.item.itemFlavors componentsSeparatedByString:@", "];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
