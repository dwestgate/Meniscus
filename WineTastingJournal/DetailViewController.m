//
//  DetailViewController.m
//  WineTastingJournal
//
//  Created by David Westgate on 6/17/15.
//  Copyright (c) 2015 David Westgate. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "ImageStore.h"
#import "ItemStore.h"
#import "AromaCategoriesViewController.h"
#import "FlavorCategoriesViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *tastingIDTextField;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;

@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@property (weak, nonatomic) IBOutlet UILabel *appearanceBanner;

@property (weak, nonatomic) IBOutlet UILabel *clarityLabel;
@property (weak, nonatomic) IBOutlet UISlider *claritySlider;

@property (weak, nonatomic) IBOutlet UILabel *meniscusLabel;
@property (weak, nonatomic) IBOutlet UISlider *meniscusSlider;

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UISlider *colorSlider;

@property (weak, nonatomic) IBOutlet UILabel *colorIntensityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *colorIntensityStepper;

@property (weak, nonatomic) IBOutlet UILabel *colorShadeLabel;
@property (weak, nonatomic) IBOutlet UISlider *colorShadeSlider;

@property (weak, nonatomic) IBOutlet UILabel *petillanceLabel;
@property (weak, nonatomic) IBOutlet UIStepper *petillanceStepper;

@property (weak, nonatomic) IBOutlet UILabel *viscosityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *viscosityStepper;

@property (weak, nonatomic) IBOutlet UILabel *sedimentLabel;
@property (weak, nonatomic) IBOutlet UISlider *sedimentSlider;

@property (weak, nonatomic) IBOutlet UILabel *noseBanner;

@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UISlider *conditionSlider;

@property (weak, nonatomic) IBOutlet UILabel *aromaIntensityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *aromaIntensityStepper;

@property (weak, nonatomic) IBOutlet UILabel *aromasLabel;
@property (weak, nonatomic) IBOutlet UIButton *aromasButton;
@property (weak, nonatomic) IBOutlet UITextView *aromasTextView;

@property (weak, nonatomic) IBOutlet UILabel *developmentLabel;
@property (weak, nonatomic) IBOutlet UIStepper *developmentStepper;

@property (weak, nonatomic) IBOutlet UILabel *palateBanner;

@property (weak, nonatomic) IBOutlet UILabel *sweetnessLabel;
@property (weak, nonatomic) IBOutlet UIStepper *sweetnessStepper;

@property (weak, nonatomic) IBOutlet UILabel *acidityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *acidityStepper;

@property (weak, nonatomic) IBOutlet UILabel *tanninLabel;
@property (weak, nonatomic) IBOutlet UIStepper *tanninStepper;

@property (weak, nonatomic) IBOutlet UILabel *alcoholLabel;
@property (weak, nonatomic) IBOutlet UIStepper *alcoholStepper;

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIStepper *bodyStepper;

@property (weak, nonatomic) IBOutlet UILabel *flavorIntensityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *flavorIntensityStepper;

@property (weak, nonatomic) IBOutlet UILabel *flavorsLabel;
@property (weak, nonatomic) IBOutlet UIButton *flavorsButton;
@property (weak, nonatomic) IBOutlet UITextView *flavorsTextView;

@property (weak, nonatomic) IBOutlet UITextField *balanceTextField;

@property (weak, nonatomic) IBOutlet UILabel *mousseLabel;
@property (weak, nonatomic) IBOutlet UIStepper *mousseStepper;

@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UIStepper *finishStepper;

@property (weak, nonatomic) IBOutlet UILabel *conclusionsBanner;

@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UISlider *qualitySlider;

@property (weak, nonatomic) IBOutlet UITextField *readinessTextField;

@property (weak, nonatomic) IBOutlet UILabel *hundredPointScoreLabel;
@property (weak, nonatomic) IBOutlet UISlider *hundredPointScoreSlider;

@property (weak, nonatomic) IBOutlet UILabel *fivePointScoreLabel;
@property (weak, nonatomic) IBOutlet UIStepper *fivePointScoreStepper;

@property (weak, nonatomic) IBOutlet UITextField *otherScoresTextField;

@property (weak, nonatomic) IBOutlet UILabel *detailsBanner;

@property (weak, nonatomic) IBOutlet UITextField *winemakerTextField;
@property (weak, nonatomic) IBOutlet UITextField *vintageTextField;
@property (weak, nonatomic) IBOutlet UITextField *appellationTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (weak, nonatomic) IBOutlet UILabel *tastedOnBanner;

@property (strong, nonatomic) IBOutlet UIPickerView *balancePickerView;
@property (strong, nonatomic) NSArray *balancePickerOptions;
@property (strong, nonatomic) IBOutlet UIPickerView *readinessPickerView;
@property (strong, nonatomic) NSArray *readinessPickerOptions;

// @property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;

@end

@implementation DetailViewController

#pragma mark - State Recovery

