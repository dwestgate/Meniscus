//
//  AromaCategoriesViewController.m
//  WineTastingJournal
//
//  Created by David Westgate on 9/7/15.
//  Copyright (c) 2015 Refabricants. All rights reserved.
//

#import "AromaCategoriesViewController.h"
#import "AromasViewController.h"
#import "ItemStore.h"
#import "Item.h"

@interface AromaCategoriesViewController ()

@property (strong, nonatomic) NSArray *allTastes;
@property (strong, nonatomic) NSMutableArray *categoriesArray;
@property (strong, nonatomic) NSMutableArray *tastesArray;
@property (strong, nonatomic) NSMutableArray *characteristicsArray;

@property (strong, nonatomic) NSArray *test;
@property (strong, nonatomic) NSArray *test2;

@end

@implementation AromaCategoriesViewController

- (instancetype)init {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.navigationItem.title = NSLocalizedString(@"Aromas", @"AromaCategoriesViewController title");
  }
  return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
  return [super initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _categoriesArray = [[NSMutableArray alloc] init];
  _tastesArray = [[NSMutableArray alloc] init];
  _characteristicsArray = [[NSMutableArray alloc] init];
  _allTastes = [[NSArray alloc] init];

  // test - can I just sort aroma?
  
  NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryOrder" ascending:YES];
  NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
  _allTastes = [[[ItemStore sharedStore] allTastes] sortedArrayUsingDescriptors:descriptors];

  for (NSManagedObject *aroma in _allTastes) {
    
    // if the category isn't in our list already, add it - otherwise skip
    if (([_categoriesArray count] < 1) || (([_categoriesArray count] > 0) && (![[_categoriesArray lastObject] isEqualToString:[aroma valueForKey:@"category"]]))) {
      
      [_categoriesArray addObject:[aroma valueForKey:@"category"]];

      NSMutableArray *tastes = [NSMutableArray arrayWithArray:[_allTastes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"category MATCHES %@", [aroma valueForKey:@"category"]]]];
      [_tastesArray addObject:[NSMutableArray arrayWithArray:[[tastes valueForKey:@"taste"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]]];
      
      NSMutableArray *characteristics = [[NSMutableArray alloc] init];
      
      for (NSString *member in [_tastesArray lastObject]) {
        NSArray *characteristic = [NSArray arrayWithArray:[tastes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"taste MATCHES %@", member]]];
        if ([characteristic count] > 0) {
          [characteristics addObject:[[characteristic lastObject] valueForKey:@"characteristic"]];
        }
      }
      [_characteristicsArray addObject:[NSArray arrayWithArray:characteristics]];
      
    }
  }

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"UITableViewCell"];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return  [_tastesArray count];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
  
  Boolean found = NO;
  
  // floral (lavendar, rose); nutty (almonds, chocolate)
  
  for (NSString *itemAroma in [self AromaCategoriesArrayFromString]) {
    if ([cell.textLabel.text isEqualToString:itemAroma]) {
      found = YES;
      break;
    }
  }
  
  // Set font to bold and itallic
  UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
  UIFontDescriptor *changedFontDescriptor;
  NSDictionary *attributes;
  uint32_t existingTraitsWithNewTrait;
  
  if (found) {
      existingTraitsWithNewTrait = [fontDescriptor symbolicTraits] | UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic;
  } else {
      existingTraitsWithNewTrait = [fontDescriptor symbolicTraits] & ~UIFontDescriptorTraitBold & ~UIFontDescriptorTraitItalic;
  }

  changedFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:existingTraitsWithNewTrait];
  
  UIFont *updatedFont = [UIFont fontWithDescriptor:changedFontDescriptor size:0.0];
  
  attributes = @{ NSFontAttributeName : updatedFont };
  // end setting to bold and itallic
  
  NSMutableAttributedString *category = [[NSMutableAttributedString alloc] initWithString:[_categoriesArray objectAtIndex:[indexPath row]] attributes:attributes];

  cell.textLabel.attributedText = category;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
  // NSArray *allAromaCategories = [[ItemStore sharedStore] allAromas];
  // NSManagedObject *aroma = allAromaCategories[indexPath.row];
  
  AromasViewController *avc = [[AromasViewController alloc] init];
  avc.item = self.item;
  avc.category = [_categoriesArray objectAtIndex:[indexPath row]];
  avc.tastes = [_tastesArray objectAtIndex:[indexPath row]];
  avc.characteristics = [_characteristicsArray objectAtIndex:[indexPath row]];
  
  [self.navigationController pushViewController:avc
                                       animated:YES];
  
   /*
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
   */
  
}

- (NSArray *)AromaCategoriesArrayFromString {
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
