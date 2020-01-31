//The MIT License (MIT)
//
//Copyright (c) 2020 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import UIKit
import FBSDKLoginKit
import GoogleSignIn
import AuthenticationServices
import TwitterKit

public enum SocialMediaType {
    case facebook
    case google
    case twitter
    case signInWithApple
    case normal
}

struct SocialParameter {
    
    //Facebbok permission
    enum FacebookPermission {
        case publicProfile
        case email
        
        var description:String {
            switch self {
            case .publicProfile:
                return "public_profile"
            case .email:
                return "email"
            }
        }
    }
    
    enum FacebookPerameter {
        case identifier
        case name
        case firstName
        case lastName
        case email
        case picture(size: FacebookPictureSize)
        case phone
        
        var description:String {
            switch self {
            case .identifier:
                return "id"
            case .name:
                return "name"
            case .firstName:
                return "first_name"
            case .lastName:
                return "last_name"
            case .email:
                return "email"
            case .picture(let size):
                return "picture.type(\(size.description))"
            case .phone:
                return "phone"
            }
        }
    }
    
    enum FacebookPictureSize {
        case large   ///about 200 pixels wide, variable height
        case normal  ///100 pixels wide, variable height
        case small   ///50 pixels wide, variable height
        case square  ///50x50
        
        var description:String {
            switch self {
            case .large:
                return "large"
            case .normal:
                return "normal"
            case .small:
                return "small"
            case .square:
                return "square"
            }
        }
    }
}


class SocialLoginHelper: NSObject {
    
    /// Shared instance of SocialLoginHelper.
    public static let `default` = SocialLoginHelper()
    var viewController : UIViewController = UIViewController()
    
    var googleLoginCompletion:((_ result:UserModel?, _ status: Bool) -> Void)? = nil
    var signInWithAppleCompletion:((_ result:UserModel?, _ status: Bool) -> Void)? = nil
    
    
    func configureSocialAccount() {
        guard let info = Bundle.main.infoDictionary else { return }
            
        if let googleClientId = info["GoogleClientId"] as? String {
            GIDSignIn.sharedInstance().clientID = googleClientId
        }
        
        if let twitterConsumerKey = info["TwitterConsumerKey"] as? String,
            let twitterConsumerSecret = info["TwitterConsumerSecret"] as? String {
            TWTRTwitter.sharedInstance().start(withConsumerKey:twitterConsumerKey, consumerSecret:twitterConsumerSecret)
        }
        
    }
    
    ///Logout from previos session
    func logout(){
        LoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
        AccessToken.current = nil
    }
}

//MARK: - Facebook Login
extension SocialLoginHelper {
    
    func loginWithFacebook(with parameters:[SocialParameter.FacebookPerameter], permissions:[SocialParameter.FacebookPermission], completion:@escaping (_ userInfo:UserModel?, _ status:Bool)->()) {
        SocialLoginHelper.default.logout()
        let param = ["fields": parameters.compactMap({$0.description}).joined(separator: ", ")]
        let permission = [permissions.compactMap({$0.description}).joined(separator: ", ")]
        if !AccessToken.isCurrentAccessTokenActive {
            facebookLogin(with: permission) { (loginResult, status) in
                if status {
                    self.getUserProfieFromFacebook(parameters: param, completion: completion)
                } else {
                    self.logout()
                }
            }
        } else {
           self.getUserProfieFromFacebook(parameters: param, completion: completion)
        }
    }
    
    private  func getUserProfieFromFacebook(parameters:[String:String], completion:@escaping (_ userInfo:UserModel?, _ status:Bool)->()) {
        let graphResquest = GraphRequest(graphPath: "me", parameters: parameters)
        graphResquest.start { (connection, result, error) in
            guard let result  = result as? [String: Any] else {
                print(error?.localizedDescription ?? "")
                return completion(nil, false)
            }
            completion(UserModel(dict: result), true)
        }
    }
    
    private func facebookLogin(with permission:[String],completion:@escaping (_ result: LoginManagerLoginResult?, _ status: Bool)->()){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: permission, from: self.viewController) { (response, error) in
            guard let result = response, !result.isCancelled else {
                print(error?.localizedDescription ?? "")
                return completion(nil, false)
            }
            completion(result, true)
            
        }
    }
}

//MARK: - Google Login

//MARK: Google GIDSignInDelegate method
extension SocialLoginHelper: GIDSignInDelegate {
    
    func loginWithGoogle() {
        SocialLoginHelper.default.logout()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self.viewController
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            if let error = error {
                print("\(error.localizedDescription)")
                self.googleLoginCompletion?(nil, false)
            } else {
                let userModel = UserModel()
                userModel.socialId = user.userID
                userModel.socialMediaType = .google
                if !user.profile.name.isEmpty {
                    let names = user.profile.name.components(separatedBy: " ")
                    userModel.firstName = names[0]
                    if names.count > 1 {
                        userModel.lastName = names[1]
                    }
                    userModel.name = user.profile.name
                }
                userModel.email = user.profile.email
                if user.profile.hasImage {
                    if let url = user.profile.imageURL(withDimension: 100) {
                        userModel.pictureUrl = url.absoluteString
                    }
                }
                self.googleLoginCompletion?(userModel, true)
            }
        }
        
        func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
            print("\(error.localizedDescription)")
            self.googleLoginCompletion?(nil, false)
        }
}


//MARK:- SignIn With Apple

//MARK: ASAuthorization Controller Delegate Methods

@available(iOS 13.0, *)
extension SocialLoginHelper: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func signInWithApple() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

                
                let userModel = UserModel()
                userModel.socialId = appleIDCredential.user
                userModel.socialMediaType = .signInWithApple
                if let fullname = appleIDCredential.fullName {
                    userModel.firstName = fullname.givenName ?? ""
                    userModel.lastName = fullname.familyName ?? ""
                    userModel.name = fullname.nickname ?? ""
                }
                
                if let email = appleIDCredential.email {
                    userModel.email = email
                }
                ///you can get real user status
                //                print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
                ///you can get user token
                //                if let identityTokenData = appleIDCredential.identityToken,
                //                    let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                //                    print("IdentityToken \(identityTokenString)")
                //                }
                self.signInWithAppleCompletion?(userModel, true)
        }
        
    }
        
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("somthing bad happened : ", error)
        self.signInWithAppleCompletion?(nil, false)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.viewController.view.window!
    }
}


//MARK: Twitter Login
extension SocialLoginHelper {
    
    func loginWithTwitter(_ completion:@escaping (_ userInfo:UserModel?, _ status:Bool)->()) {
        
        TWTRTwitter.sharedInstance().logIn { (session, error) in
            guard let session = session else {
                if let error = error {
                    print(error.localizedDescription)
                }
                completion(nil, false)
                return
            }
            let client = TWTRAPIClient.withCurrentUser()
            client.requestEmail { (email, error) in
                if let email = email {
                    client.loadUser(withID: session.userID) { (user, error) in
                        if let user = user {
                            let userModel = UserModel()
                            userModel.name = user.name
                            userModel.email = email
                            userModel.socialId = user.userID
                            userModel.socialMediaType = .twitter
                            userModel.pictureUrl = user.profileImageLargeURL
                            completion(userModel, true)
                        } else  {
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            completion(nil, false)
                        }
                    }
                } else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    completion(nil, false)
                }
            }
        }
    }
}