+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)path coder:(NSCoder *)coder
{
  BOOL isNew = NO;
  if ([path count] == 3) {
    isNew = YES;
  }
  
  return [[self alloc] initForNewItem:isNew];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
  [coder encodeObject:self.item.itemKey
               forKey:@"item.itemKey"];
  
  self.item.itemName = self.nameTextView.text;
  self.item.itemTastingID = self.tastingIDTextField.text;
  self.item.itemNotes = self.notesTextView.text;
  self.item.itemClarity = self.clarityLabel.text;
  self.item.itemClarityValue = self.claritySlider.value;
  self.item.itemMeniscus = self.meniscusLabel.text;
  self.item.itemMeniscusValue = self.meniscusSlider.value;
  self.item.itemColor = self.colorLabel.text;
  self.item.itemColorValue = self.colorSlider.value;
  self.item.itemColorIntensity = self.colorIntensityLabel.text;
  self.item.itemColorIntensityValue = self.colorIntensityStepper.value;
  self.item.itemColorShade = self.colorShadeLabel.text;
  self.item.itemColorShadeValue = self.colorShadeSlider.value;
  self.item.itemPetillance = self.petillanceLabel.text;
  self.item.itemPetillanceValue = self.petillanceStepper.value;
  self.item.itemViscosity = self.viscosityLabel.text;
  self.item.itemViscosityValue = self.viscosityStepper.value;
  self.item.itemSediment = self.sedimentLabel.text;
  self.item.itemSedimentValue = self.sedimentSlider.value;
  self.item.itemCondition = self.conditionLabel.text;
  self.item.itemConditionSliderValue = self.conditionSlider.value;
  self.item.itemAromaIntensity = self.aromaIntensityLabel.text;
  self.item.itemAromaIntensityValue = self.aromaIntensityStepper.value;
  self.item.itemAromas = self.aromasTextView.text;
  self.item.itemDevelopment = self.developmentLabel.text;
  self.item.itemDevelopmentValue = self.developmentStepper.value;
  self.item.itemSweetness = self.sweetnessLabel.text;
  self.item.itemSweetnessValue = self.sweetnessStepper.value;
  self.item.itemAcidity = self.acidityLabel.text;
  self.item.itemAcidityValue = self.acidityStepper.value;
  self.item.itemTannin = self.tanninLabel.text;
  self.item.itemTanninValue = self.tanninStepper.value;
  self.item.itemAlcohol = self.alcoholLabel.text;
  self.item.itemAlcoholValue = self.alcoholStepper.value;
  self.item.itemBody = self.bodyLabel.text;
  self.item.itemBodyValue = self.bodyStepper.value;
  self.item.itemFlavorIntensity = self.flavorIntensityLabel.text;
  self.item.itemFlavorIntensityValue = self.flavorIntensityStepper.value;
  self.item.itemFlavors = self.flavorsTextView.text;
  self.item.itemBalance = self.balanceTextField.text;
  self.item.itemMousse = self.mousseLabel.text;
  self.item.itemMousseValue = self.mousseStepper.value;
  self.item.itemFinish = self.finishLabel.text;
  self.item.itemFinishValue = self.finishStepper.value;
  self.item.itemQuality = self.qualityLabel.text;
  self.item.itemQualityValue = self.qualitySlider.value;
  self.item.itemReadiness = self.readinessTextField.text;
  self.item.itemHundredPointScore = self.hundredPointScoreLabel.text;
  self.item.itemHundredPointScoreValue = self.hundredPointScoreSlider.value;
  self.item.itemFivePointScore = self.fivePointScoreLabel.text;
  self.item.itemFivePointScoreValue = self.fivePointScoreStepper.value;
  self.item.itemOtherScores = self.otherScoresTextField.text;
  self.item.itemWinemaker = self.winemakerTextField.text;
  self.item.itemVintage = self.vintageTextField.text;
  self.item.itemAppellation = self.appellationTextField.text;
  self.item.valueInDollars = [self.priceTextField.text intValue];
  
  [[ItemStore sharedStore] saveChanges];
  
  [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
  NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
  for (Item *item in [[ItemStore sharedStore] allItems]) {
    if ([itemKey isEqualToString:item.itemKey]) {
      self.item = item;
      break;
    }
  }
  
  [super decodeRestorableStateWithCoder:coder];
}

#pragma mark - Initializers

- (instancetype)initForNewItem:(BOOL)isNew
{
  self = [super initWithNibName:nil bundle:nil];
    
  if (self) {
    self.restorationIdentifier = NSStringFromClass([self class]);
    self.restorationClass = [self class];
      
    if (isNew) {
      UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
      self.navigationItem.rightBarButtonItem = doneItem;
      UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
      self.navigationItem.leftBarButtonItem = cancelItem;
    }
        
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(updateFonts) name:UIContentSizeCategoryDidChangeNotification object:nil];
  }
    
  return self;
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    [NSException raise:@"Wrong initializer"
                format:@"Use initForNewItem:"];
    return nil;
}

#pragma mark - Control Actions

- (IBAction)claritySliderValueChanged:(id)sender {
  if (_claritySlider.value < 25) {
    _claritySlider.value = 1;
    _clarityLabel.text = @"Clear";
  } else if ((_claritySlider.value >= 25) && (_claritySlider.value < 75)) {
    _claritySlider.value = 50;
    _clarityLabel.text = @"Hazy";
  } else {
    _claritySlider.value = 100;
    _clarityLabel.text = @"Faulty";
  }
  [self updateTastingNotes];
}

- (IBAction)meniscusSliderValueChanged:(id)sender {
  if (_meniscusSlider.value < 13) {
    _meniscusSlider.value = 1;
    _meniscusLabel.text = @"Watery Rim";
  } else if ((_meniscusSlider.value >= 13) && (_meniscusSlider.value < 37)) {
    _meniscusSlider.value = 25;
    _meniscusLabel.text = @"Tawny Rim";
  } else if ((_meniscusSlider.value >= 37) && (_meniscusSlider.value < 62)) {
    _meniscusSlider.value = 50;
    _meniscusLabel.text = @"Orange Rim";
  } else if ((_meniscusSlider.value >= 62) && (_meniscusSlider.value < 87)) {
    _meniscusSlider.value = 75;
    _meniscusLabel.text = @"Bluish Rim";
  } else {
    _meniscusSlider.value = 100;
    _meniscusLabel.text = @"Greenish Rim";
  }
  [self updateTastingNotes];
}

- (IBAction)colorSliderValueChanged:(id)sender {
  if (_colorSlider.value < 25) {
    _colorSlider.value = 1;
    _colorLabel.text = @"White Wine";
  } else if ((_colorSlider.value >= 25) && (_colorSlider.value < 75)) {
    _colorSlider.value = 50;
    _colorLabel.text = @"Rosé Wine";
  } else {
    _colorSlider.value = 100;
    _colorLabel.text = @"Red Wine";
  }
  if (![_colorShadeLabel.text isEqualToString:@"Color Shade"]) {
    [self colorShadeSliderValueChanged:nil];
  }
  if (![_colorIntensityLabel.text isEqualToString:@"Color Intensity"]) {
    [self colorIntensityValueChanged:nil];
  }
  [self populateNameTextView];
  [self updateTastingNotes];
}

- (IBAction)colorIntensityValueChanged:(id)sender {
  
  if ([_colorIntensityLabel.text isEqualToString:@"Color Intensity"]) {
    _colorIntensityStepper.value = 1;
  }
  
  if (_colorIntensityStepper.value == 1) {
    
    if (_colorSlider.value == 50) {
      _colorIntensityLabel.text = @"Light";
    } else {
      _colorIntensityLabel.text = @"Pale";
    }
    
  } else if (_colorIntensityStepper.value == 2) {
    _colorIntensityLabel.text = @"Medium";
  } else {
    _colorIntensityLabel.text = @"Deep";
  }
  [self updateTastingNotes];
}

- (IBAction)colorShadeSliderValueChanged:(id)sender {
  if (_colorSlider.value == 1) {
    if (_colorShadeSlider.value < 16) {
      _colorShadeSlider.value = 1;
      _colorShadeLabel.text = @"Lemon-green";
    } else if ((_colorShadeSlider.value >= 16) && (_colorShadeSlider.value < 50)) {
      _colorShadeSlider.value = 33;
      _colorShadeLabel.text = @"Lemon";
    } else if ((_colorShadeSlider.value >= 50) && (_colorShadeSlider.value < 83)) {
      _colorShadeSlider.value = 66;
      _colorShadeLabel.text = @"Gold";
    } else {
      _colorShadeSlider.value = 100;
      _colorShadeLabel.text = @"Amber";
    }
  } else if (_colorSlider.value == 50) {
    if (_colorShadeSlider.value < 25) {
      _colorShadeSlider.value = 1;
      _colorShadeLabel.text = @"Pink";
    } else if ((_colorShadeSlider.value >= 25) && (_colorShadeSlider.value < 75)) {
      _colorShadeSlider.value = 50;
      _colorShadeLabel.text = @"Salmon";
    } else {
      _colorShadeSlider.value = 100;
      _colorShadeLabel.text = @"Orange";
    }
  } else {
    if (_colorShadeSlider.value < 16) {
      _colorShadeSlider.value = 1;
      _colorShadeLabel.text = @"Purple";
    } else if ((_colorShadeSlider.value >= 16) && (_colorShadeSlider.value < 50)) {
      _colorShadeSlider.value = 33;
      _colorShadeLabel.text = @"Ruby";
    } else if ((_colorShadeSlider.value >= 50) && (_colorShadeSlider.value < 83)) {
      _colorShadeSlider.value = 66;
      _colorShadeLabel.text = @"Garnet";
    } else {
      _colorShadeSlider.value = 100;
      _colorShadeLabel.text = @"Tawny";
    }
  }
  [self updateTastingNotes];
}

