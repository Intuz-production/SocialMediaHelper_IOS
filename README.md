<h1>Introduction</h1>
INTUZ is presenting an interesting SocialLoginHelper Controller to integrate inside your Native iOS-based application. SocialLoginHelper is a simple component, which lets you integrate social login like Facebook, Google, Twitter, and Sign In with Apple. You will get user information like which are publicly available in the user profile

<br/><br/>
<h1>Features</h1>

- Easy & Fast Integrate Social login using this component.
- Fully customizable component.

<br/><br/>
<h1>Getting Started</h1>

To use this component in your project you need to perform the below steps:

**<h1>Steps to Integrate Google login</h1>**

1) Configure Google Console Application to get google client ID from below URL.

> https://developers.google.com/identity/sign-in/ios/start-integrating#next_steps

2) Add a URL scheme to your project 

> https://developers.google.com/identity/sign-in/ios/start-integrating#add_a_url_scheme_to_your_project

3) Install below CocoaPods in your application.
```  
  pod 'GoogleSignIn', '~> 5.0'  
```
4) add Google ClientID in your project info.plist file 
```
    <key>GoogleClientId</key>
    <string>(<YOUR_GOOGLE_CLIENTID)</string>
```
<br/>
<p><b>Note:</b> Replace <b>YOUR_GOOGLE_CLIENTID</b> with your google clientId.</p>

5) handle below event In AppDelegate.swift
```
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        if GIDSignIn.sharedInstance().handle(url) {
            return true
        }
    }
```

6) Copy the ‘SocialHelper’ folder and add it to your project and make sure you have checked “Copy if needed” option.
<br/>
<p><b>Note:</b> In this project, we use 'UserModel' to handle user detail, you can change this model as per your project requirement.</p>

7) Implement Social login with Google from below code
```
        SocialLoginHelper.default.loginWithGoogle()
        SocialLoginHelper.default.googleLoginCompletion = {
            (userDetail, status) -> Void in
            print("Google Login ID:\(userDetail?.socialId ?? "")")
        }
```
<br/>
<br/>

**<h1>Steps to Integrate Facebook login</h1>**

1) Configure Facebook Developer account get FacebookAppId from below URL.

> https://developers.facebook.com/docs/facebook-login/ios/

2) Add a URL scheme to your project
```
    fb{YOUR_FACEBOOK_APP_ID}
 ```               
3) Install below CocoaPods in your application.
```  
  pod 'FBSDKLoginKit'  
```
4) add FacebookAppID in your project info.plist file 
```
    <key>FacebookAppID</key>
    <string>{YOUR_FACEBOOK_APP_ID}</string>
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>fbapi</string>
        <string>fb-messenger-share-api</string>
        <string>fbauth2</string>
        <string>fbshareextension</string>
    </array>
    
    
```
<br/>
<p><b>Note:</b> replace <b>YOUR_FACEBOOK_APP_ID</b> with your facebookAppId.</p>

5) handle below event In AppDelegate.swift
```
    import FBSDKLoginKit in AppDelegate.swift
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        if ApplicationDelegate.shared.application(app, open: url, options: options) {
            return true
        }
    }
    
    # if your project target is iOS 13 or above then add below code in SceneDelegate.swift
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let openURLContext = URLContexts.first,
            let annotation = openURLContext.options.annotation {
                let url = openURLContext.url
            ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: openURLContext.options.sourceApplication, annotation: annotation)
        }
    }
```

6) Copy the ‘SocialHelper’ folder and add it to your project and make sure you have checked “Copy if needed” option.
<br/>
<p><b>Note:</b> In this project, we use 'UserModel' to handle user detail, you can change this model as per your project requirement.</p>

7) Implement Social login with Facebook from below code
```
        SocialLoginHelper.default.loginWithFacebook(with: [.identifier, .name, .firstName, .lastName, .picture(size: .large)], permissions: [.publicProfile, .email]) { (userDetail, status) in
            print("Facebook Login ID:\(userDetail?.socialId ?? "")")
        }
```
<br/>
<br/>

