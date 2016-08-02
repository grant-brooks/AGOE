//
//  Main-Controller.swift
//  AGOE (Code Name Cheetah)
//
//  Created by Grant Goodman on 24/06/16.
//  Copyright © 2016 NEOTechnica Corporation. All rights reserved.
//

import UIKit

class MC: UIViewController
{
    //--------------------------------------------------//
    
    //Interface Builder User Interface Elements
    
    //UIButtons
    @IBOutlet weak var buildButton:       UIButton!
    @IBOutlet weak var codeNameButton:    UIButton!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var ntButton:          UIButton!
    
    //UILabels
    @IBOutlet weak var bundleVersionLabel:           UILabel!
    @IBOutlet weak var bundleVersionSubtitleLabel:   UILabel!
    
    @IBOutlet weak var designationLabel:             UILabel!
    @IBOutlet weak var designationSubtitleLabel:     UILabel!
    
    @IBOutlet weak var preReleaseNotifierLabel:      UILabel!
    
    @IBOutlet weak var skuLabel:                     UILabel!
    @IBOutlet weak var skuLabelSubtitleLabel:        UILabel!
    
    @IBOutlet weak var topDesignationLabel:          UILabel!
    @IBOutlet weak var topSkuLabel:                  UILabel!
    @IBOutlet weak var topVersionLabel:              UILabel!
    
    //Other Items
    @IBOutlet var longPress: UILongPressGestureRecognizer!
    
    
    @IBOutlet weak var amountTextField: UITextField!
    
    @IBOutlet weak var screenShotView: UIView!
    
    @IBOutlet weak var timeGradientPickerView: UIPickerView!
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var itWasLabel: UILabel!
    @IBOutlet weak var itWasOutlineLabel: UILabel!
    @IBOutlet weak var carrotLabel: UILabel!
    @IBOutlet weak var holdToCopyLabel: UILabel!
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var dateOutlineButton: UIButton!
    //--------------------------------------------------//
    
    //Non-Interface Builder Elements
    
    //Array Objects
    var uploadArray:   [String]! = []
    var uploadedArray: [String]! = []
    
    //Boolean Objects
    var isAdHocDistribution:   Bool!
    var preReleaseApplication: Bool!
    var screenShotsToggledOn:  Bool!
    var shouldTakeScreenShot:  Bool!
    var uploadedScreenShot:    Bool! = false
    
    //Integer Objects
    let buildNumber =                      Int(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)! + 1
    //let buildNumber =                      Int(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)!
    
    var applicationGenerationAsInteger:    Int!
    var bugFixReleaseNumber:               Int!
    var minorReleaseNumber:                Int!
    var versionChoice:                     Int! = 0
    
    //String Objects
    var applicationCodeName:      String!
    var applicationGeneration:    String!
    var applicationSku:           String!
    var currentCaptureLink:       String!
    var developmentState:         String! = "p"
    var formattedVersionNumber:   String!
    var preReleaseNotifierString: String!
    
    var timeGradientArray = ["days", "weeks", "months", "years"]
    
    var currentYear: Int! = 0
    var dayYear: Int! = 0
    var weekYear: Int! = 0
    var monthYear: Int! = 0
    var yearYear: Int! = 0
    
    var maximumDays: Int! = 0
    var maximumWeeks: Int! = 0
    var maximumMonths: Int! = 0
    var maximumYears: Int! = 0
    
    var dateMinusDays: NSDate!
    var dateMinusWeeks: NSDate!
    var dateMinusMonths: NSDate!
    var dateMinusYears: NSDate!
    
    //--------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Be sure to change the values below.
            //The development state of the application.
            //The code name of the application.
            //The value of the pre-release application boolean.
            //The boolean value determining whether or not the application is ad-hoc.
            //The first digit in the formatted version number.
            //The build number string when archiving.
        
        //Declare and set user defaults.
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if userDefaults.objectForKey("buildNumber") != nil
        {
            if buildNumber == userDefaults.objectForKey("buildNumber") as! Int
            {
                shouldTakeScreenShot = false
            }
            else
            {
                shouldTakeScreenShot = true
            }
        }
        else
        {
            shouldTakeScreenShot = true
        }
        
        if userDefaults.objectForKey("screenShotsToggledOn") != nil
        {
            screenShotsToggledOn = userDefaults.valueForKey("screenShotsToggledOn") as! Bool
        }
        else
        {
            screenShotsToggledOn = false
        }
        