- (IBAction)petillanceValueChanged:(id)sender {
  
  if ([_petillanceLabel.text isEqualToString:@"Petillance"]) {
    _petillanceStepper.value = 1;
  }
  
  if (_petillanceStepper.value == 1) {
    _petillanceLabel.text = @"No petillance";
  } else if (_petillanceStepper.value == 2) {
    _petillanceLabel.text = @"Light petillance";
  } else {
    _petillanceLabel.text = @"Pronounced petillance";
  }
  [self updateTastingNotes];
}

- (IBAction)viscosityValueChanged:(id)sender {
  
  if ([_viscosityLabel.text isEqualToString:@"Viscosity"]) {
    _viscosityStepper.value = 1;
  }
  
  if (_viscosityStepper.value == 1) {
    _viscosityLabel.text = @"Clear legs";
  } else if (_viscosityStepper.value == 2) {
    _viscosityLabel.text = @"Stained legs";
  } else {
    _viscosityLabel.text = @"Sheeting";
  }
  [self updateTastingNotes];
}

- (IBAction)sedimentSliderValueChanged:(id)sender {
  if (_sedimentSlider.value < 16) {
    _sedimentSlider.value = 1;
    _sedimentLabel.text = @"No sediment";
  } else if ((_sedimentSlider.value >= 16) && (_sedimentSlider.value < 50)) {
    _sedimentSlider.value = 33;
    _sedimentLabel.text = @"Fine sediment";
  } else if ((_sedimentSlider.value >= 50) && (_sedimentSlider.value < 83)) {
    _sedimentSlider.value = 66;
    _sedimentLabel.text = @"Crystals";
  } else {
    _sedimentSlider.value = 100;
    _sedimentLabel.text = @"Thick sediment";
  }
  [self updateTastingNotes];
}

- (IBAction)conditionSliderValueChanged:(id)sender {
  if (_conditionSlider.value < 25) {
    _conditionSlider.value = 1;
    _conditionLabel.text = @"Clean";
  } else if ((_conditionSlider.value >= 25) && (_conditionSlider.value < 75)) {
    _conditionSlider.value = 50;
    _conditionLabel.text = @"Unclean";
  } else {
    _conditionSlider.value = 100;
    _conditionLabel.text = @"Corked";
  }
  [self updateTastingNotes];
}

- (IBAction)aromaIntensityValueChanged:(id)sender {
  
  if ([_aromaIntensityLabel.text isEqualToString:@"Aroma Intensity"]) {
    _aromaIntensityStepper.value = 1;
  }
  
  if (_aromaIntensityStepper.value == 1) {
    _aromaIntensityLabel.text = @"Light aroma";
  } else if (_aromaIntensityStepper.value == 2) {
    _aromaIntensityLabel.text = @"Medium-minus aroma";
  } else if (_aromaIntensityStepper.value == 3) {
    _aromaIntensityLabel.text = @"Medium-intensity aroma";
  } else if (_aromaIntensityStepper.value == 4) {
    _aromaIntensityLabel.text = @"Medium-plus aroma";
  } else {
    _aromaIntensityLabel.text = @"Pronounced aroma";
  }
  [self updateTastingNotes];
}

- (IBAction)aromasButtonTouchUpInside:(id)sender {
  [self.view endEditing:YES];
  
  AromaCategoriesViewController *avc = [[AromaCategoriesViewController alloc] init];
  avc.item = self.item;
  
  [self.navigationController pushViewController:avc
                                       animated:YES];
  [self updateTastingNotes];
}

- (IBAction)developmentValueChanged:(id)sender {
  
  if ([_developmentLabel.text isEqualToString:@"State of Development"]) {
    _developmentStepper.value = 1;
  }
  
  if (_developmentStepper.value == 1) {
    _developmentLabel.text = @"Youthful";
  } else if (_developmentStepper.value == 2) {
    _developmentLabel.text = @"Developing";
  } else if (_developmentStepper.value == 3) {
    _developmentLabel.text = @"Fully developed";
  } else {
    _developmentLabel.text = @"Tired/Past prime";
  }
  [self updateTastingNotes];
}

- (IBAction)sweetnessValueChanged:(id)sender {
  
  if ([_sweetnessLabel.text isEqualToString:@"Sweetness"]) {
    _sweetnessStepper.value = 1;
  }
  
  if (_sweetnessStepper.value == 1) {
    _sweetnessLabel.text = @"Dry";
  } else if (_sweetnessStepper.value == 2) {
    _sweetnessLabel.text = @"Off-dry";
  } else if (_sweetnessStepper.value == 3) {
    _sweetnessLabel.text = @"Medium -dry";
  } else if (_sweetnessStepper.value == 4) {
    _sweetnessLabel.text = @"Medium -sweet";
  } else if (_sweetnessStepper.value == 5) {
    _sweetnessLabel.text = @"Sweet";
  } else {
    _sweetnessLabel.text = @"Luscious";
  }
  [self updateTastingNotes];
}

- (IBAction)acidityValueChanged:(id)sender {
  
  if ([_acidityLabel.text isEqualToString:@"Acidity"]) {
    _acidityStepper.value = 1;
  }
  
  if (_acidityStepper.value == 1) {
    _acidityLabel.text = @"Low acidity";
  } else if (_acidityStepper.value == 2) {
    _acidityLabel.text = @"Medium-minus acidity";
  } else if (_acidityStepper.value == 3) {
    _acidityLabel.text = @"Medium acidity";
  } else if (_acidityStepper.value == 4) {
    _acidityLabel.text = @"Medium-plus acidity";
  } else {
    _acidityLabel.text = @"High acidity";
  }
  [self updateTastingNotes];
}

- (IBAction)tanninValueChanged:(id)sender {
  
  if ([_tanninLabel.text isEqualToString:@"Tannin"]) {
    _tanninStepper.value = 1;
  }
  
  if (_tanninStepper.value == 1) {
    _tanninLabel.text = @"Low tannin";
  } else if (_tanninStepper.value == 2) {
    _tanninLabel.text = @"Medium-minus tannins";
  } else if (_tanninStepper.value == 3) {
    _tanninLabel.text = @"Medium tannins";
  } else if (_tanninStepper.value == 4) {
    _tanninLabel.text = @"Medium-plus tannins";
  } else {
    _tanninLabel.text = @"High tannins";
  }
  [self updateTastingNotes];
}

- (IBAction)alcoholValueChanged:(id)sender {
  
  if ([_alcoholLabel.text isEqualToString:@"alcohol Level"]) {
    _alcoholStepper.value = 1;
  }
  
  if (_alcoholStepper.value == 1) {
    _alcoholLabel.text = @"Low alcohol (<11.5%)";
  } else if (_alcoholStepper.value == 2) {
    _alcoholLabel.text = @"Medium- alcohol (<12.5%)";
  } else if (_alcoholStepper.value == 3) {
    _alcoholLabel.text = @"Medium alcohol (<13.5%)";
  } else if (_alcoholStepper.value == 4) {
    _alcoholLabel.text = @"Medium+ alcohol (<13.9%)";
  } else {
    _alcoholLabel.text = @"High alcohol (14%+)";
  }
  [self updateTastingNotes];
}

