//
//  Utils.swift
//  LeoNFT
//
//  Created by Todor Dimitrov on 25.02.22.
//

import Foundation
import UIKit

class Utils {
    private static var timer: Timer?
    private static var timeLeft = 15
    
    class func showProgress() {
        IHProgressHUD.show()
        timeLeft = 15
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timeLeft -= 1
            if timeLeft <= 0 {
                IHProgressHUD.dismiss()
                timer?.invalidate()
            }
        }
    }
    
    class func showProgress(forView view: UIView) {
        IHProgressHUD.set(containerView: view)
        Utils.showProgress()
    }
    
    class func hideProgress() {
        IHProgressHUD.popActivity()
    }
    
    class func hideProgressForView() {
        Utils.hideProgress()
//        IHProgressHUD.set(containerView: (UIApplication.shared.delegate?.window)!)
    }
}
