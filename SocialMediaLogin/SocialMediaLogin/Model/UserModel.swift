//The MIT License (MIT)
//
//Copyright (c) 2020 INTUZ
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


import Foundation

class UserModel {
    //Specified Key
    
    private let Identifier = "id"
    private let Name = "first_name"
    private let FirstName = "first_name"
    private let LastName = "last_name"
    private let Email = "email"
    private let Phone = "phone"
    private let PictureUrl = "picture"
    
    lazy var socialId:String = ""
    lazy var firstName:String = ""
    lazy var lastName:String = ""
    lazy var name:String = ""
    lazy var email:String = ""
    lazy var phone:String = ""
    lazy var pictureUrl:String = ""
    lazy var socialMediaType:SocialMediaType = .normal
    
    
    required init() {}
    
    init(dict:[String: Any]) {
        if let value = dict[Identifier] as? String{
          self.socialId = value
        }
        if let value = dict[Name] as? String{
          self.name = value
        }
        if let value = dict[FirstName] as? String{
          self.firstName = value
        }
        if let value = dict[LastName] as? String{
          self.lastName = value
        }
        if let value = dict[Email] as? String{
          self.email = value
        }
        if let value = dict[Phone] as? String{
          self.phone = value
        }
        if let profilePic = dict[PictureUrl] as? [String:AnyObject]{
          if let data = profilePic["data"] as? [String : AnyObject]{
            if let url = data["url"] as? String{
              self.pictureUrl = url
            }
          }
        }
    }
    
}