- (IBAction)bodyValueChanged:(id)sender {
  
  if ([_bodyLabel.text isEqualToString:@"Body"]) {
    _bodyStepper.value = 1;
  }
  
  if (_bodyStepper.value == 1) {
    _bodyLabel.text = @"Light-bodied";
  } else if (_bodyStepper.value == 2) {
    _bodyLabel.text = @"Medium-minus body";
  } else if (_bodyStepper.value == 3) {
    _bodyLabel.text = @"Medium-bodied";
  } else if (_bodyStepper.value == 4) {
    _bodyLabel.text = @"Medium-plus body";
  } else {
    _bodyLabel.text = @"Full-bodied";
  }
  [self updateTastingNotes];
}

- (IBAction)flavorIntensityValueChanged:(id)sender {
  
  if ([_flavorIntensityLabel.text isEqualToString:@"Intensity of Flavor"]) {
    _flavorIntensityStepper.value = 1;
  }
  
  if (_flavorIntensityStepper.value == 1) {
    _flavorIntensityLabel.text = @"Light flavor";
  } else if (_flavorIntensityStepper.value == 2) {
    _flavorIntensityLabel.text = @"Medium-minus flavors";
  } else if (_flavorIntensityStepper.value == 3) {
    _flavorIntensityLabel.text = @"Medium flavors";
  } else if (_flavorIntensityStepper.value == 4) {
    _flavorIntensityLabel.text = @"Medium-plus flavors";
  } else {
    _flavorIntensityLabel.text = @"Pronounced flavors";
  }
  [self updateTastingNotes];
}

- (IBAction)flavorsButtonTouchUpInside:(id)sender {
  [self.view endEditing:YES];
  
  FlavorCategoriesViewController *fvc = [[FlavorCategoriesViewController alloc] init];
  fvc.item = self.item;
  
  [self.navigationController pushViewController:fvc
                                       animated:YES];
  [self updateTastingNotes];
}


- (IBAction)mousseValueChanged:(id)sender {
  
  if ([_mousseLabel.text isEqualToString:@"Mousse"]) {
    _mousseStepper.value = 1;
  }
  
  if (_mousseStepper.value == 1) {
    _mousseLabel.text = @"No mousse";
  } else if (_mousseStepper.value == 2) {
    _mousseLabel.text = @"Delicate mousse";
  } else if (_mousseStepper.value == 3) {
    _mousseLabel.text = @"Creamy mousse";
  } else {
    _mousseLabel.text = @"Aggressive mousse";
  }
  [self updateTastingNotes];
}

- (IBAction)finishValueChanged:(id)sender {
  
  if ([_finishLabel.text isEqualToString:@"Length of Finish"]) {
    _finishStepper.value = 1;
  }
  
  if (_finishStepper.value == 1) {
    _finishLabel.text = @"Short finish";
  } else if (_finishStepper.value == 2) {
    _finishLabel.text = @"Medium-minus finish";
  } else if (_finishStepper.value == 3) {
    _finishLabel.text = @"Medium-length finish";
  } else if (_finishStepper.value == 4) {
    _finishLabel.text = @"Medium-plus finish";
  } else {
    _finishLabel.text = @"Long finish";
  }
  [self updateTastingNotes];
}

- (IBAction)qualitySliderValueChanged:(id)sender {
  if (_qualitySlider.value < 10) {
    _qualitySlider.value = 1;
    _qualityLabel.text = @"Faulty";
  } else if ((_qualitySlider.value >= 10) && (_qualitySlider.value < 30)) {
    _qualitySlider.value = 20;
    _qualityLabel.text = @"Poor";
  } else if ((_qualitySlider.value >= 30) && (_qualitySlider.value < 50)) {
    _qualitySlider.value = 40;
    _qualityLabel.text = @"Acceptable";
  } else if ((_qualitySlider.value >= 50) && (_qualitySlider.value < 70)) {
    _qualitySlider.value = 60;
    _qualityLabel.text = @"Good quality";
  } else if ((_qualitySlider.value >= 70) && (_qualitySlider.value < 90)) {
    _qualitySlider.value = 80;
    _qualityLabel.text = @"Very good";
  } else {
    _qualitySlider.value = 100;
    _qualityLabel.text = @"Outstanding";
  }
  [self updateTastingNotes];
}

- (IBAction)hundredPointSliderValueChanged:(id)sender {
  
  if ([_hundredPointScoreLabel.text isEqualToString:@"100-Point Score"]) {
    _hundredPointScoreSlider.value = 70;
  }
  
  _hundredPointScoreLabel.text = [NSString stringWithFormat:@"%d Points", (int) _hundredPointScoreSlider.value];
  [self updateTastingNotes];
}

- (IBAction)fivePointStepperValueChanged:(id)sender {
  
  if ([_fivePointScoreLabel.text isEqualToString:@"5-Point Score"]) {
    _fivePointScoreStepper.value = 1;
  }
  
  if (_fivePointScoreStepper.value == 1) {
    _fivePointScoreLabel.text = [NSString stringWithFormat:@"%d Star", (int) _fivePointScoreStepper.value];
  } else {
    _fivePointScoreLabel.text = [NSString stringWithFormat:@"%d Stars", (int) _fivePointScoreStepper.value];
  }
  [self updateTastingNotes];
}

#pragma mark - ImagePicker

- (void)cancel:(id)sender
{
    [[ItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)takePicture:(id)sender
{
  /*
  if ([self.imagePickerPopover isPopoverVisible]) {
    [self.imagePickerPopover dismissPopoverAnimated:YES];
    self.imagePickerPopover = nil;
    return;
  }
   */
  
  UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
  
  if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
  } else {
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  }
  
  imagePicker.delegate = self;
  
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    UIPopoverPresentationController *imagePopover = [imagePicker popoverPresentationController];
    
    imagePopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    imagePopover.sourceView = self.view;
    /*
    self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
    self.imagePickerPopover.delegate = self;
    [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                                    animated:YES];
     */
  } else {
    [self presentViewController:imagePicker animated:YES completion:NULL];
  }
}
/*
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];
    
    [[ImageStore sharedStore] setImage:image
                                   forKey:self.item.itemKey];
    self.imageView.image = image;
  
    [self dismissViewControllerAnimated:YES completion:NULL];
    /*
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
     */
}


- (IBAction)actionButtonPressed:(id)sender {
  
  NSArray *values = [[NSArray alloc] initWithObjects:_notesTextView.text,_imageView.image, nil];
  
  UIActivityViewController *actionController = [[UIActivityViewController alloc] initWithActivityItems:values applicationActivities:nil];
  [actionController setValue:_nameTextView.text forKey:@"subject"];
  [self presentViewController:actionController animated:YES completion:nil];
}

#pragma mark - Assemble Notes