        userDefaults.setValue(buildNumber, forKey: "buildNumber")
        userDefaults.setValue(screenShotsToggledOn, forKey: "screenShotsToggledOn")
        userDefaults.synchronize()
        
        //Make variables declared in the app delegate accesible.
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Set the minor and bug fix release numbers, lifted from the values in the AppDelegate file.
        bugFixReleaseNumber = appDelegate.bugFixReleaseNumber!
        minorReleaseNumber = appDelegate.minorReleaseNumber!
        preReleaseNotifierString = appDelegate.preReleaseNotifierString!
        
        //Declare whether the application is a pre-release version or not, and the project code name.
        applicationCodeName = "Cheetah"
        codeNameButton.setTitle("Project Code Name: " + applicationCodeName, forState: .Normal)
        preReleaseApplication = false
        isAdHocDistribution = false
        
        //Prepare various values to be displayed as version information.
        preReleaseNotifierLabel.text = preReleaseNotifierString
        generateSkuAndDesignation()
        
        //Set the SKU and pre-release notifier for the application.
        skuLabelSubtitleLabel.text = applicationSku
        preReleaseNotifierLabel.text = preReleaseNotifierString
        
        //Format the version number for later display.
        formattedVersionNumber = "2." + String(minorReleaseNumber) + "." + String(bugFixReleaseNumber)
        
        //Determine what is displayed on the 'buildButton' button.
        if versionChoice == 0
        {
            buildButton.setTitle(formattedVersionNumber!, forState: UIControlState.Normal)
        }
        else if versionChoice == 1
        {
            buildButton.setTitle(applicationSku!, forState: UIControlState.Normal)
        }
        else if versionChoice == 2
        {
            buildButton.setTitle(formattedVersionNumber, forState: UIControlState.Normal)
            
            self.buildButton.alpha = 0.0
            self.ntButton.alpha = 1.0
        }
        
        //Set the colour of the status bar.
        UIApplication.sharedApplication().statusBarStyle = .Default
        UIApplication.sharedApplication().statusBarHidden = false
        
        //Determine what to show or hide depending on what kind of release the current build is designated as.
        if preReleaseApplication == false && isAdHocDistribution == false
        {
            codeNameButton.hidden = true
            informationButton.hidden = true
            preReleaseNotifierLabel.hidden = true
            
            bundleVersionLabel.alpha = 0.0
            bundleVersionSubtitleLabel.alpha = 0.0
            
            designationLabel.alpha = 0.0
            designationSubtitleLabel.alpha = 0.0
            
            skuLabel.alpha = 0.0
            skuLabelSubtitleLabel.alpha = 0.0
            
            buildButton.hidden = false
            ntButton.hidden = false
        }
        else
        {
            bundleVersionLabel.alpha = 0.0
            bundleVersionSubtitleLabel.alpha = 0.0
            
            designationLabel.alpha = 0.0
            designationSubtitleLabel.alpha = 0.0
            
            skuLabel.alpha = 0.0
            skuLabelSubtitleLabel.alpha = 0.0
        }
        
        //Determine the application version number and display it on the 'bundleVersionSubtitleLabel' label.
        let applicationVersionNumber = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        bundleVersionSubtitleLabel.text = applicationVersionNumber
        
        //Set the 'uploadArray' array to the array of files in the local documents folder.
        uploadArray = arrayOfFilesInDocumentsFolder()
        
        //Set the proposed web link to the current capture.
        currentCaptureLink = "http://www.grantbrooksgoodman.io/APPLICATIONS/\(applicationCodeName.uppercaseString)/\(applicationSku)"
        
        amountTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        amountTextField.font = UIFont(name: "PontiacInlineShadow", size: 30)
        
        dateButton.titleLabel!.adjustsFontSizeToFitWidth = true
        dateOutlineButton.titleLabel!.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        topVersionLabel.text = formattedVersionNumber
        topSkuLabel.text = applicationSku
        topDesignationLabel.text = designationSubtitleLabel.text!
        
