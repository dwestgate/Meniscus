2011 Schrader Cellars Cabernet Sauvignon Beckstoffer To-Kalon Vineyard



Clone Homepwner into a project with a new name
==============================================
1. Create a new xcode project: File | New | Project... | Single Page Application
- Un-check core data
- Universal application

2. Delete:
- Main.storyboard
- LaunchScreen.xib
- ViewController.h
- ViewController.m

3. Select info.plist and delete the reference to Main.storyboard

4. Open Homepwner in Xcode and copy all the .h and .m files from Homepwner into the new project
- Right-click on class name and select Refactor | Rename...
- Delete the "BNR" prefix
- Click the Preview button
- Save

5. Copy over Localizable.strings
- Remove any "BNR" prefixes found

6. Create a new Settings Bundle: File | New | File... | Resource | Settings Bundle
- Name the file after the new project
- Replace the contents of en.lproj/Root.strings with the data from Homepwner
- Duplicate the settings

7. Copy BNRDetailViewController.xib to the new project
- Remove the BNR prefix from the file name
- Connect the view to its controller
  - Select File's owner under Placeholders
  - In the right-hand tab select Identity Inspector and change the class to "DetailViewController"
  - Option-click on DetailViewController and reconnect all the fields

8. Copy BNRItemCell.xib to the new project
- Remove the BNR prefix from the file name
- Connect the view to its controller
  - Select File's owner under Placeholders and select the frame on the canvas
  - In the right-hand tab select Identity Inspector and change the class to "ItemCell"
  - Option-click on ItemCell.m and reconnect all the fields

9. Globally search/replace:
- Replace BNR with ""
- Replace Homepwner with WineTastingJournal

10. Create the data model
- File | New | File... | Core Data | Data Model
- Name the new data model after the project
- Copy all values from the template .xcdatamodeld to this new one
  - Be sure to check the Class setting on each enitity!!! <<<<<<<<
  - Be sure to check the thumbnail attribute's "Name"'!!! <<<<<<<<

11. Customize the build (turn on continuous error checking)
- Open Build Settings
- Search for: analyze during 'build'
- Set to "Yes"

12. Configure Localization
- Select the Project
- Under Project, select the project name
- Open the Info tab
- Find "Use Base Internationalization and add English and Spanish
- Mirror the contents of the localization files in Homepwner


Testing iCloud
==============
1. Set the code to erase the preference flag each run
2. Run and select Local, create a few records
  - No iCloud entry
3. Run and select Local, create a few records
  - List is unexpectadly blank
  - Adding one item causes list to appear
4. Run and select iCloud, create a few records
5. Run and select iCloud, create a few records
6. Run and select Local, create a few records



5. Customize the ItemCell
- Add: Table View Cell
- Add: Image View
- Add: 4 x labels
- wine
- tastedOn
- price
- rating

6. Customize DetailViewController

Name
  nameLabel
  nameTextView

Notes
  notesTextView
  notesLabel

Appearance
  appearanceBanner

Clear
  clarityLabel
  claritySlider

Red
  colorLabel
  colorSlider

Color Intensity
  colorIntensityLabel
  colorIntensityStepper

Garnet
  colorshadeLabel
  colorshadeSlider

Petillance
  petillanceLabel
  petillanceStepper

Viscosity
  viscosityLabel
  viscosityStepper

No sediment
  sedimentLabel
  sedimentSlider

Nose
  noseBanner

Clean
  conditionLabel
  conditionSlider

Intensity
  aromaIntensityLabel
  aromaIntensityStepper

Aromas
  aromasLabel
  aromasTextView

Development
  developmentLabel
  developmentStepper

Palate
  palateBanner

Sweetness
  sweetnessLabel
  sweetnessStepper

Acidity
  acidityLabel
  acidityStepper

Tannin
  tanninLabel
  tanninStepper

Alcohol
  alcoholLabel
  alcoholStepper

Body
  bodyLabel
  bodyStepper

Intensity
  flavorIntensityLabel
  flavorIntensityStepper

Flavors
  flavorsLabel
  flavorsTextView

Balance
  balanceLabel
  balanceSlider

Mousse
  mousseLabel
  mousseStepper

Finish
  finishLabel
  finishStepper

Good quality
  qualityLabel
  qualitySlider

Aging potential
  agingLabel
  agingPicker

Details
  detailsLabel

Winemaker
  winemakerLabel
  winemakerTextField

Vintage
  vintageLabel
  vintageTextField

Appellation
  appelationLabel
  appalationTextField

Price
  priceLabel
  priceTextField


- tastedOnLabel "Tasted on"



2015-08-30 11:15:15.591 WineTastingJournal[12706:925030] Error: unable to find /Users/davidwestgate/Library/Developer/CoreSimulator/Devices/E4F7F09F-90E3-47C4-85E8-CE9E1CF1CACD/data/Containers/Data/Application/DAA98539-248E-4BD6-B288-E120D30315A4/Documents/E573AE02-0BCD-4895-9711-4C74EC02D2C4
