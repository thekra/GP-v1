//
//  API.swift
//  GP-v1
//
//  Created by Thekra Faisal on 19/08/1441 AH.
//  Copyright © 1441 Thekra Faisal. All rights reserved.
//

import Foundation
import Alamofire

class API: NSObject {
    
    // MARK:- Login
    
    /// takes email and password and returns role id
    class func login(email:String, password: String, completion: @escaping (_ error: Error?, _ success: Bool, _ role_id: String, _ message: String) -> Void) {
        
        let urlString      = URLs.login
        let body           = Signin(email: email, password: password)
        let url            = URL(string: urlString)
        var request        = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody   = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        Alamofire.request(request).validate(statusCode: 200..<300).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success:
                print("Validation Successful")
                print(response.result.description)
                
                guard let data = response.data else {
                    
                    DispatchQueue.main.async {
                        print(response.error!)
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let responseObject =  try decoder.decode(SigninResponse.self, from: data)
                    
                    let token          = responseObject.accessToken
                    let name           = responseObject.userData.name
                    let phone          = responseObject.userData.phone
                    
                    print("Token: \(token)")
                    UserDefaults.standard.set(token, forKey: "access_token")
                    UserDefaults.standard.synchronize()
                    UserDefaults.standard.set(name, forKey: "name")
                    UserDefaults.standard.set(phone, forKey: "phone")
                    
                    if response.response?.statusCode == 200 {
                        let roleID = responseObject.userData.roleID
                        
                        DispatchQueue.main.async {
                            completion(nil, true, roleID!, "")
                        }
                    }
                }  catch let parsingError {
                    print("Error", parsingError)
                }
                
            case let .failure(error):
                
                if        response.response?.statusCode == 401 {
                    completion(nil, false, "", "الايميل/الكلمة السرية غير صحيحة")
                    
                } else if response.response?.statusCode == 422 {
                    completion(nil, false, "", "مدخل غير صالح/مدخل مفقود")
                    
                } else if response.response?.statusCode == 500 {
                    completion(nil, false, "", "خطأ في السيرفر")
                    
                }
                print(error)
            }
            
        } // End of Alamofire
        
    } // End of function login
    
    
    // MARK:- Register
    
    class func register(email:String, password: String, password_confirmation: String, completion: @escaping (_ error: Error?, _ success: Bool, _ message: String) -> Void) {
        
        
        if password != "" ||  password_confirmation != "" {
            if password.count < 8 && password_confirmation.count < 8 {
                
                completion(nil, false, "كلمة المرور يجب ان تكون اكثر من ٨ حروف")
                
            } else if password != password_confirmation {
                    completion(nil, false, "كلمة السر غير متطابقة")
                    
            } else if Connectivity.isConnectedToInternet {
                
                let urlString      = URLs.register
                
                
                let body           = Signup(email: email, password: password, password_confirmation: password_confirmation)
                
                let url            = URL(string: urlString)
                var request        = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.httpBody   = try! JSONEncoder().encode(body)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                
                Alamofire.request(request).validate(statusCode: 200..<300).responseJSON { response in
                    print(response)
                    
                    switch response.result {
                    case .success:
                        print("Validation Successful")
                        print(response.result.description)
                        
                        
                        guard let data = response.data else {
                            
                            
                            DispatchQueue.main.async {
                                print(response.error!)
                                
                            }
                            return
                        }
                        
                        let decoder            = JSONDecoder()
                        do {
                            let responseObject =  try decoder.decode(SignupResponse.self, from: data)
                            print(responseObject)
                            
                            let token          = responseObject.accessToken
                            let name           = responseObject.userData.name
                            
                            UserDefaults.standard.set(token, forKey: "access_token")
                            UserDefaults.standard.set(name, forKey: "name")
                            if response.response?.statusCode == 200 {
                                DispatchQueue.main.async {
                                    completion(nil, true, "")
                                }
                            }
                        } catch let parsingError {
                            print("Error:(signup)", parsingError)
                            
                        }
                    case let .failure(error):
                        
                        if        response.response?.statusCode == 401 {
                            completion(nil, false, "الايميل/الكلمة السرية غير صحيحة")
                            
                        } else if response.response?.statusCode == 422 {
                            completion(nil, false, "مدخل غير صالح / مدخل مفقود/ الايميل موجود مسبقاً")
                            
                        } else if response.response?.statusCode == 500 {
                            completion(nil, false, "خطأ في السيرفر")
                            
                        }
                        print(error)
                    }
                } // End of Alamofire
                //} // End of function register
            } else {
                completion(nil, false, "لا يوجد اتصال بالانترنت")
        }
        }
        
    } // End of register function
    
    // MARK:- Reset Password
    
    class func reset(email:String, completion: @escaping (_ error: Error?, _ success: Bool, _ message: String) -> Void) {
        
        let urlString = URLs.reset
        
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Accept": "application/json"
        ]
        
        
        let parameters = [
            "email": email
            ] as [String : AnyObject]
        
        if Connectivity.isConnectedToInternet {
            Alamofire.upload(multipartFormData:
                { (multipartFormData ) in
                    
                    for (key, value) in parameters {
                        if let temp = value as? String { multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                            
                        }
                        print("Sent Parameters: \(parameters)")
                    }
            }, to: urlString,
               method: .post,
               headers: headers,
               encodingCompletion: {
                encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseData { response in
                        debugPrint("SUCCESS RESPONSE: \(response)")
                        debugPrint(response.debugDescription)
                        print("REsponse: \(response)")
                        
                        guard response.data != nil else {
                            
                            DispatchQueue.main.async {
                                print(response.error!)
                            }
                            return
                        }
                        
                    } // End of upload
                    
                    upload.responseJSON { response in
                        
                        print("the resopnse code is : \(response.response?.statusCode ?? 0)")
                        if response.response?.statusCode == 404 {
                            
                            completion(nil, false, "البريد المدخل غير موجود")
                            
                        } else if response.response?.statusCode == 422 {
                            
                            completion(nil, false, "مدخل غير صالح / مدخل مفقود")
                        } else if response.response?.statusCode == 200 {
                            
                            DispatchQueue.main.async {
                                completion(nil, true, "تم ارسال رسالة استعادة الكلمة السرية الى بريدك المدخل")
                            }
                        }
                        // من هنا يطلع رسالة الايرور تمام
                        print("the response is : \(response)")
                    }
                    
                case .failure(let encodingError):
                    // hide progressbas here
                    print("ERROR RESPONSE: \(encodingError)")
                }
            }) // End of Alamofire
            
            
        } // End of Connection check
        else {
            
            completion(nil, false, "لا يوجد اتصال بالانترنت")
            
        }
    }
    
} // End of class API
