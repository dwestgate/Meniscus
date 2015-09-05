//
//  DetailViewController.m
//  WineTastingJournal
//
//  Created by David Westgate on 6/17/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import "DetailViewController.h"
#import "Item.h"
#import "ImageStore.h"
#import "ItemStore.h"
#import "AssetTypeViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()
    <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *nameTextView;

@property (weak, nonatomic) IBOutlet UILabel *notesLabel;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;

@property (weak, nonatomic) IBOutlet UILabel *appearanceBanner;

@property (weak, nonatomic) IBOutlet UILabel *clarityLabel;
@property (weak, nonatomic) IBOutlet UISlider *claritySlider;

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

@property (weak, nonatomic) IBOutlet UILabel *alchoholLabel;
@property (weak, nonatomic) IBOutlet UIStepper *alchoholStepper;

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIStepper *bodyStepper;

@property (weak, nonatomic) IBOutlet UILabel *flavorIntensityLabel;
@property (weak, nonatomic) IBOutlet UIStepper *flavorIntensityStepper;

@property (weak, nonatomic) IBOutlet UILabel *flavorsLabel;
@property (weak, nonatomic) IBOutlet UITextView *flavorsTextView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *balanceTextField;

@property (weak, nonatomic) IBOutlet UILabel *mousseLabel;
@property (weak, nonatomic) IBOutlet UIStepper *mousseStepper;

@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UIStepper *finishStepper;

@property (weak, nonatomic) IBOutlet UILabel *conclusionsBanner;

@property (weak, nonatomic) IBOutlet UILabel *qualityLabel;
@property (weak, nonatomic) IBOutlet UISlider *qualitySlider;

@property (weak, nonatomic) IBOutlet UILabel *readinessLabel;
@property (weak, nonatomic) IBOutlet UITextField *readinessTextField;

@property (weak, nonatomic) IBOutlet UILabel *detailsBanner;

@property (weak, nonatomic) IBOutlet UILabel *winemakerLabel;
@property (weak, nonatomic) IBOutlet UITextField *winemakerTextField;

@property (weak, nonatomic) IBOutlet UILabel *vintageLabel;
@property (weak, nonatomic) IBOutlet UITextField *vintageTextField;

@property (weak, nonatomic) IBOutlet UILabel *appellationLabel;
@property (weak, nonatomic) IBOutlet UITextField *appellationTextField;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (weak, nonatomic) IBOutlet UILabel *tastedOnBanner;

@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;

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
  self.item.itemNotes = self.notesTextView.text;
  self.item.itemClarity = self.clarityLabel.text;
  self.item.itemClarityValue = self.claritySlider.value;
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
  self.item.itemAlchohol = self.alchoholLabel.text;
  self.item.itemAlchoholValue = self.alchoholStepper.value;
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
  self.item.itemWinemaker = self.winemakerTextField.text;
  self.item.itemVintage = self.vintageTextField.text;
  self.item.itemAppellation = self.appellationTextField.text;
  self.item.valueInDollars = [self.priceTextField.text intValue];
  /*
  self.item.itemName = self.nameTextView.text;
  self.item.vintage = self.vintageTextField.text;
  self.item.valueInDollars = [self.priceTextField.text intValue];
  */
  
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
}

- (IBAction)colorSliderValueChanged:(id)sender {
  if (_colorSlider.value < 25) {
    _colorSlider.value = 1;
    _colorLabel.text = @"White";
  } else if ((_colorSlider.value >= 25) && (_colorSlider.value < 75)) {
    _colorSlider.value = 50;
    _colorLabel.text = @"Rosé";
  } else {
    _colorSlider.value = 100;
    _colorLabel.text = @"Red";
  }
  [self colorShadeSliderValueChanged:nil];
  [self colorShadeSliderValueChanged:nil];
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
}

- (IBAction)alchoholValueChanged:(id)sender {
  
  if ([_alchoholLabel.text isEqualToString:@"Alchohol Level"]) {
    _alchoholStepper.value = 1;
  }
  
  if (_alchoholStepper.value == 1) {
    _alchoholLabel.text = @"Low alchohol (<11.5%)";
  } else if (_alchoholStepper.value == 2) {
    _alchoholLabel.text = @"Medium- alchohol (<12.5%)";
  } else if (_alchoholStepper.value == 3) {
    _alchoholLabel.text = @"Medium alchohol (<13.5%)";
  } else if (_alchoholStepper.value == 4) {
    _alchoholLabel.text = @"Medium+ alchohol (<13.9%)";
  } else {
    _alchoholLabel.text = @"High alchohol (14%+)";
  }
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
}