        if shouldTakeScreenShot == true || uploadArray.count > 0
        {
            if preReleaseApplication == true
            {
                NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: #selector(screenShot), userInfo: nil, repeats: false)
            }
            else
            {
                screenShotView.hidden = true
            }
        }
        else
        {
            screenShotView.hidden = true
        }
    }
    
    //--------------------------------------------------//
    
    //Interface Builder Actions
    
    @IBAction func buildButton(sender: AnyObject)
    {
        //Determine what to display for each setting of the build button.
        if buildButton.titleLabel!.text == formattedVersionNumber
        {
            buildButton.setTitle(applicationSku, forState: UIControlState.Normal)
            versionChoice = 1
        }
        else if buildButton.titleLabel!.text == applicationSku
        {
            buildButton.setTitle(formattedVersionNumber, forState: UIControlState.Normal)
            versionChoice = 2
            
            self.buildButton.alpha = 0.0
            
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    self.ntButton.alpha = 1.0
                    
                }, completion: nil)
        }
    }
    
    @IBAction func codeNameButton(sender: AnyObject)
    {
        if designationLabel.alpha == 0.0
        {
            //Animate the display of various elements of the view.
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    self.bundleVersionLabel.alpha = 1.0
                    self.bundleVersionSubtitleLabel.alpha = 1.0
                    
                    self.designationLabel.alpha = 1.0
                    self.designationSubtitleLabel.alpha = 1.0
                    
                    self.skuLabel.alpha = 1.0
                    self.skuLabelSubtitleLabel.alpha = 1.0
                    
                }, completion: nil)
        }
        else
        {
            //Animate the hide of various elements of the view.
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    self.bundleVersionLabel.alpha = 0.0
                    self.bundleVersionSubtitleLabel.alpha = 0.0
                    
                    self.designationLabel.alpha = 0.0
                    self.designationSubtitleLabel.alpha = 0.0
                    
                    self.skuLabel.alpha = 0.0
                    self.skuLabelSubtitleLabel.alpha = 0.0
                    
                }, completion: nil)
        }
    }
    
    @IBAction func informationButton(sender: AnyObject)
    {
        //Determine and set the reported development state, depending on the state of various prerequisites.
        if developmentState == "i"
        {
            developmentState = "for use by internal developers only"
        }
        else if developmentState == "p"
        {
            developmentState = "for limited outside user testing"
        }
        
        //Declare, set, and display the 'informationAlertController' alert controller.
        let informationAlertController = UIAlertController(title: "Project \(applicationCodeName.capitalizedString)", message: "This is a pre-release version of project code name \(applicationCodeName).\n\nThis version is meant \(developmentState).\n\nAll features presented here are subject to change, and any new or previously undisclosed information presented within this software is to remain strictly confidential.\n\nRedistribution of this software by unauthorised parties in any way, shape, or form is strictly prohibited.\n\nBy continuing your use of this software, you acknowledge your agreement to the above terms.", preferredStyle: UIAlertControllerStyle.Alert)
        informationAlertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        
        if uploadedScreenShot == true
        {
            informationAlertController.addAction(UIAlertAction(title: "View Current Online Capture", style: .Default, handler: { (action: UIAlertAction!) in
                UIApplication.sharedApplication().openURL(NSURL(string: "\(self.currentCaptureLink).png")!)
            }))
        }
        
        if screenShotsToggledOn == true
        {
            informationAlertController.addAction(UIAlertAction(title: "Disable Self-Capture", style: .Destructive, handler: { (action: UIAlertAction!) in
                self.screenShotsToggledOn = false
                NSUserDefaults.standardUserDefaults().setValue(self.screenShotsToggledOn, forKey: "screenShotsToggledOn")
                NSUserDefaults.standardUserDefaults().synchronize()
            }))
        }
        else
        {
            informationAlertController.addAction(UIAlertAction(title: "Enable Self-Capture", style: .Default, handler: { (action: UIAlertAction!) in
                self.screenShotsToggledOn = true
                NSUserDefaults.standardUserDefaults().setValue(self.screenShotsToggledOn, forKey: "screenShotsToggledOn")
                NSUserDefaults.standardUserDefaults().synchronize()
            }))
        }
        
        self.presentViewController(informationAlertController, animated: true, completion: nil)
    }
    
    @IBAction func longPress(sender: AnyObject)
    {
        //Copy the text of the build button to the clipboard.
        let pasteBoard = UIPasteboard.generalPasteboard()
        pasteBoard.string = buildButton.titleLabel!.text
    }
    
    @IBAction func dateButton(sender: AnyObject)
    {
        if dateButton.titleLabel!.text != nil
        {
            //Copy the text of the date to the clipboard.
            let pasteBoard = UIPasteboard.generalPasteboard()
            pasteBoard.string = dateButton.titleLabel!.text!
            
            PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: "Copied", subtitle: "")
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 1.0, completion: nil)
        }
    }
    
    @IBAction func ntButton(sender: AnyObject)
    {
        //Set the alpha of the 'ntButton' button and version choice.
        self.ntButton.alpha = 0.0
        versionChoice = 0
        
        //Animate the display of the build button.
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
                self.buildButton.alpha = 1.0
                
            }, completion: nil)
    }
    
    //--------------------------------------------------//
    
    //Inependent Functions
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return timeGradientArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return "\(timeGradientArray[row])"
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        let titleData = timeGradientArray[row]
        
        let attributedTitle = NSAttributedString(string: String(titleData), attributes: [NSFontAttributeName: UIFont(name: "PontiacInlineRegular", size: 20)!, NSForegroundColorAttributeName: UIColor.darkTextColor()])
        
        return attributedTitle
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        if timeGradientArray.count > 0
        {
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    self.amountTextField.frame.origin.x = 20
                    self.timeGradientPickerView.alpha = 1.0
                    self.dateButton.alpha = 1.0
                    self.dateOutlineButton.alpha = 1.0
                    self.carrotLabel.alpha = 1.0
                    self.holdToCopyLabel.alpha = 1.0
                    
                }, completion: nil)
            
            if timeGradientArray[row] == "days"
            {
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                    {
                        self.separatorView.alpha = 1.0
                        self.itWasLabel.alpha = 1.0
                        self.itWasOutlineLabel.alpha = 1.0
                        self.dateButton.alpha = 1.0
                        self.dateOutlineButton.alpha = 1.0
                        self.carrotLabel.alpha = 1.0
                        self.holdToCopyLabel.alpha = 1.0
                        
                    }, completion: nil)
                
                dateButton.setTitle(dateFormatter.stringFromDate(dateMinusDays), forState: .Normal)
                dateOutlineButton.setTitle(dateFormatter.stringFromDate(dateMinusDays), forState: .Normal)
            }
            else if timeGradientArray[row] == "weeks"
            {
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                    {
                        self.separatorView.alpha = 1.0
                        self.itWasLabel.alpha = 1.0
                        self.itWasOutlineLabel.alpha = 1.0
                        self.dateButton.alpha = 1.0
                        self.dateOutlineButton.alpha = 1.0
                        self.carrotLabel.alpha = 1.0
                        self.holdToCopyLabel.alpha = 1.0
                        
                    }, completion: nil)
                
                dateButton.setTitle(dateFormatter.stringFromDate(dateMinusWeeks), forState: .Normal)
                dateOutlineButton.setTitle(dateFormatter.stringFromDate(dateMinusWeeks), forState: .Normal)
            }
            else if timeGradientArray[row] == "months"
            {
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                    {
                        self.separatorView.alpha = 1.0
                        self.itWasLabel.alpha = 1.0
                        self.itWasOutlineLabel.alpha = 1.0
                        self.dateButton.alpha = 1.0
                        self.dateOutlineButton.alpha = 1.0
                        self.carrotLabel.alpha = 1.0
                        self.holdToCopyLabel.alpha = 1.0
                        
                    }, completion: nil)
                
                dateButton.setTitle(dateFormatter.stringFromDate(dateMinusMonths), forState: .Normal)
                dateOutlineButton.setTitle(dateFormatter.stringFromDate(dateMinusMonths), forState: .Normal)
            }
            else if timeGradientArray[row] == "years"
            {
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                    {
                        self.separatorView.alpha = 1.0
                        self.itWasLabel.alpha = 1.0
                        self.itWasOutlineLabel.alpha = 1.0
                        self.dateButton.alpha = 1.0
                        self.dateOutlineButton.alpha = 1.0
                        self.carrotLabel.alpha = 1.0
                        self.holdToCopyLabel.alpha = 1.0
                        
                    }, completion: nil)
                
                dateButton.setTitle(dateFormatter.stringFromDate(dateMinusYears), forState: .Normal)
                dateOutlineButton.setTitle(dateFormatter.stringFromDate(dateMinusYears), forState: .Normal)
            }
        }
        else
        {
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    if UIScreen.mainScreen().bounds.height != 568
                    {
                        self.amountTextField.frame.origin.x = 89
                    }
                    else
                    {
                        self.amountTextField.frame.origin.x = 60
                    }
                    
                    self.timeGradientPickerView.alpha = 0.0
                    self.separatorView.alpha = 0.0
                    self.itWasLabel.alpha = 0.0
                    self.itWasOutlineLabel.alpha = 0.0
                    self.dateButton.alpha = 0.0
                    self.dateOutlineButton.alpha = 0.0
                    self.carrotLabel.alpha = 0.0
                    self.holdToCopyLabel.alpha = 0.0
                    
                }, completion: nil)
        }
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        let amountStringArray = textField.text!.stringByReplacingOccurrencesOfString(",", withString: "").componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        textField.text = amountStringArray.joinWithSeparator("")
        
        if textField.text!.stringByReplacingOccurrencesOfString(",", withString: "").characters.count > 6
        {
            textField.text = textField.text!.stringByReplacingOccurrencesOfString(",", withString: "").chopSuffix(1)
        }
        
        setAccurateDateValues()
        
        textField.adjustsFontSizeToFitWidth = true
        
        if textField.text!.stringByReplacingOccurrencesOfString(",", withString: "") != "" && Int(textField.text!.stringByReplacingOccurrencesOfString(",", withString: "")) != nil
        {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            textField.text = numberFormatter.stringFromNumber(Int(textField.text!)!)!
            
            if Int(textField.text!.stringByReplacingOccurrencesOfString(",", withString: "")) < maximumDays
            {
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                    {
                        self.amountTextField.frame.origin.x = 20
                        self.timeGradientPickerView.alpha = 1.0
                        self.dateButton.alpha = 1.0
                        self.dateOutlineButton.alpha = 1.0
                        self.carrotLabel.alpha = 1.0
                        self.holdToCopyLabel.alpha = 1.0
                        
                    }, completion: nil)
                
                if (dayYear > currentYear || Int(textField.text!.stringByReplacingOccurrencesOfString(",", withString: "")) > maximumDays) && timeGradientArray.contains("days")
                {
                    timeGradientArray.removeAtIndex(timeGradientArray.indexOf("days")!)
                    timeGradientPickerView.reloadAllComponents()
                }
                else if (dayYear < currentYear || Int(textField.text!.stringByReplacingOccurrencesOfString(",", withString: "")) < maximumDays) && !timeGradientArray.contains("days")
                {
                    timeGradientArray.append("days")
                    timeGradientPickerView.reloadAllComponents()
                }
                
                if (weekYear > currentYear || Int(textField.text!.stringByReplacingOccurrencesOfString(",", withString: "")) > maximumWeeks) && timeGradientArray.contains("weeks")
                {
                    timeGradientArray.removeAtIndex(timeGradientArray.indexOf("weeks")!)
                    timeGradientPickerView.reloadAllComponents()
                }
                else if (weekYear < currentYear || Int(textField.text!.stringByReplacingOccurrencesOfString(",", withString: "")) < maximumWeeks) && !timeGradientArray.contains("weeks")
                {
                    timeGradientArray.append("weeks")
                    timeGradientPickerView.reloadAllComponents()
                }
                
                if (monthYear > currentYear || Int(textField.text!.stringByReplacingOccurrencesOfString(",", withString: "")) > maximumMonths) && timeGradientArray.contains("months")
                {
                    timeGradientArray.removeAtIndex(timeGradientArray.indexOf("months")!)
                    timeGradientPickerView.reloadAllComponents()
                }
                else if (monthYear < currentYear || Int(textField.text!.stringByReplacingOccurrencesOfString(",", withString: "")) < maximumMonths) && !timeGradientArray.contains("months")
                {
                    timeGradientArray.append("months")
                    timeGradientPickerView.reloadAllComponents()
                }
                
                if (yearYear > currentYear || Int(textField.text!.stringByReplacingOccurrencesOfString(",", withString: "")) > currentYear) && timeGradientArray.contains("years")
                {
                    timeGradientArray.removeAtIndex(timeGradientArray.indexOf("years")!)
                    timeGradientPickerView.reloadAllComponents()
                }
                else if (yearYear < currentYear || Int(textField.text!.stringByReplacingOccurrencesOfString(",", withString: "")) < currentYear) && !timeGradientArray.contains("years")
                {
                    timeGradientArray.append("years")
                    timeGradientPickerView.reloadAllComponents()
                }
                
                pickerView(timeGradientPickerView, didSelectRow: timeGradientPickerView.selectedRowInComponent(0), inComponent: 0)
            }
            else
            {
                UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                    {
                        if UIScreen.mainScreen().bounds.height != 568
                        {
                            self.amountTextField.frame.origin.x = 89
                        }
                        else
                        {
                            self.amountTextField.frame.origin.x = 60
                        }
                        
                        self.timeGradientPickerView.alpha = 0.0
                        self.separatorView.alpha = 0.0
                        self.itWasLabel.alpha = 0.0
                        self.itWasOutlineLabel.alpha = 0.0
                        self.dateButton.alpha = 0.0
                        self.dateOutlineButton.alpha = 0.0
                        self.carrotLabel.alpha = 0.0
                        self.holdToCopyLabel.alpha = 0.0
                        
                    }, completion: nil)
            }
        }
        else
        {
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    if UIScreen.mainScreen().bounds.height != 568
                    {
                        self.amountTextField.frame.origin.x = 89
                    }
                    else
                    {
                        self.amountTextField.frame.origin.x = 60
                    }
                    
                    self.timeGradientPickerView.alpha = 0.0
                    self.separatorView.alpha = 0.0
                    self.itWasLabel.alpha = 0.0
                    self.itWasOutlineLabel.alpha = 0.0
                    self.dateButton.alpha = 0.0
                    self.dateOutlineButton.alpha = 0.0
                    self.carrotLabel.alpha = 0.0
                    self.holdToCopyLabel.alpha = 0.0
                    
                }, completion: nil)
        }
    }
    
    func setAccurateDateValues()
    {
        if amountTextField.text!.stringByReplacingOccurrencesOfString(",", withString: "") != ""
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            dateFormatter.locale = NSLocale.currentLocale()
            
            let currentDate = NSDate()
            let currentCalendar = NSCalendar.currentCalendar()
            let calendarComponents = currentCalendar.components([.Year], fromDate: currentDate)
            currentYear = calendarComponents.year
            
            maximumDays = currentYear * 365
            maximumWeeks = currentYear * 52
            maximumMonths = currentYear * 12
            
            let dayCalendarComponents = currentCalendar.components([.Year], fromDate: NSDate.changeDaysBy(-Int(amountTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ""))!))
            dateMinusDays = NSDate.changeDaysBy(-Int(amountTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ""))!)
            dayYear = dayCalendarComponents.year
            
            let weekCalendarComponents = currentCalendar.components([.Year], fromDate: NSDate.changeDaysBy(-(Int(amountTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ""))! * 7)))
            dateMinusWeeks = NSDate.changeDaysBy(-(Int(amountTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ""))! * 7))
            weekYear = weekCalendarComponents.year
            
            dateMinusMonths = NSCalendar.currentCalendar().dateByAddingUnit(.Month, value: -Int(amountTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ""))!, toDate: NSDate(), options: [])
            let monthCalendarComponents = currentCalendar.components([.Year], fromDate: dateMinusMonths!)
            monthYear = monthCalendarComponents.year
            
            dateMinusYears = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -Int(amountTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ""))!, toDate: NSDate(), options: [])
            let yearCalendarComponents = currentCalendar.components([.Year], fromDate: dateMinusYears!)
            yearYear = yearCalendarComponents.year
        }
    }
    
    func generateSkuAndDesignation()
    {
        //Declare and set the application's build date.
        let applicationBuildDate = NSBundle.mainBundle().infoDictionary!["CFBuildDate"] as! NSDate
        
        //Declare and set the date that the application was compiled.
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "ddMM"
        let skuDate: String = dateFormatter.stringFromDate(applicationBuildDate)
        
        //Declare and set the name of the application.
        var applicationName = applicationCodeName
        
        //Format the name of the application for display in the SKU.
        if applicationName.length > 3
        {
            applicationName = applicationName.chopSuffix(applicationName.length - 3)
        }
        else if applicationName.length == 3
        {
            applicationName = applicationName.chopSuffix(applicationName.length)
        }
        
        //Format the build number for the SKU.
        var formattedBuildNumberAsString: String! = String(buildNumber)
        if formattedBuildNumberAsString.length < 4 && formattedBuildNumberAsString.length < 5
        {
            if formattedBuildNumberAsString.length == 1
            {
                formattedBuildNumberAsString = "000" + formattedBuildNumberAsString
            }
            else if formattedBuildNumberAsString.length == 2
            {
                formattedBuildNumberAsString = "00" + formattedBuildNumberAsString
            }
            else if formattedBuildNumberAsString.length == 3
            {
                formattedBuildNumberAsString = "0" + formattedBuildNumberAsString
            }
            
            applicationGeneration = 1.ordinalValue
            applicationGenerationAsInteger = 1
        }
        else if formattedBuildNumberAsString.length == 4
        {
            applicationGeneration = 1.ordinalValue
            applicationGenerationAsInteger = 1
        }
        else if formattedBuildNumberAsString.length >= 5
        {
            let formattedBuildNumberAsStringAsDouble = Double(formattedBuildNumberAsString)
            let firstSubtractedBuildNumber = Int((formattedBuildNumberAsStringAsDouble! / 10000) + 1)
            let secondSubtractedBuildNumber = (firstSubtractedBuildNumber - 1) * 10000
            let thirdSubtractedBuildNumber = secondSubtractedBuildNumber - Int(formattedBuildNumberAsStringAsDouble!)
            
            formattedBuildNumberAsString = String(thirdSubtractedBuildNumber).stringByReplacingOccurrencesOfString("-", withString: "")
            
            if formattedBuildNumberAsString.length == 1
            {
                formattedBuildNumberAsString = "000" + formattedBuildNumberAsString
            }
            else if formattedBuildNumberAsString.length == 2
            {
                formattedBuildNumberAsString = "00" + formattedBuildNumberAsString
            }
            else if formattedBuildNumberAsString.length == 3
            {
                formattedBuildNumberAsString = "0" + formattedBuildNumberAsString
            }
            
            applicationGeneration = String(Int((formattedBuildNumberAsStringAsDouble! / 10000) + 1).ordinalValue)
            applicationGenerationAsInteger = Int((formattedBuildNumberAsStringAsDouble! / 10000) + 1)
        }
        
        //Set the development state designation label text.
        if developmentState == "p" && preReleaseApplication == false
        {
            designationSubtitleLabel.text = "PUB-DIS"
        }
        else if developmentState == "p" && preReleaseApplication == true
        {
            designationSubtitleLabel.text = "PUB-TES"
        }
        else if developmentState == "i" && preReleaseApplication == false
        {
            designationSubtitleLabel.text = "INT-DIS"
        }
        else if developmentState == "i" && preReleaseApplication == true
        {
            designationSubtitleLabel.text = "INT-TES"
        }
        
        var applicationGenerationAsIntegerAsString: String! = ""
        
        if String(applicationGenerationAsInteger).characters.count == 1
        {
            applicationGenerationAsIntegerAsString = "0" + String(applicationGenerationAsInteger)
        }
        else if String(applicationGenerationAsInteger).characters.count == 2
        {
            applicationGenerationAsIntegerAsString = String(applicationGenerationAsInteger)
        }
        
        //Set the application SKU.
        applicationSku = "\(skuDate)-\(applicationName.uppercaseString)-\(applicationGenerationAsIntegerAsString + formattedBuildNumberAsString)"
    }
    
    func setButtonElementsForWhiteRoundedButton(roundedButton: WRB, buttonTitle: String, buttonTarget: String?, buttonEnabled: Bool)
    {
        if buttonEnabled == true
        {
            roundedButton.layer.borderColor = UIColor.whiteColor().CGColor
            roundedButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            roundedButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            
            roundedButton.enabled = true
            roundedButton.userInteractionEnabled = true
        }
        else
        {
            roundedButton.layer.borderColor = UIColor.grayColor().CGColor
            roundedButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            roundedButton.enabled = false
            roundedButton.userInteractionEnabled = false
        }
        
        roundedButton.layer.borderWidth = 1.0
        roundedButton.layer.cornerRadius = 5.0
        roundedButton.alpha = 0.600000023841858
        roundedButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        roundedButton.setTitle(buttonTitle.uppercaseString, forState: UIControlState.Normal)
        
        if buttonTarget != nil
        {
            let buttonTargetSelector: Selector = NSSelectorFromString(buttonTarget!)
            roundedButton.addTarget(self, action: buttonTargetSelector, forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func setButtonElementsForBlackRoundedButton(roundedButton: BRB, buttonTitle: String, buttonTarget: String?, buttonEnabled: Bool)
    {
        if buttonEnabled == true
        {
            roundedButton.layer.borderColor = UIColor.blackColor().CGColor
            roundedButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            roundedButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
            
            roundedButton.enabled = true
            roundedButton.userInteractionEnabled = true
        }
        else
        {
            roundedButton.layer.borderColor = UIColor.grayColor().CGColor
            roundedButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            roundedButton.enabled = false
            roundedButton.userInteractionEnabled = false
        }
        
        roundedButton.layer.borderWidth = 1.0
        roundedButton.layer.cornerRadius = 5.0
        roundedButton.alpha = 0.600000023841858
        roundedButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        roundedButton.setTitle(buttonTitle.uppercaseString, forState: UIControlState.Normal)
        
        if buttonTarget != nil
        {
            let buttonTargetSelector: Selector = NSSelectorFromString(buttonTarget!)
            roundedButton.addTarget(self, action: buttonTargetSelector, forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
    
    func getDocumentsDirectory() -> NSString
    {
        let searchPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = searchPaths[0]
        
        return documentsDirectory
    }
    
    func removeItemFromDocumentsFolder(itemName: String)
    {
        do
        {
            try NSFileManager.defaultManager().removeItemAtPath("\(getDocumentsDirectory())/\(itemName)")
        }
        catch let occurredError as NSError
        {
            print(occurredError.debugDescription)
        }
    }
    
    func arrayOfFilesInDocumentsFolder() -> [String]
    {
        do
        {
            let allItems = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(getDocumentsDirectory() as String)
            
            return allItems
        }
        catch let occurredError as NSError
        {
            print(occurredError.debugDescription)
        }
        
        return []
    }
    
    func screenShot() -> UIImage
    {
        let keyWindowLayer = UIApplication.sharedApplication().keyWindow!.layer
        let mainScreenScale = UIScreen.mainScreen().scale
        
        UIGraphicsBeginImageContextWithOptions(keyWindowLayer.frame.size, false, mainScreenScale);
        
        self.view?.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let screenShot = UIGraphicsGetImageFromCurrentImageContext()
        
        if screenShotsToggledOn == true
        {
            UIImageWriteToSavedPhotosAlbum(screenShot, nil, nil, nil)
        }
        
        UIGraphicsEndImageContext()
        
        screenShotView.hidden = true
        
        if let pngData = UIImagePNGRepresentation(screenShot)
        {
            let fileName = getDocumentsDirectory().stringByAppendingPathComponent("\(applicationSku).png")
            uploadArray.append("\(applicationSku).png")
            pngData.writeToFile(fileName, atomically: true)
        }
        
        var sessionConfiguration = SessionConfiguration()
        sessionConfiguration.host = "ftp://ftp.grantbrooksgoodman.io/"
        sessionConfiguration.username = "grantgoodman"
        sessionConfiguration.password = "Grantavery123"
        
        let currentSession = Session(configuration: sessionConfiguration)
        
        currentSession.createDirectory("/public_html/APPLICATIONS/\(self.applicationCodeName.uppercaseString)")
        {
            (result, error) -> Void in
            
            if error == nil
            {
                print("Made new directory for application.")
            }
            else
            {
                print("Application directory already exists.")
            }
            
            self.uploadArray.removeAtIndex(0)
            self.uploadedArray = self.uploadArray
            
            for individualObject in self.uploadArray
            {
                currentSession.upload(NSURL(fileURLWithPath: self.getDocumentsDirectory().stringByAppendingPathComponent(individualObject)), path: "/public_html/APPLICATIONS/\(self.applicationCodeName.uppercaseString)/\(individualObject)")
                {
                    (result, error) -> Void in
                    
                    if error == nil
                    {
                        print("http://www.grantbrooksgoodman.io/APPLICATIONS/\(self.applicationCodeName.uppercaseString)/\(individualObject)")
                        self.removeItemFromDocumentsFolder(individualObject)
                        
                        self.uploadedScreenShot = true
                    }
                    else
                    {
                        print("There was an error while uploading the screen-shot.")
                        print(error!.localizedDescription)
                        
                        self.uploadedScreenShot = false
                    }
                }
            }
        }
        
        return screenShot
    }
}

extension NSDate
{
    static func changeDaysBy(amountOfDays: Int) -> NSDate
    {
        let currentDate = NSDate()
        let dateComponents = NSDateComponents()
        
        dateComponents.day = amountOfDays
        
        return NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
    }
}
