//The MIT License (MIT)
//
//Copyright (c) 2020 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import UIKit
import TwitterKit

class ViewController: UIViewController {

    @IBOutlet weak var viewSignInWithApple: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SocialLoginHelper.default.viewController = self
        if #available(iOS 13.0, *) {
            viewSignInWithApple.isHidden = false
        } else {
            viewSignInWithApple.isHidden = true
        }
    }
        
    @IBAction func clickOnFacebook(_ sender:Any) {
        SocialLoginHelper.default.loginWithFacebook(with: [.identifier, .name, .firstName, .lastName, .picture(size: .large)], permissions: [.publicProfile, .email]) { (userDetail, status) in
            print("Facebook Login ID:\(userDetail?.socialId ?? "")")
        }
    }
    
    @IBAction func clickOnGoogle(_ sender:Any) {
        SocialLoginHelper.default.loginWithGoogle()
        SocialLoginHelper.default.googleLoginCompletion = {
            (userDetail, status) -> Void in
            print("Google Login ID:\(userDetail?.socialId ?? "")")
        }
    }
    
    @IBAction func clickOnTwitter(_ sender:Any) {
        SocialLoginHelper.default.loginWithTwitter { (userDetail, status) in
            print("Twitter Login ID:\(userDetail?.socialId ?? "")")
        }
    }
    
    @available(iOS 13.0, *)
    @IBAction func clickOnSignInWithApple(_ sender:Any) {
        SocialLoginHelper.default.signInWithApple()
        SocialLoginHelper.default.signInWithAppleCompletion = {
            (userDetail, status) -> Void in
            print("Sign In Apple ID:\(userDetail?.socialId ?? "")")
        }
    }
}

