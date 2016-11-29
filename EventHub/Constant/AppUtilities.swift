//
//  AppUtilities.swift
//
//  Created by Bigscal 
//  Copyright (c) 2014 Bigscal. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class AppUtilities : NSObject{
    
    /*========================================================
    * function Name: setButtonCorner
    * function Purpose: to set button corner
    * function Parameters: btn: UIButton
    * function ReturnType: nil
    *=======================================================*/
    class func setButtonCorner(btn: UIButton) {

        btn.layer.cornerRadius = 5.0
    }
    
    /*========================================================
    * function Name: setCircleImage
    * function Purpose: to set button corner
    * function Parameters: btn: UIButton
    * function ReturnType: nil
    *=======================================================*/
    class func setCircleImage(btn: AnyObject) {
        btn.layer.cornerRadius = btn.frame.size.height / 2
        btn.layer.masksToBounds = true
    }
    
    /*========================================================
    * function Name: setButtonTextAlignment
    * function Purpose: to set button text alignment
    * function Parameters: btn: UIButton
    * function ReturnType: nil
    *=======================================================*/
    class func setButtonTextAlignment(btn: UIButton,alignment: UIControlContentHorizontalAlignment) {
        btn.contentHorizontalAlignment = alignment
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -2)
    }
    
    /*========================================================
    * function Name: addRightLayer
    * function Purpose: to set right side border
    * function Parameters: btn: UIButton
    * function ReturnType: nil
    *=======================================================*/
    class func addRightLayer(imgView : UIImageView,color:UIColor,width:CGFloat) {
       
        let subLayer=CALayer()
        subLayer.backgroundColor=color.CGColor
        subLayer.frame=CGRectMake(imgView.bounds.size.width-1, 0, width, imgView.frame.size.height)
        imgView.layer.addSublayer(subLayer)

    }

    /*========================================================
    * function Name: setLabelBGColorNTextColor
    * function Purpose: to set BGColor and Text Color of UILabel
    * function Parameters: bgColor: UIColor,textColor: UIColor,multiLbl : UILabel...
    * function ReturnType: nil
    *=======================================================*/
    class func setLabelBGColorNTextColor(bgColor: UIColor,textColor: UIColor,multiLbl : UILabel...) {
        for lbl:UILabel in multiLbl {
            lbl.backgroundColor = bgColor
            lbl.textColor = textColor
        }
    }
    
    /*========================================================
    * function Name: setImageInBuuton
    * function Purpose: to set image in the button
    * function Parameters: btn: AnyObject,frame: CGRect,imgName: NSString
    * function ReturnType: nil
    *=======================================================*/
    class func setImageInBuuton(btn: AnyObject,frame: CGRect,imgName: NSString) {
        let imgView: UIImageView = UIImageView(frame: frame)
        imgView.image = UIImage(named: imgName as String)
        btn.addSubview(imgView)
    }
    /*========================================================
    * function Name: setViewCorner
    * function Purpose: to set the corner radius of uiview
    * function Parameters: view: UIView,radius: CGFloat,width: CGFloat,color: UIColor
    * function ReturnType: nil
    *=======================================================*/
    class func setViewCorner(view: UIView,radius: CGFloat,width: CGFloat,color: UIColor) {
        
        view.layer.cornerRadius = radius
        view.layer.borderWidth = width
        view.layer.borderColor = color.CGColor
    }
    
    /*========================================================
    * function Name: setScrollViewContentSize
    * function Purpose: to set content size of scrollview
    * function Parameters: scrollView: UIScrollView,width: CGFloat,height: CGFloat
    * function ReturnType: nil
    *=======================================================*/
    class func setScrollViewContentSize(scrollView: UIScrollView,width: CGFloat,height: CGFloat) {
        scrollView.contentSize = CGSize(width: width, height: height)
    }
    
    /*========================================================
    * function Name: sizeToFitLabel
    * function Purpose: to set the text in the label
    * function Parameters: lbl: UILabel
    * function ReturnType: nil
    *=======================================================*/
    class func sizeToFitLabel(lbl: UILabel) {
        lbl.numberOfLines = 0
        lbl.sizeToFit()
    }
    
    /*========================================================
    * function Name: resignTextField
    * function Purpose: to resign textfield
    * function Parameters: textField: UITextField
    * function ReturnType: nil
    *=======================================================*/
    class func resignTextField(textField: UITextField) {
        if(textField.isFirstResponder()) {
            textField.resignFirstResponder()
        }
    }
    
    /*========================================================
    * function Name: checkForFirstResponder
    * function Purpose: to error remove border from image
    * function Parameters: textField: UITextField
    * function ReturnType: nil
    *=======================================================*/
    class func checkForFirstResponder(textField: UITextField,imgView: UIImageView) {
        if(textField.isFirstResponder()) {
            removeErrorBorder(imgView)
        }
    }
    
    /*========================================================
    * function Name: drawErrorBorder
    * function Purpose: to show red border on missing information
    * function Parameters: view: UIView,color: UIColor
    * function ReturnType: nil
    *=======================================================*/
    class func drawErrorBorder(view: AnyObject,width: CGFloat,borderColor: UIColor) {
        view.layer.borderWidth = width
        view.layer.borderColor = borderColor.CGColor
    }
    
    /*========================================================
    * function Name: drawErrorBorder
    * function Purpose: to show red border on missing information
    * function Parameters: view: UIView,color: UIColor
    * function ReturnType: nil
    *=======================================================*/
    class func removeErrorBorder(view: AnyObject) {
        view.layer.borderWidth = 0
        //view.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    /*========================================================
    * function Name: showErrorLine
    * function Purpose: to show red line on missing information
    * function Parameters: view: UIView,color: UIColor
    * function ReturnType: nil
    *=======================================================*/
    class func changeErrorLineColor(view: UIView,bgColor: UIColor) {
        view.backgroundColor = bgColor
    }
    

    /*========================================================
    * function Name: isTextViewEmpty
    * function Purpose: to check textview is empty or not
    * function Parameters: textField: UITextField
    * function ReturnType: Bool
    *=======================================================*/
    class func isTextViewEmpty(textView: UITextView) -> Bool{
        let test = (textView.text as NSString).stringByReplacingOccurrencesOfString(" ", withString: "") as NSString
        if(test.length > 0) {
            return false
        }
        else {
            return true
        }
    }
    
    /*========================================================
    * function Name: checkConfirmPassword
    * function Purpose: compare password and confirm password
    * function Parameters: pass: String,cpass: String
    * function ReturnType: Bool
    *=====================================================*/
    class func checkConfirmPassword(pass: String,cpass: String)->Bool
    {
        if(pass==cpass){
            return true
        }
        return false
    }
    
    /*========================================================
    * function Name: corneradiusToview
    * function Purpose: To make corner radius
    * function Parameters: UIView
    * function ReturnType: nil
    *=====================================================*/
    class  func  corneradiusToview(view:UIView, radius:CGFloat)
    {
        view.layer.cornerRadius=radius
    }
    
    /*========================================================
    * function Name: corneradiusWithBorderToview
    * function Purpose:  corneradiusWithBorderToview
    * function Parameters: var view:UIView, var radius:CGFloat,var borderWidth:CGFloat
    * function ReturnType: nil
    *=====================================================*/
    class func  corneradiusWithBorderToview(view:UIView, radius:CGFloat,borderWidth:CGFloat)
    {
        view.layer.cornerRadius=radius
        view.layer.borderWidth=borderWidth
    }
    
    /*========================================================
    * function Name: isValidEmailAddress
    * function Purpose: check email address is valid
    * function Parameters: testStr: NSString
    * function ReturnType: Bool
    *=====================================================*/
    class func isValidEmailAddress(testStr: NSString)->Bool
    {
        let emailRegEx = "[A-Za-z][A-Z0-9a-z._%+-]+@[A-za-z0-9.-]+\\.[A-Za-z]{2,4}";
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr);
    }
    
    /*========================================================
    * function Name: isValidMobile
    * function Purpose: check mobile number is valid is valid
    * function Parameters: testStr: NSString
    * function ReturnType: Bool
    *=====================================================*/
    class func isValidMobile(testStr: NSString)->Bool
    {
        let testStr1=self.formarNumber(testStr)
        let mobileRegEx = "[0-9]{10}";
        let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
        return mobileTest.evaluateWithObject(testStr1);
    }
    
    /*========================================================
    * function Name: drawRedBorderToTextfield
    * function Purpose: drawRedBorderToTextfield
    * function Parameters: var txtField:UITextField,var cornerRadius:CGFloat,var borderRadius:CGFloat
    * function ReturnType: nil
    *=====================================================*/
    class func drawRedBorderToTextfield(txtField:UITextField,cornerRadius:CGFloat,borderRadius:CGFloat)
    {
        txtField.layer.borderWidth=borderRadius
        txtField.layer.cornerRadius=cornerRadius
        txtField.layer.borderColor=UIColor.redColor().CGColor
        txtField.text=""
    }
    
    /*========================================================
    * function Name: drawClearBorderToTextfield
    * function Purpose: drawClearBorderToTextfield
    * function Parameters: var txtField:UITextField,var cornerRadius:CGFloat,var borderRadius:CGFloat
    * function ReturnType: nil
    *=====================================================*/
    class func drawClearBorderToTextfield(txtField:UITextField,cornerRadius:CGFloat,borderRadius:CGFloat)
    {
        txtField.layer.borderWidth=borderRadius
        txtField.layer.cornerRadius=cornerRadius
        txtField.layer.borderColor=UIColor.lightGrayColor().CGColor
    }
    
    /*========================================================
    * function Name: drawLightGrayBroderAndRadiusToview
    * function Purpose: drawLightGrayBroderAndRadiusToview
    * function Parameters: var view:UIView?,var cornerRadius:CGFloat,var borderWidth:CGFloat
    * function ReturnType: nil
    *=====================================================*/
    class func drawLightGrayBroderAndRadiusToview(view:UIView?,cornerRadius:CGFloat,borderWidth:CGFloat)
    {
        view?.layer.borderWidth=borderWidth
        view?.layer.cornerRadius=cornerRadius
        view?.layer.borderColor=UIColor.redColor().CGColor
    }
    
    /*========================================================
    * function Name: trimText
    * function Purpose: To trim space of string
    * function Parameters:txtString:String
    * function ReturnType: NSString
    *=======================================================*/    
    class func trimText(txtString:String)-> NSString
    {
        let whiteSpace : NSCharacterSet = NSCharacterSet.whitespaceCharacterSet()
        let trimPet : NSString = txtString.stringByTrimmingCharactersInSet(whiteSpace)
        return trimPet
    }

    
    /*========================================================
    * function Name: ValidatePassword
    * function Purpose: check reenter password is match with above password
    * function Parameters: var strPassword:NSString,var strConfirmPassword:NSString
    * function ReturnType: nil
    *=====================================================*/
    class func ValidatePassword(strPassword:NSString,strConfirmPassword:NSString) ->Bool
    {
        return  strPassword.isEqualToString(strConfirmPassword as String) as Bool
    }
    
    /*========================================================
    * function Name: isValidateMobileNumber
    * function Purpose: check mobile number is valid or not
    * function Parameters: var MobileNumber:NSString
    * function ReturnType: bool
    *=====================================================*/
    class func isValidateMobileNumber(MobileNumber:NSString) -> Bool
    {
        //var mobileRegEx = "[0-9]{10}"
        //var mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileRegEx)
       // return mobileTest!.evaluateWithObject(MobileNumber)
        return true
    }
    
    
    /*========================================================
    * function Name: paddingTextField
    * function Purpose: To add left padding in the textfield
    * function Parameters: textField:UITextField!,paddingWidth:CGFloat
    * function ReturnType: nil
    *=======================================================*/
    class func addPaddingTextField(textField:UITextField!,paddingWidth:CGFloat)
    {
        let paddingView:UIView = UIView(frame: CGRectMake(0, 0, paddingWidth, textField.frame.size.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextFieldViewMode.Always
    }

    /*========================================================
    * function Name: formarNumber
    * function Purpose: To format mobile number
    * function Parameters: mobileNo: NSString
    * function ReturnType: NSString
    *=======================================================*/
    class func formarNumber(var mobileNo: NSString) -> NSString {
        
        mobileNo = mobileNo.stringByReplacingOccurrencesOfString("(", withString: "")
        mobileNo = mobileNo.stringByReplacingOccurrencesOfString(")", withString: "")
        mobileNo = mobileNo.stringByReplacingOccurrencesOfString(" ", withString: "")
        mobileNo = mobileNo.stringByReplacingOccurrencesOfString("-", withString: "")
        mobileNo = mobileNo.stringByReplacingOccurrencesOfString("+", withString: "")
        let length = mobileNo.length
        if(length > 10) {
            mobileNo = mobileNo.substringFromIndex(length-10)
        }
        return mobileNo
    }
    
    /*========================================================
    * function Name: getLength
    * function Purpose: To get length of mobile number field
    * function Parameters: mobileNo: NSString
    * function ReturnType: Int
    *=======================================================*/
    class func getLength(var mobileNo: NSString) -> Int{
        
        mobileNo = mobileNo.stringByReplacingOccurrencesOfString("(", withString: "")
        mobileNo = mobileNo.stringByReplacingOccurrencesOfString(")", withString: "")
        mobileNo = mobileNo.stringByReplacingOccurrencesOfString(" ", withString: "")
        mobileNo = mobileNo.stringByReplacingOccurrencesOfString("-", withString: "")
        mobileNo = mobileNo.stringByReplacingOccurrencesOfString("+", withString: "")
        let length = mobileNo.length
        return length
    }
    
    /*========================================================
    * function Name: isiPad
    * function Purpose: check device is ipad or iphone
    * function Parameters: nil
    * function ReturnType: bool
    *=====================================================*/
    class func isiPad()->Bool
    {
        return (UIDevice.currentDevice().userInterfaceIdiom == .Pad)
    }
    
    /*========================================================
    * function Name: getScreenWidth()
    * function Purpose: Get current devices width
    * function Parameters:
    * function ReturnType:
    *=======================================================*/
    class func getScreenWidth() -> CGFloat {
        let screenrect:CGRect = UIScreen.mainScreen().bounds
        return screenrect.width
    }
    
    /*========================================================
    * function Name: getScreenWidth()
    * function Purpose: Get current devices width
    * function Parameters:
    * function ReturnType:
    *=======================================================*/
    class func getScreenHeight() -> CGFloat {
        let screenrect:CGRect = UIScreen.mainScreen().bounds
        return screenrect.height
    }
    
    /*========================================================
    * Function Name:clearCacheImage
    * Function Parameter:
    * Function Return Type:
    *Function Purpose:To clear image cache from ram and disk
    =========================================================*/
    class func clearCacheImage()
    {
      
    }
    
    /*===================================================
    * function Name : extractTime
    * function Params: target : NSString
    * fuction  Return type: NSString
    * function Purpose: to convert time in AM or PM format
    ===================================================*/
    
    class func extractTime(target : NSString) -> NSString
    {
        var target : NSString = target.substringWithRange(NSRange(location: 11, length: 5))
        if(target.substringWithRange(NSRange(location: 0, length: 2)) >= "12")
        {
            let hour : NSString = target.substringWithRange(NSRange(location: 0, length: 2)) as NSString
            let i : Int = hour.integerValue - 12
            target = (String(i) + target.substringWithRange(NSRange(location: 2, length: 3)) as NSString as String) + " PM"
        }
        else
        {
            let hour : NSString = target.substringWithRange(NSRange(location: 0, length: 2)) as NSString
            let i : Int = hour.integerValue
            target = (String(i) + target.substringWithRange(NSRange(location: 2, length: 3)) as NSString as String) + " AM"
        }
        return target
    }
    
    /*========================================================
    * function Name: viewSlideInFromRightToLeft
    * function Purpose: to make transition of view from right to left
    * function Parameters: view
    * function ReturnType: nil
    *=======================================================*/
    class func viewSlideInFromTopToBottom(view: UIImageView)
    {
        let transition : CATransition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        transition.delegate = self
        view.layer.addAnimation(transition, forKey: nil)
    }
    
    /*========================================================
    * function Name: viewSlideInFromRightToLeft
    * function Purpose: to make transition of view from right to left
    * function Parameters: view
    * function ReturnType: nil
    *=======================================================*/
    class func viewSlideInFromBottomToTop(view: UIImageView)
    {
        let transition : CATransition = CATransition()
        transition.duration = 1.0
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        transition.delegate = self
        view.layer.addAnimation(transition, forKey: nil)
    }
    
   /* class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false
    }*/


}