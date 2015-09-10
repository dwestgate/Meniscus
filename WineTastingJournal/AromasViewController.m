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

@property (strong, nonatomic) NSMutableDictionary *sectionHeaders;
@property (strong, nonatomic) NSMutableArray *sortedSectionHeaders;

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
  
  _sectionHeaders = [[NSMutableDictionary alloc] init];
  
  for (NSManagedObject *aroma in [[ItemStore sharedStore] allAromas]) {
    if ([_sectionHeaders objectForKey:[aroma valueForKey:@"category"]] == nil) {
      NSMutableArray *firstAromaInCategory = [NSMutableArray arrayWithObjects:[aroma valueForKey:@"taste"], nil];
      NSLog(@"%@", [aroma valueForKey:@"category"]);
      NSLog(@"%@", [aroma valueForKey:@"taste"]);
      //NSMutableArray *firstAromaInCategory = [NSMutableArray arrayWithObjects:@"hai",@"how",@"are",@"you",[aroma valueForKey:@"taste"],nil];
      [_sectionHeaders setObject:firstAromaInCategory forKey:[aroma valueForKey:@"category"]];
      
      
      /*
       NSMutableDictionary *yourMutableDictionary = [NSMutableDictionary alloc] init];
       [yourMutableDictionary setObject:@"Value" forKey:@"your key"];
       */
      
    } else {
      [[_sectionHeaders objectForKey:[aroma valueForKey:@"category"]] addObject:[aroma valueForKey:@"taste"]];
    }
  }
  
  // NSArray *sectionHeaderArray = [NSArray arrayWithArray:[_sectionHeaders valueForKey:@"category"]];
  _sortedSectionHeaders = [[_sectionHeaders allKeys] mutableCopy];
  // _sortedSectionHeaders = [[[_sectionHeaders allKeys] mutableCopy] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
  
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return  [_sectionHeaders count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [[self sortedSectionHeaders] objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
  NSString *key = [[self sortedSectionHeaders] objectAtIndex:section];
  // NSArray *contents = [[self sectionContents] objectForKey:key];
  NSArray *contents = [[self sectionHeaders] objectForKey:key];
  
  // NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];
  return [contents count];
  // return  [[[ItemStore sharedStore] allAromas] count];
          /*
           NSString *key = [[self sectionKeys] objectAtIndex:[indexPath section]];
           NSArray *contents = [[self sectionContents] objectForKey:key];
           NSString *contentForThisRow = [contents objectAtIndex:[indexPath row]];*/
  // return  [[[ItemStore sharedStore] allAromas] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
  
  /*
  NSArray *allAromas = [[ItemStore sharedStore] allAromas];
  NSManagedObject *aroma = allAromas[indexPath.row];
  
  NSString *aromaCategory = [aroma valueForKey:@"category"];
  cell.textLabel.text = aromaCategory;
  */
  NSString *key = [[self sortedSectionHeaders] objectAtIndex:[indexPath section]];
  NSArray *section = [[self sectionHeaders] objectForKey:key];
  NSString *aroma = [section objectAtIndex:[indexPath row]];
  cell.textLabel.text = aroma;
  
  Boolean found = NO;
  
  for (NSString *itemAroma in [self aromasArrayFromString]) {
    if ([aroma isEqualToString:itemAroma]) {
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
  
  NSArray *allAromas = [[ItemStore sharedStore] allAromas];
  NSManagedObject *aroma = allAromas[indexPath.row];
  
  if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    self.item.itemAromas = [self.item.itemAromas stringByReplacingOccurrencesOfString:[aroma valueForKey:@"category"] withString:@""];
    self.item.itemAromas = [self.item.itemAromas stringByReplacingOccurrencesOfString:@", , " withString:@", "];
  } else {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    self.item.itemAromas = [NSString stringWithFormat:@"%@, %@", self.item.itemAromas, [aroma valueForKey:@"category"]];
  }
  
  self.item.itemAromas = [self.item.itemAromas stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
  self.item.itemAromas = [self.item.itemAromas stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  self.item.itemAromas = [self.item.itemAromas stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
}

- (NSArray *)aromasArrayFromString {
  return [self.item.itemAromas componentsSeparatedByString:@", "];
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