- (IBAction)showAssetTypePicker:(id)sender {
  [self.view endEditing:YES];
  
  AssetTypeViewController *avc = [[AssetTypeViewController alloc] init];
  avc.item = self.item;
  
  [self.navigationController pushViewController:avc
                                       animated:YES];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)takePicture:(id)sender
{
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate = self;
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:NULL];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    self.imagePickerPopover = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self.item setThumbnailFromImage:image];
    
    [[ImageStore sharedStore] setImage:image
                                   forKey:self.item.itemKey];
    self.imageView.image = image;
    
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
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
}

#pragma mark - Form Maintenance

- (void)updateFonts
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
  self.nameLabel.font = font;
  self.nameTextView.font = font;
  self.notesLabel.font = font;
  self.notesTextView.font = font;
  self.appearanceBanner.font = font;
  self.clarityLabel.font = font;
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
  self.alchoholLabel.font = font;
  self.bodyLabel.font = font;
  self.flavorIntensityLabel.font = font;
  self.flavorsLabel.font = font;
  self.flavorsTextView.font = font;
  self.balanceLabel.font = font;
  self.balanceTextField.font = font;
  self.mousseLabel.font = font;
  self.finishLabel.font = font;
  self.conclusionsBanner.font = font;
  self.qualityLabel.font = font;
  self.readinessLabel.font = font;
  self.readinessTextField.font = font;
  self.detailsBanner.font = font;
  self.winemakerLabel.font = font;
  self.winemakerTextField.font = font;
  self.vintageLabel.font = font;
  self.vintageTextField.font = font;
  self.appellationLabel.font = font;
  self.appellationTextField.font = font;
  self.priceLabel.font = font;
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
  self.notesTextView.text = item.itemNotes;
  self.clarityLabel.text = item.itemClarity;
  self.claritySlider.value = item.itemClarityValue;
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
  self.alchoholLabel.text = item.itemAlchohol;
  self.alchoholStepper.value = item.itemAlchoholValue;
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
  self.winemakerTextField.text = item.itemWinemaker;
  self.vintageTextField.text = item.itemVintage;
  self.appellationTextField.text = item.itemAppellation;
  self.priceTextField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
  
  /*
   self.nameTextView.text = item.itemName;
   self.vintageTextField.text = item.vintage;
   self.priceTextField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
   */
  
  static NSDateFormatter *dateFormatter;
  if (!dateFormatter) {
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
  }
  
  self.tastedOnBanner.text = [dateFormatter stringFromDate:item.dateCreated];
  
  NSString *itemKey = self.item.itemKey;
  UIImage *imageToDisplay = [[ImageStore sharedStore] imageForKey:itemKey];
  self.imageView.image = imageToDisplay;
  
  NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
  if (!typeLabel) {
    typeLabel = NSLocalizedString(@"None", @"Type label None");
  }
  
  self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type: %@", @"Asset type button"), typeLabel];
  
  [self updateFonts];
  
  if ([_nameTextView.text isEqualToString:@""]) {
    [_nameTextView becomeFirstResponder];
  }
  
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  [self.view endEditing:YES];
  
  Item *item = self.item;
  
  item.itemName = self.nameTextView.text;
  item.itemNotes = self.notesTextView.text;
  item.itemClarity = self.clarityLabel.text;
  item.itemClarityValue = self.claritySlider.value;
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
  item.itemAlchohol = self.alchoholLabel.text;
  item.itemAlchoholValue = self.alchoholStepper.value;
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
  item.itemWinemaker = self.winemakerTextField.text;
  item.itemVintage = self.vintageTextField.text;
  item.itemAppellation = self.appellationTextField.text;
  /*
  item.itemName = self.nameTextView.text;
  item.vintage = self.vintageTextField.text;
  */
  int newValue = [self.priceTextField.text intValue];
  
  if (newValue != item.valueInDollars) {
    item.valueInDollars = newValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:newValue forKey:NextItemValuePrefsKey];
  }
}

@end
