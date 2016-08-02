//
//  AppDelegate.swift
//  AGOE (Code Name Cheetah)
//
//  Created by Grant Goodman on 24/06/16.
//  Copyright © 2016 NEOTechnica Corporation. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    //--------------------------------------------------//
    
    //Non-Interface Builder Elements
    
    //Integer Values
    var bugFixReleaseNumber: Int?
    var buildNumber: Int?
    var minorReleaseNumber: Int?
    
    //String Values
    var preReleaseNotifierString: String!
    
    //Other Items
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var window: UIWindow?
    
    //--------------------------------------------------//
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        //Set the build number as an integer.
        buildNumber = Int(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)! + 1
        //buildNumber = Int(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String)!
        
        //Set the minor release number.
        minorReleaseNumber = buildNumber! / 150
        
        if minorReleaseNumber == nil
        {
            minorReleaseNumber = 0
        }
        
        //Set the bug fix release number.
        bugFixReleaseNumber = buildNumber! / 50
        
        if bugFixReleaseNumber == nil
        {
            bugFixReleaseNumber = 0
        }
        
        //Determine the pre-release notifier string.
        let preReleaseNotifierStringArray = ["For testing purposes only.", "Evaluation version.", "Redistribution is prohibited.", "All features subject to change.", "For use by authorised parties only.", "Contents strictly confidential.", "This is pre-release software.", "Not for public use."]
        
        let randomIntegerValue = randomInteger(0, maximumValue: preReleaseNotifierStringArray.count - 1)
        preReleaseNotifierString = preReleaseNotifierStringArray[randomIntegerValue]
        
        //Determine the height of the screen, and set the preferred storyboard file accordingly.
        if screenSize.height == 667
        {
            let storyboard = UIStoryboard(name: "4.7 Inch", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("MC")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        else if screenSize.height == 568
        {
            let storyboard = UIStoryboard(name: "4 Inch", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("MC")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        else if screenSize.height == 480
        {
            let storyboard = UIStoryboard(name: "3.5 Inch", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("MC")
            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
    
        return true
    }

    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

///Function that sets the background image on a UIView.
func setBackgroundImageForView(chosenView: UIView!, backgroundImageName: String!)
{
    UIGraphicsBeginImageContext(chosenView.frame.size)
    
    UIImage(named: backgroundImageName)?.drawInRect(chosenView.bounds)
    
    let imageToSet: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    chosenView.backgroundColor = UIColor(patternImage: imageToSet)
}

///Function that rounds the vertical corners on any desired object. Accepts 'left' and 'right' as strings.
func roundVerticalCornersOnObject(objectToRound: AnyObject!, sideToRound: String!)
{
    var topCorner: UIRectCorner!
    var bottomCorner: UIRectCorner!
    
    if sideToRound.noWhiteSpaceLowerCaseString == "left"
    {
        topCorner = UIRectCorner.TopLeft
        bottomCorner = UIRectCorner.BottomLeft
    }
    else if sideToRound.noWhiteSpaceLowerCaseString == "right"
    {
        topCorner = UIRectCorner.TopRight
        bottomCorner = UIRectCorner.BottomRight
    }
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: objectToRound!.bounds,
                                              byRoundingCorners: [topCorner, bottomCorner],
                                              cornerRadii: CGSize(width: 5.0, height: 5.0))
    
    let maskLayer: CAShapeLayer = CAShapeLayer()
    
    maskLayer.frame = objectToRound!.bounds
    maskLayer.path = maskPath.CGPath
    
    objectToRound!.layer.mask = maskLayer
    objectToRound!.layer.masksToBounds = false
    objectToRound!.view?!.clipsToBounds = true
}

///Function that rounds the horizontal corners on any desired object. Accepts 'top' and 'bottom' as strings.
func roundHorizontalCornersOnObject(objectToRound: AnyObject!, sideToRound: String!)
{
    var leftCorner: UIRectCorner!
    var rightCorner: UIRectCorner!
    
    if sideToRound.noWhiteSpaceLowerCaseString == "top"
    {
        leftCorner = UIRectCorner.TopLeft
        rightCorner = UIRectCorner.TopRight
    }
    else if sideToRound.noWhiteSpaceLowerCaseString == "bottom"
    {
        leftCorner = UIRectCorner.BottomLeft
        rightCorner = UIRectCorner.BottomRight
    }
    
    let maskPath: UIBezierPath = UIBezierPath(roundedRect: objectToRound!.bounds,
                                              byRoundingCorners: [leftCorner, rightCorner],
                                              cornerRadii: CGSize(width: 5.0, height: 5.0))
    
    let maskLayer: CAShapeLayer = CAShapeLayer()
    
    maskLayer.frame = objectToRound!.bounds
    maskLayer.path = maskPath.CGPath
    
    objectToRound!.layer.mask = maskLayer
    objectToRound!.layer.masksToBounds = false
    objectToRound!.view?!.clipsToBounds = true
}

func randomInteger(minimumValue: Int, maximumValue: Int) -> Int
{
    return minimumValue + Int(arc4random_uniform(UInt32(maximumValue - minimumValue + 1)))
}

func colorWithHexString (hex:String) -> UIColor
{
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).noWhiteSpaceLowerCaseString
    
    if (cString.hasPrefix("#"))
    {
        cString = (cString as NSString).substringFromIndex(1)
    }
    
    if (cString.characters.count != 6)
    {
        return UIColor.grayColor()
    }
    
    let rString = (cString as NSString).substringToIndex(2)
    let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
    let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
    
    var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
    NSScanner(string: rString).scanHexInt(&r)
    NSScanner(string: gString).scanHexInt(&g)
    NSScanner(string: bString).scanHexInt(&b)
    
    return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
}

extension Array
{
    var shuffledValue: [Element]
    {
        var arrayElements = self
        
        for individualIndex in 0..<arrayElements.count
        {
            swap(&arrayElements[individualIndex], &arrayElements[Int(arc4random_uniform(UInt32(arrayElements.count-individualIndex)))+individualIndex])
        }
        
        return arrayElements
    }
    
    var chooseOne: Element
    {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
}

extension Int
{
    var arrayValue: [Int]
    {
        return description.characters.map{Int(String($0)) ?? 0}
    }
    
    var ordinalValue: String
        {
        get
        {
            var suffix = "th"
            switch self % 10
            {
            case 1:
                suffix = "st"
            case 2:
                suffix = "nd"
            case 3:
                suffix = "rd"
            default: ()
            }
            
            if 10 < (self % 100) && (self % 100) < 20
            {
                suffix = "th"
            }
            
            return String(self) + suffix
        }
    }
}

extension String
{
    var noWhiteSpaceLowerCaseString: String { return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).lowercaseString }
    
    var letterValue: Int
    {
        return Array("abcdefghijklmnopqrstuvwxyz".characters).indexOf(Character(lowercaseString))?.successor() ?? 0
    }
    
    var jumbledValue: String
    {
        return String(Array(arrayLiteral: self).shuffledValue)
    }
    
    var length: Int { return characters.count }
    
    func removeWhitespace() -> String
    {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
    
    func chopPrefix(countToChop: Int = 1) -> String
    {
        return self.substringFromIndex(self.startIndex.advancedBy(characters.count - countToChop))
    }
    
    func chopSuffix(countToChop: Int = 1) -> String
    {
        return self.substringToIndex(self.startIndex.advancedBy(characters.count - countToChop))
    }
}

