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

@property (strong, nonatomic) NSMutableDictionary *tasteDictionary;
@property (strong, nonatomic) NSMutableArray *categoriesArray;
@property (strong, nonatomic) NSMutableArray *tastesArray;

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
  
  _tasteDictionary = [[NSMutableDictionary alloc] init];
  _categoriesArray = [[NSMutableArray alloc] init];
  _tastesArray = [[NSMutableArray alloc] init];
  
  for (NSManagedObject *aroma in [[ItemStore sharedStore] allTastes]) {
    
    // if the category isn't in our list already, add it - otherwise just add the taste
    if ([_tasteDictionary objectForKey:[aroma valueForKey:@"categoryOrder"]] == nil) {
      NSMutableArray *firstTasteInNewCategory = [NSMutableArray arrayWithObjects:aroma, nil];
      
      [_tasteDictionary setObject:firstTasteInNewCategory forKey:[aroma valueForKey:@"categoryOrder"]];
    } else {
      [[_tasteDictionary objectForKey:[aroma valueForKey:@"categoryOrder"]] addObject:aroma];
    }
  }
  
  // Arrange categories in our custom order
  for (int c = 0; c < [_tasteDictionary count]; c++) {
    NSMutableArray *categoryAromas = [_tasteDictionary objectForKey:[NSNumber numberWithInt:c]];
    NSSet *uniqueCategories = [NSSet setWithArray:[categoryAromas valueForKey:@"category"]];
    
    [_categoriesArray addObjectsFromArray:[uniqueCategories allObjects]];
    
    //
    // WORKING HERE - need to get the taste-characteristic mapping to aromaviewcontroller
    // tastes, characteristics
    //
    NSMutableArray *tastes = [NSMutableArray arrayWithArray:[[categoryAromas valueForKey:@"taste"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    
    [_tastesArray addObject:[NSMutableArray arrayWithArray:tastes]];
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
  
  if (found) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  // Set font to bold and itallic
  UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
  
  UIFontDescriptor *changedFontDescriptor;
  NSDictionary *attributes;
  
  uint32_t existingTraitsWithNewTrait = [fontDescriptor symbolicTraits] | UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic;
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
  avc.tastes = [_tastesArray objectAtIndex:[indexPath row]];
  
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