**<h1>Steps to Integrate Twitter login</h1>**

1) Configure Twitter account get TwitterConsumerKey and TwitterConsumerSecret from below URL.

> Go to  `https://apps.twitter.com/`, sign in with a Twitter account and click on `Create New App`.

2) Add a URL scheme to your project 
```
   twitterkit-{YOUR_TWITTER_CONSUMER_KEY}
``` 

3) Install below CocoaPods in your application.
```  
  pod 'TwitterKit'  
```
4) add FacebookAppID in your project info.plist file 
```
    <key>TwitterConsumerSecret</key>
    <string>{YOUR_TWITTER_CONSUMER_SECRET}</string>
    <key>TwitterConsumerKey</key>
    <string>{YOUR_TWITTER_CONSUMER_KEY}</string>
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>twitter</string>
        <string>twitterauth</string>
    </array>
    
    
```
<br/>
<p><b>Note:</b> replace <b>YOUR_TWITTER_CONSUMER_SECRET,  YOUR_TWITTER_CONSUMER_KEY</b> with your google clientId.</p>

5) handle below event In AppDelegate.swift
```
    import TwitterKit in AppDelegate.swift
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        if TWTRTwitter.sharedInstance().application(app, open: url, options: options){
            return true
        }
    }
```

6) Copy the ‘SocialHelper’ folder and add it to your project and make sure you have checked “Copy if needed” option.
<br/>
<p><b>Note:</b> In this project, we use 'UserModel' to handle user detail, you can change this model as per your project requirement.</p>

7) Implement Social login with Twitter from below code
```
        SocialLoginHelper.default.loginWithTwitter { (userDetail, status) in
            print("Twitter Login ID:\(userDetail?.socialId ?? "")")
        }
```

<br/>
<br/>

**<h1>Steps to Integrate Sign In with Apple login</h1>**

1) Open the Apple developer portal and add Sign In with Apple to your app ID.

> Go to  `https://developer.apple.com/`
> Select your App ID
> Under Capabilities scroll down and activate Sign In with Apple.
<div style="float:left">
<img src="SignInwithApple-developerportal.jpg" width="600">
</div>
    

2) Add Sign In with Apple to your app in Xcode
> Open your project settings.
> Go to Signing & Capabilities.
> Click on +Capability and type into the search pane until Sign In with Apple feature appears. Select it.

3) Copy the ‘SocialHelper’ folder and add it to your project and make sure you have checked “Copy if needed” option.
<br/>
<p><b>Note:</b> In this project, we use 'UserModel' to handle user detail, you can change this model as per your project requirement.</p>

4) Implement Social login with Sign In With Apple from below code
```
        //First Check your iOS version to display SignInWithApple button in viewDidLoad
        if #available(iOS 13.0, *) {
            //Show your SignInWithApple button
        } else {
            //hide your SignInWithApple button
        }
        
        //handle SignInWithApple event 
        @IBAction func clickOnSignInWithApple(_ sender:Any) {
            if #available(iOS 13.0, *) {
                SocialLoginHelper.default.signInWithApple()
                SocialLoginHelper.default.signInWithAppleCompletion = {
                    (userDetail, status) -> Void in
                    print("Sign In Apple ID:\(userDetail?.socialId ?? "")")
                }
            }
        }
```

<br/>
<br/>
<p><b>Note:</b> you can user ASAuthorizationAppleIDButton. Refere this link `https://developer.apple.com/documentation/authenticationservices/asauthorizationappleidbutton`.</p>

<br/><br/>
**<h1>Bugs and Feedback</h1>**
For bugs, questions and discussions please use the Github Issues.


<br/><br/>
**<h1>License</h1>**
The MIT License (MIT)
<br/><br/>
Copyright (c) 2020 INTUZ
<br/><br/>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 
<br/><br/>
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

<br/>
<h1></h1>
<a href="https://www.intuz.com/" target="_blank"><img src="Screenshots/logo.jpg"></a>