- (void)updateTastingNotes {
  
  _notesTextView.text = @"";
  
  bool hasIntro = false;
  bool clarityIsSet = ![_clarityLabel.text isEqualToString:@"Wine Clarity"];
  bool meniscusIsSet = ![_meniscusLabel.text isEqualToString:@"Meniscus"];
  bool colorIsSet = ![_colorLabel.text isEqualToString:@"Wine Color"];
  bool colorIntensityIsSet = ![_colorIntensityLabel.text isEqualToString:@"Color Intensity"];
  bool colorShadeIsSet = ![_colorShadeLabel.text isEqualToString:@"Color Shade"];
  bool petillanceIsSet = ![_petillanceLabel.text isEqualToString:@"Petillance"];
  bool viscosityIsSet = ![_viscosityLabel.text isEqualToString:@"Viscosity"];
  bool sedimentIsSet = ![_sedimentLabel.text isEqualToString:@"Sediment"];
  bool conditionIsSet = ![_conditionLabel.text isEqualToString:@"Condition"];
  bool aromaIntensityIsSet = ![_aromaIntensityLabel.text isEqualToString:@"Aroma Intensity"];
  bool aromasAreSet = ![_aromasTextView.text isEqualToString:@""];
  bool developmentIsSet = ![_developmentLabel.text isEqualToString:@"State of Development"];
  bool sweetnessIsSet = ![_sweetnessLabel.text isEqualToString:@"Sweetness"];
  bool acidityIsSet = ![_acidityLabel.text isEqualToString:@"Acidity"];
  bool taninIsSet = ![_tanninLabel.text isEqualToString:@"Tanin"];
  bool alcoholIsSet = ![_alcoholLabel.text isEqualToString:@"Alcohol Level"];
  bool bodyIsSet = ![_bodyLabel.text isEqualToString:@"Body"];
  bool flavorIntensityIsSet = ![_flavorIntensityLabel.text isEqualToString:@"Intensity of Flavor"];
  bool flavorsAreSet = ![_flavorsTextView.text isEqualToString:@""];
  bool balanceIsSet = ![_balanceTextField.text isEqualToString:@""];
  bool mousseIsSet = ![_mousseLabel.text isEqualToString:@"Mousse"];
  bool qualityIsSet = ![_qualityLabel.text isEqualToString:@"Quality"];
  bool readinessIsSet = ![_readinessTextField.text isEqualToString:@"Readiness"];
  bool hundredPointScoreIsSet = ![_hundredPointScoreLabel.text isEqualToString:@"100-Point Score"];
  bool fivePointScoreIsSet = ![_fivePointScoreLabel.text isEqualToString:@"5-Point Score"];
  bool otherScoresIsSet = ![_otherScoresTextField.text isEqualToString:@""];
  bool winemakerIsSet = ![_winemakerTextField.text isEqualToString:@""];
  bool vintageIsSet = ![_vintageTextField.text isEqualToString:@""];
  bool appelationIsSet = ![_appellationTextField.text isEqualToString:@""];
  bool priceIsSet = ![_priceTextField.text isEqualToString:@"0"];
  
  if (clarityIsSet && meniscusIsSet && colorShadeIsSet) {
    
    NSString *clarity;
    NSString *meniscus;
    NSString *color;
    
    if ([_clarityLabel.text isEqualToString:@"Faulty"]) {
      clarity = @"appears to be faulty";
    } else {
      clarity = [NSString stringWithFormat:@"is %@", [_clarityLabel.text lowercaseString]];
    }
    
    if ([_meniscusLabel.text isEqualToString:@"Orange Rim"]) {
      meniscus = @"an orange rim";
    } else {
      meniscus = [NSString stringWithFormat:@"a %@", [_meniscusLabel.text lowercaseString]];
    }
    
    color = [NSString stringWithFormat:@"%@ %@", _colorIntensityLabel.text, _colorShadeLabel.text];
    color = [[color lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    _notesTextView.text = [NSString stringWithFormat:@"The wine %@, with %@ and a color of %@.", clarity, meniscus, color];
    
  } else if (clarityIsSet && meniscusIsSet && !colorShadeIsSet) {
    
    
    NSString *clarity;
    NSString *meniscus;
    
    if ([_clarityLabel.text isEqualToString:@"Faulty"]) {
      clarity = @"appears to be faulty";
    } else {
      clarity = [NSString stringWithFormat:@"is %@", [_clarityLabel.text lowercaseString]];
    }
    
    if ([_meniscusLabel.text isEqualToString:@"Orange Rim"]) {
      meniscus = @"an orange rim";
    } else {
      meniscus = [NSString stringWithFormat:@"a %@", [_meniscusLabel.text lowercaseString]];
    }
    
    _notesTextView.text = [NSString stringWithFormat:@"The wine %@, and has %@.", clarity, meniscus];
    
  } else if (clarityIsSet && !meniscusIsSet && colorShadeIsSet) {
    
    NSString *clarity;
    NSString *color;
    
    if ([_clarityLabel.text isEqualToString:@"Faulty"]) {
      clarity = @"appears to be faulty";
    } else {
      clarity = [NSString stringWithFormat:@"is %@", [_clarityLabel.text lowercaseString]];
    }
    
    color = [NSString stringWithFormat:@"%@ %@", _colorIntensityLabel.text, _colorShadeLabel.text];
    color = [[color lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    _notesTextView.text = [NSString stringWithFormat:@"The wine %@, and has a color of %@.", clarity, color];
    
  } else if (!clarityIsSet && meniscusIsSet && colorShadeIsSet) {
    
    NSString *meniscus;
    NSString *color;
    
    if ([_meniscusLabel.text isEqualToString:@"Orange Rim"]) {
      meniscus = @"an orange rim";
    } else {
      meniscus = [NSString stringWithFormat:@"a %@", [_meniscusLabel.text lowercaseString]];
    }
    
    color = [NSString stringWithFormat:@"%@ %@", _colorIntensityLabel.text, _colorShadeLabel.text];
    color = [[color lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    _notesTextView.text = [NSString stringWithFormat:@"The wine has %@ and is %@ in color.", meniscus, color];
    
  } else if (clarityIsSet && !meniscusIsSet && !colorShadeIsSet) {
    
    NSString *clarity;
    
    if ([_clarityLabel.text isEqualToString:@"Faulty"]) {
      clarity = @"appears to be faulty";
    } else {
      clarity = [NSString stringWithFormat:@"is %@", [_clarityLabel.text lowercaseString]];
    }
    
    _notesTextView.text = [NSString stringWithFormat:@"The wine %@.", clarity];
    
  } else if (!clarityIsSet && meniscusIsSet && !colorShadeIsSet) {
    
    NSString *meniscus;
    
    if ([_meniscusLabel.text isEqualToString:@"Orange Rim"]) {
      meniscus = @"an orange rim";
    } else {
      meniscus = [NSString stringWithFormat:@"a %@", [_meniscusLabel.text lowercaseString]];
    }

    _notesTextView.text = [NSString stringWithFormat:@"The wine has %@.", meniscus];
    
  } else if (!clarityIsSet && !meniscusIsSet && colorShadeIsSet) {
    
    NSString *color;
    
    color = [NSString stringWithFormat:@"%@ %@", _colorIntensityLabel.text, _colorShadeLabel.text];
    color = [[color lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    _notesTextView.text = [NSString stringWithFormat:@"The wine is %@ in color.", color];
    
  }
  
  
  if (petillanceIsSet || viscosityIsSet || sedimentIsSet) {
    
    NSString *petillance;
    NSString *sediment;
    NSString *viscosity;
    
    if (petillanceIsSet) {
      petillance = [_petillanceLabel.text lowercaseString];
    }
    
    if (sedimentIsSet) {
      if ([_sedimentLabel.text isEqualToString:@"Crystals"]) {
        sediment = @"visible tartrates";
      } else {
        sediment = [_sedimentLabel.text lowercaseString];
      }
    }
    
    if (viscosityIsSet) {
      if ([_viscosityLabel.text isEqualToString:@"Sheeting"]) {
        viscosity = @"sheets";
      } else {
        viscosity = [_viscosityLabel.text lowercaseString];
      }
    }
    
    if (petillanceIsSet && sedimentIsSet && viscosityIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The wine has %@, %@, and forms %@ on the glass.", _notesTextView.text, petillance, sediment, viscosity];
    } else if (petillanceIsSet && sedimentIsSet && !viscosityIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The wine has %@, and %@.", _notesTextView.text, petillance, sediment];
    } else if (petillanceIsSet && !sedimentIsSet && viscosityIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The wine has %@ and forms %@ on the glass.", _notesTextView.text, petillance, viscosity];
    } else if (!petillanceIsSet && sedimentIsSet && viscosityIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The wine has %@ and forms %@ on the glass.", _notesTextView.text, sediment, viscosity];
    } else if (!petillanceIsSet && !sedimentIsSet && viscosityIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The wine forms %@ on the glass.", _notesTextView.text, viscosity];
    } else if (!petillanceIsSet && sedimentIsSet && !viscosityIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The wine has %@.", _notesTextView.text, sediment];
    } else if (petillanceIsSet && !sedimentIsSet && !viscosityIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The wine has %@.", _notesTextView.text, petillance];
    }
    
  }
  
  if (conditionIsSet || aromaIntensityIsSet || aromasAreSet || developmentIsSet) {
    
    NSString *condition;
    NSString *aromaIntensity;
    NSString *aromas;
    NSString *development;
    
    if (conditionIsSet) {
      condition = [_conditionLabel.text lowercaseString];
    }
    
    if (aromaIntensityIsSet) {
      aromaIntensity = [_aromaIntensityLabel.text lowercaseString];
    }
    
    if (aromasAreSet) {
      aromas = [_aromasTextView.text lowercaseString];
    }
    
    if (developmentIsSet) {
      development = [_developmentLabel.text lowercaseString];
    }
    
    _notesTextView.text = [NSString stringWithFormat:@"%@\r\n\r\n", _notesTextView.text];
    
    if (conditionIsSet && aromaIntensityIsSet && aromasAreSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The nose is %@ and of %@, with %@.", _notesTextView.text, condition, aromaIntensity, aromas];
    } else if (conditionIsSet && aromaIntensityIsSet && !aromasAreSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The nose is %@ and of %@.", _notesTextView.text, condition, aromaIntensity];
    } else if (conditionIsSet && !aromaIntensityIsSet && aromasAreSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The nose is %@, with %@.", _notesTextView.text, condition, aromas];
    } else if (!conditionIsSet && aromaIntensityIsSet && aromasAreSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The nose is of %@, with %@.", _notesTextView.text, aromaIntensity, aromas];
    } else if (!conditionIsSet && !aromaIntensityIsSet && aromasAreSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The nose has %@.", _notesTextView.text, aromas];
    } else if (!conditionIsSet && aromaIntensityIsSet && !aromasAreSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The nose is of %@.", _notesTextView.text, aromaIntensity];
    } else if (conditionIsSet && !aromaIntensityIsSet && !aromasAreSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ The nose is %@.", _notesTextView.text, condition];
    }
    
    if (developmentIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ From its nose, the wine %@.", _notesTextView.text, development];
    }
    
  }
  
  
  if (qualityIsSet || readinessIsSet) {
    
    NSString *quality;
    NSString *readiness;
    
    if (qualityIsSet) {
      if ([_qualityLabel.text isEqualToString:@"Acceptable"]) {
        quality = @"an acceptable quality";
      } else if ([_qualityLabel.text isEqualToString:@"Outstanding"]) {
        quality = @"an outatanding";
      } else if ([_qualityLabel.text isEqualToString:@"Poor"]) {
        quality = @"a poor quality";
      } else {
        quality = [NSString stringWithFormat:@"a %@", [_qualityLabel.text lowercaseString]];
      }
    }
    
    if (readinessIsSet) {
      if ([_readinessTextField.text isEqualToString:@"Drink now; not intended for aging"]) {
        readiness = @"should be drunk now; it is not intended for aging";
      } else if ([_readinessTextField.text isEqualToString:@"Has potential for aging"]) {
        readiness = [_readinessTextField.text lowercaseString];
      } else {
        readiness = [[NSString stringWithFormat:@"is %@", _readinessTextField.text] lowercaseString];
      }
    }
    
    if (qualityIsSet && readinessIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ This is %@ wine that %@.", _notesTextView.text, quality, readiness];
    } else if (qualityIsSet && !readinessIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ This is %@ wine.", _notesTextView.text, quality];
    } else if (!qualityIsSet && readinessIsSet) {
      _notesTextView.text = [NSString stringWithFormat:@"%@ This wine %@.", _notesTextView.text, readiness];
    }
    
  }

  if (hundredPointScoreIsSet) {
    _notesTextView.text = [NSString stringWithFormat:@"%@ On a scale of one to one hundred I give this wine %@.", _notesTextView.text, [_hundredPointScoreLabel.text lowercaseString]];
  }
  
  if (fivePointScoreIsSet) {
    _notesTextView.text = [NSString stringWithFormat:@"%@ On a five star scale with five being the highest, I rate this wine a %@.", _notesTextView.text, [_fivePointScoreLabel.text substringToIndex:1]];
  }
  
  _notesTextView.text = [_notesTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

}

#pragma mark - View Constraints

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    return;
  }
  
  if (UIInterfaceOrientationIsLandscape(orientation)) {
    self.imageView.hidden = YES;
    self.cameraButton.enabled = NO;
  } else {
    self.imageView.hidden = NO;
    self.cameraButton.enabled = YES;
  }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}


- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self.scrollView layoutIfNeeded];
  self.scrollView.contentSize = self.contentView.bounds.size;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
  
  UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
  iv.contentMode = UIViewContentModeScaleAspectFit;
  iv.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:iv];
  self.imageView = iv;
  
  [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
  [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
  
  NSDictionary *nameMap = @{@"imageView" : self.imageView, @"tastedOnBanner" : self.tastedOnBanner};
  NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:nameMap];
  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tastedOnBanner]-[imageView]-0-|" options:0 metrics:nil views:nameMap];
  
  [self.contentView addConstraints:horizontalConstraints];
  [self.contentView addConstraints:verticalConstraints];
  
  // Add the PickerViews
  UITapGestureRecognizer *balancePickerViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(balancePickerViewTapped:)];
  _balancePickerOptions = [[NSArray alloc] initWithObjects:@"Well-balanced",
                           @"Ascetic",
                           @"Acidic",
                           @"Thin",
                           @"Flabby",
                           @"Jammy",
                           @"alcoholic",
                           nil];
  _balancePickerView = [[UIPickerView alloc] init];
  [_balancePickerView addGestureRecognizer:balancePickerViewTap];
  
  balancePickerViewTap.delegate = self;
  _balancePickerView.delegate = self;
  _balancePickerView.dataSource = self;
  
  UITapGestureRecognizer *readinessPickerViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readinessPickerViewTapped:)];
  _readinessPickerOptions = [[NSArray alloc] initWithObjects:@"Not yet ready for drinking",
                              @"Has potential for aging",
                              @"Drink now; not intended for aging",
                              @"Past its prime",
                              nil];
  _readinessPickerView = [[UIPickerView alloc] init];
  [_readinessPickerView addGestureRecognizer:readinessPickerViewTap];
  
  readinessPickerViewTap.delegate = self;
  _readinessPickerView.delegate = self;
  _readinessPickerView.dataSource = self;

}

#pragma mark - TextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}


- (IBAction)balanceTextFieldDidBeginEditing:(id)sender {
  CGRect rc = [_balanceTextField bounds];
  rc = [_balanceTextField convertRect:rc toView:_scrollView];
  rc.origin.x = 0 ;
  rc.origin.y -= 60 ;
  rc.size.height = 400;
  [_scrollView scrollRectToVisible:rc animated:YES];
  
  if (_balanceTextField.isEditing==YES)
  {
    _balanceTextField.inputView = _balancePickerView;
  }
}

- (IBAction)readinessTextFieldDidBeginEditing:(id)sender {
  CGRect rc = [_readinessTextField bounds];
  rc = [_readinessTextField convertRect:rc toView:_scrollView];
  rc.origin.x = 0 ;
  rc.origin.y -= 60 ;
  rc.size.height = 400;
  [_scrollView scrollRectToVisible:rc animated:YES];
  
  if (_readinessTextField.isEditing==YES)
  {
    _readinessTextField.inputView = _readinessPickerView;
  }
}


#pragma mark - PickerView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
  
  return true;
}

