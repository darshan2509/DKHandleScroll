//
//  SwiftScroll
//
//  Created by Shubham Naik on 10/06/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

import UIKit

class SwiftScroll: NSObject {
    static var swiftScroll: SwiftScroll?
    
    var rootVC: UIViewController?
    var reset = CGPoint.zero
    var scrollView: UIScrollView?
    var currentViewController: UIViewController?
    
    public class func sharedInstance() -> SwiftScroll
    {
        if(swiftScroll == nil)
        {
            swiftScroll = SwiftScroll()
            let appDelegate = UIApplication.shared.delegate
            swiftScroll?.rootVC = appDelegate?.window??.rootViewController
        }
        return swiftScroll!
    }
    
    // MARK: - ScrollView Delegates
    func thisKeyboardWasShown(_ notification: Notification, mainScroll: UIScrollView, VC: UIViewController, TXFRAME: CGRect) {
        reset = mainScroll.contentOffset
        let orientation = UIApplication.shared.statusBarOrientation
        var keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! CGRect).size
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            let origKeySize = keyboardSize
            keyboardSize.height = origKeySize.width
            keyboardSize.width = origKeySize.height
        }
        let info = notification.userInfo
        let kbSize = (info?[UIKeyboardFrameBeginUserInfoKey] as! CGRect).size
        let deviceSize = UIScreen.main.bounds.size
        var keyBdHeight: CGFloat
        if kbSize.height < kbSize.width {
            keyBdHeight = CGFloat(kbSize.height)
        }
        else {
            keyBdHeight = CGFloat(kbSize.width)
        }
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(00.0, 0.0, keyBdHeight, 0.0)
        mainScroll.contentInset = contentInsets
        mainScroll.scrollIndicatorInsets = contentInsets
        var aRect = VC.view.frame
        aRect.size.height -= keyBdHeight
        var nwFrm = TXFRAME
        nwFrm.origin.y = TXFRAME.origin.y + TXFRAME.size.height + 5
        if !aRect.contains(nwFrm.origin) {
            let scrollPoint = CGPoint(x: CGFloat(0.0), y: CGFloat(abs(nwFrm.origin.y - (deviceSize.height - keyBdHeight))))
            mainScroll.setContentOffset(scrollPoint, animated: true)
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func thisKeyboardWillBeHidden(_ aNotification: Notification, mainScroll: UIScrollView) {
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        mainScroll.contentInset = contentInsets
        mainScroll.scrollIndicatorInsets = contentInsets
    }
    
    //method to move the view up/down whenever the keyboard is shown/dismissed
    func convert(_ view: UIView) -> CGRect {
        var vw: UIView? = view
        var rect = vw!.frame
        while (vw?.superview != nil) {
            vw = vw?.superview
            rect.origin.x += (vw?.frame.origin.x)!
            rect.origin.y += (vw?.frame.origin.y)!
        }
        return rect
    }
    
    func register(forNotification currentVC: UIViewController) {
        // register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(_ notification: Notification) {
        let k: Any? = currentViewController?.view.currentFirstResponder()
        if (k is UITextField) || (k is UITextView) {
            let textview = k as! UIView
            let TXFRAME = convert(textview)
            thisKeyboardWasShown(notification, mainScroll: scrollView!, VC: currentViewController!, TXFRAME: TXFRAME)
        }
    }
    
    func keyboardWillBeHidden(_ notification: Notification) {
        thisKeyboardWillBeHidden(notification, mainScroll: scrollView!)
    }
    
    public func makeScrollable(_ scrollView: UIScrollView) {
        currentViewController = findTopVC()
        self.scrollView = scrollView
        register(forNotification: currentViewController!)
    }
    
    func findTopVC() -> UIViewController {
        var top: UIViewController? = nil
        if rootVC?.navigationController != nil {
            top = rootVC?.navigationController?.topViewController
        }
        else if rootVC?.tabBarController != nil {
            top = rootVC?.tabBarController?.selectedViewController
        }
        else {
            var parentViewController: UIViewController? = rootVC
            while parentViewController?.presentedViewController != nil {
                parentViewController = parentViewController?.presentedViewController
            }
            top = parentViewController
        }
        
        return top!
    }
}

extension UIView {
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        
        return nil
    }
}