- (void)balancePickerViewTapped:(UIGestureRecognizer *)balancePickerViewTap {
  
  CGPoint touchPoint = [balancePickerViewTap locationInView:balancePickerViewTap.view.superview];
  
  CGRect frame = self.balancePickerView.frame;
  CGRect selectorFrame = CGRectInset(frame, 0.0, self.balancePickerView.bounds.size.height);
  
  if (CGRectContainsPoint(selectorFrame, touchPoint)) {
    NSLog( @"Selected Row: %@", self.balanceTextField.text);
  }
  
  [self.view endEditing:YES];
}

- (void)readinessPickerViewTapped:(UIGestureRecognizer *)readinessPickerViewTap {
  
  CGPoint touchPoint = [readinessPickerViewTap locationInView:readinessPickerViewTap.view.superview];
  
  CGRect frame = self.readinessPickerView.frame;
  CGRect selectorFrame = CGRectInset(frame, 0.0, self.readinessPickerView.bounds.size.height);
  
  if (CGRectContainsPoint(selectorFrame, touchPoint)) {
    NSLog( @"Selected Row: %@", self.readinessTextField.text);
  }
  
  [self.view endEditing:YES];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  
  return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
      numberOfRowsInComponent:(NSInteger)component {
  
  NSInteger numberOfRows = 0;
  
  if (_balanceTextField.isEditing) {
    numberOfRows = [_balancePickerOptions count];
  } else if (_readinessTextField.isEditing) {
    numberOfRows = [_readinessPickerOptions count];
  }
  
  return numberOfRows;
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  NSString *titleForRow;
  
  if (_balanceTextField.isEditing) {
    titleForRow = [_balancePickerOptions objectAtIndex:row];
    _balanceTextField.text = [_balancePickerOptions objectAtIndex:row];
  } else if (_readinessTextField.isEditing) {
    titleForRow = [_readinessPickerOptions objectAtIndex:row];
    _readinessTextField.text = [_readinessPickerOptions objectAtIndex:row];
  }
  
  return titleForRow;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  if (_balanceTextField.isEditing) {
    _balanceTextField.text = [_balancePickerOptions objectAtIndex:row];
  } else if (_readinessTextField.isEditing) {
    _readinessTextField.text = [_readinessPickerOptions objectAtIndex:row];
  }
}


#pragma mark - Form Maintenance

- (void)updateFonts
{
  UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
  self.nameLabel.font = font;
  self.nameTextView.font = font;
  self.tastingIDTextField.font = font;
  self.notesLabel.font = font;
  self.notesTextView.font = font;
  self.appearanceBanner.font = font;
  self.clarityLabel.font = font;
  self.meniscusLabel.font = font;
  self.colorLabel.font = font;
  self.colorIntensityLabel.font = font;
  self.colorShadeLabel.font = font;
  self.petillanceLabel.font = font;
  self.viscosityLabel.font = font;
  self.sedimentLabel.font = font;
  self.noseBanner.font = font;
  self.conditionLabel.font = font;
  self.aromaIntensityLabel.font = font;
  self.aromasLabel.font = font;
  self.aromasTextView.font = font;
  self.developmentLabel.font = font;
  self.palateBanner.font = font;
  self.sweetnessLabel.font = font;
  self.acidityLabel.font = font;
  self.tanninLabel.font = font;
  self.alcoholLabel.font = font;
  self.bodyLabel.font = font;
  self.flavorIntensityLabel.font = font;
  self.flavorsLabel.font = font;
  self.flavorsTextView.font = font;
  self.balanceTextField.font = font;
  self.mousseLabel.font = font;
  self.finishLabel.font = font;
  self.conclusionsBanner.font = font;
  self.qualityLabel.font = font;
  self.readinessTextField.font = font;
  self.hundredPointScoreLabel.font = font;
  self.fivePointScoreLabel.font = font;
  self.otherScoresTextField.font = font;
  self.detailsBanner.font = font;
  self.winemakerTextField.font = font;
  self.vintageTextField.font = font;
  self.appellationTextField.font = font;
  self.priceTextField.font = font;
  self.tastedOnBanner.font = font;
}

- (void)setItem:(Item *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
  [self prepareViewsForOrientation:io];
  
  Item *item = self.item;
  
  self.nameTextView.text = item.itemName;
  self.tastingIDTextField.text = item.itemTastingID;
  self.notesTextView.text = item.itemNotes;
  self.clarityLabel.text = item.itemClarity;
  self.claritySlider.value = item.itemClarityValue;
  self.meniscusLabel.text = item.itemMeniscus;
  self.meniscusSlider.value = item.itemMeniscusValue;
  self.colorLabel.text = item.itemColor;
  self.colorSlider.value = item.itemColorValue;
  self.colorIntensityLabel.text = item.itemColorIntensity;
  self.colorIntensityStepper.value = item.itemColorIntensityValue;
  self.colorShadeLabel.text = item.itemColorShade;
  self.colorShadeSlider.value = item.itemColorShadeValue;
  self.petillanceLabel.text = item.itemPetillance;
  self.petillanceStepper.value = item.itemPetillanceValue;
  self.viscosityLabel.text = item.itemViscosity;
  self.viscosityStepper.value = item.itemViscosityValue;
  self.sedimentLabel.text = item.itemSediment;
  self.sedimentSlider.value = item.itemSedimentValue;
  self.conditionLabel.text = item.itemCondition;
  self.conditionSlider.value = item.itemConditionSliderValue;
  self.aromaIntensityLabel.text = item.itemAromaIntensity;
  self.aromaIntensityStepper.value = item.itemAromaIntensityValue;
  self.aromasTextView.text = item.itemAromas;
  self.developmentLabel.text = item.itemDevelopment;
  self.developmentStepper.value = item.itemDevelopmentValue;
  self.sweetnessLabel.text = item.itemSweetness;
  self.sweetnessStepper.value = item.itemSweetnessValue;
  self.acidityLabel.text = item.itemAcidity;
  self.acidityStepper.value = item.itemAcidityValue;
  self.tanninLabel.text = item.itemTannin;
  self.tanninStepper.value = item.itemTanninValue;
  self.alcoholLabel.text = item.itemAlcohol;
  self.alcoholStepper.value = item.itemAlcoholValue;
  self.bodyLabel.text = item.itemBody;
  self.bodyStepper.value = item.itemBodyValue;
  self.flavorIntensityLabel.text = item.itemFlavorIntensity;
  self.flavorIntensityStepper.value = item.itemFlavorIntensityValue;
  self.flavorsTextView.text = item.itemFlavors;
  self.balanceTextField.text = item.itemBalance;
  self.mousseLabel.text = item.itemMousse;
  self.mousseStepper.value = item.itemMousseValue;
  self.finishLabel.text = item.itemFinish;
  self.finishStepper.value = item.itemFinishValue;
  self.qualityLabel.text = item.itemQuality;
  self.qualitySlider.value = item.itemQualityValue;
  self.readinessTextField.text = item.itemReadiness;
  self.hundredPointScoreLabel.text = item.itemHundredPointScore;
  self.hundredPointScoreSlider.value = item.itemHundredPointScoreValue;
  self.fivePointScoreLabel.text = item.itemFivePointScore;
  self.fivePointScoreStepper.value = item.itemFivePointScoreValue;
  self.otherScoresTextField.text = item.itemOtherScores;
  self.winemakerTextField.text = item.itemWinemaker;
  self.vintageTextField.text = item.itemVintage;
  self.appellationTextField.text = item.itemAppellation;
  self.priceTextField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
  
  static NSDateFormatter *dateFormatter;
  if (!dateFormatter) {
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
  }
  
  self.tastedOnBanner.text = [dateFormatter stringFromDate:item.dateCreated];
  
  NSString *itemKey = self.item.itemKey;
  UIImage *imageToDisplay = [[ImageStore sharedStore] imageForKey:itemKey];
  self.imageView.image = imageToDisplay;
    
  [self updateFonts];
  
  if (_nameTextView.text.length == 0) {
    [self populateNameTextView];
    [_nameTextView becomeFirstResponder];
    [UIMenuController sharedMenuController].menuVisible = NO;
  }
  
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [self.view endEditing:YES];

  [self populateNameTextView];
  
  Item *item = self.item;
  
  item.itemName = self.nameTextView.text;
  item.itemTastingID = self.tastingIDTextField.text;
  item.itemNotes = self.notesTextView.text;
  item.itemClarity = self.clarityLabel.text;
  item.itemClarityValue = self.claritySlider.value;
  item.itemMeniscus = self.meniscusLabel.text;
  item.itemMeniscusValue = self.meniscusSlider.value;
  item.itemColor = self.colorLabel.text;
  item.itemColorValue = self.colorSlider.value;
  item.itemColorIntensity = self.colorIntensityLabel.text;
  item.itemColorIntensityValue = self.colorIntensityStepper.value;
  item.itemColorShade = self.colorShadeLabel.text;
  item.itemColorShadeValue = self.colorShadeSlider.value;
  item.itemPetillance = self.petillanceLabel.text;
  item.itemPetillanceValue = self.petillanceStepper.value;
  item.itemViscosity = self.viscosityLabel.text;
  item.itemViscosityValue = self.viscosityStepper.value;
  item.itemSediment = self.sedimentLabel.text;
  item.itemSedimentValue = self.sedimentSlider.value;
  item.itemCondition = self.conditionLabel.text;
  item.itemConditionSliderValue = self.conditionSlider.value;
  item.itemAromaIntensity = self.aromaIntensityLabel.text;
  item.itemAromaIntensityValue = self.aromaIntensityStepper.value;
  item.itemAromas = self.aromasTextView.text;
  item.itemDevelopment = self.developmentLabel.text;
  item.itemDevelopmentValue = self.developmentStepper.value;
  item.itemSweetness = self.sweetnessLabel.text;
  item.itemSweetnessValue = self.sweetnessStepper.value;
  item.itemAcidity = self.acidityLabel.text;
  item.itemAcidityValue = self.acidityStepper.value;
  item.itemTannin = self.tanninLabel.text;
  item.itemTanninValue = self.tanninStepper.value;
  item.itemAlcohol = self.alcoholLabel.text;
  item.itemAlcoholValue = self.alcoholStepper.value;
  item.itemBody = self.bodyLabel.text;
  item.itemBodyValue = self.bodyStepper.value;
  item.itemFlavorIntensity = self.flavorIntensityLabel.text;
  item.itemFlavorIntensityValue = self.flavorIntensityStepper.value;
  item.itemFlavors = self.flavorsTextView.text;
  item.itemBalance = self.balanceTextField.text;
  item.itemMousse = self.mousseLabel.text;
  item.itemMousseValue = self.mousseStepper.value;
  item.itemFinish = self.finishLabel.text;
  item.itemFinishValue = self.finishStepper.value;
  item.itemQuality = self.qualityLabel.text;
  item.itemQualityValue = self.qualitySlider.value;
  item.itemReadiness = self.readinessTextField.text;
  item.itemHundredPointScore = self.hundredPointScoreLabel.text;
  item.itemHundredPointScoreValue = self.hundredPointScoreSlider.value;
  item.itemFivePointScore = self.fivePointScoreLabel.text;
  item.itemFivePointScoreValue = self.fivePointScoreStepper.value;
  item.itemOtherScores = self.otherScoresTextField.text;
  item.itemWinemaker = self.winemakerTextField.text;
  item.itemVintage = self.vintageTextField.text;
  item.itemAppellation = self.appellationTextField.text;

  int newValue = [self.priceTextField.text intValue];
  
  if (newValue != item.valueInDollars) {
    item.valueInDollars = newValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:newValue forKey:NextItemValuePrefsKey];
  }
}

#pragma mark - Text Manipulation

-(void)populateNameTextView
{
  
  // Set a name if it is not set already
  if ((self.nameTextView.text.length == 0) ||
      ([self.nameTextView.text hasPrefix:@"White wine tasted on"]) ||
      ([self.nameTextView.text hasPrefix:@"Rosé wine tasted on"]) ||
      ([self.nameTextView.text hasPrefix:@"Red wine tasted on"]) ||
      ([self.nameTextView.text hasPrefix:@"Wine tasted on"])) {
    
    if (![self.colorLabel.text isEqualToString:@"Wine Color"]) {
      self.nameTextView.text = [NSString stringWithFormat:@"%@ wine tasted on %@", self.colorLabel.text, self.tastedOnBanner.text];
    } else {
      self.nameTextView.text = [NSString stringWithFormat:@"Wine tasted on %@", self.tastedOnBanner.text];
    }
    
  }
}

@end
