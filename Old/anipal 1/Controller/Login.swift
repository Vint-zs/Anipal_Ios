//
//  ViewController.swift
//  anipal 1
//
//  Created by Kim JoonOh on 2021/02/03.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import Alamofire
import SwiftyJSON

class Login: UIViewController {
    @IBOutlet var facebookBtn: UIButton!
    @IBOutlet var googleBtn: UIButton!
    @IBOutlet var appleBtn: UIButton!
    @IBOutlet var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn() // 구글 로그인여부 확인
        facebookBtn.layer.cornerRadius = 10
        googleBtn.layer.cornerRadius = 10
        googleBtn.layer.borderColor = UIColor.gray.cgColor
        googleBtn.layer.borderWidth = 1
        appleBtn.layer.cornerRadius = 10
        logoImage.layer.cornerRadius = logoImage.frame.height/2
        
        // 네이베이션바 선 없애기
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // 페이스북 자동로그인
        if let token = AccessToken.current, !token.isExpired {
            print("facebook auto login")
            var fbEmail: String?
            Profile.loadCurrentProfile { (profile, error) in
                fbEmail = profile?.email
//                print(profile?.name)
//                print(profile?.userID)
            }
            getData(url: "https://anipal.tk/auth/facebook", token: AccessToken.current!.tokenString, email: fbEmail!, provider: "facebook")
            // moveMainScreen()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func facebookLogin(_ sender: UIButton) {
        LoginManager.init().logIn(permissions: [Permission.publicProfile, Permission.email], viewController: self) {(loginResult) in
            switch loginResult {
            case .success(granted:_, declined:_, token:_):
                var fbEmail: String?
                print("success facebook login")
                
                // 프로필 가져오기
                Profile.loadCurrentProfile(completion: {(profile, error) in
//                    print(profile?.name)
//                    print(profile?.userID)
                    fbEmail = profile?.email
                })
                print(fbEmail)
                self.getData(url: "https://anipal.tk/auth/facebook", token: AccessToken.current!.tokenString, email: fbEmail!, provider: "facebook") // 서버로 토큰 전송
                
            case .cancelled:
                print("user cancel the login")
            case .failed(let error):
                print("error occured: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    @IBAction func appleLogin(_ sender: UIButton) {
    }
    
    // MARK: - 서버 통신
    func getData(url: String, token: String, email: String, provider: String) {
        
        // let parameters = ["access Token": user.authentication.accessToken, "name": "jack"] as [String : Any]
            let url = URL(string: url)! // change the url
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = "GET" // set http method as POST
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                // response 확인
                if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String: String] {
                    print(httpResponse.statusCode)
                    
                    if httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            // ad!.token = token
                            // ad?.token = HTTPCookie
                            // ad!.email = email
                            
                            // 쿠키 저장
                            let responseCookies: [HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                            HTTPCookieStorage.shared.setCookies(responseCookies, for: response!.url!, mainDocumentURL: nil)
                            
                            // JSON 값 저장
                            if let data = data {
                                if let id = JSON(data)["_id"].string { ad?.id = id }
                                if let name = JSON(data)["name"].string { ad?.name = name }
                                if let age = JSON(data)["age"].int { ad?.age = age }
                                if let email = JSON(data)["email"].string { ad?.email = email }
                                if let country = JSON(data)["country"].string { ad?.country = country }
                                if let birthday = JSON(data)["birthday"].string { ad?.birthday = birthday }
                                if let gender = JSON(data)["gender"].string { ad?.gender = gender }
                                if let favorites = JSON(data)["favorites"].arrayObject as? [String] { ad?.favorites = favorites }
                                if let languages = JSON(data)["languages"].arrayObject as? [[String: Any]] { ad?.languages = languages }
                                if let accessories = JSON(data)["accessories"].dictionaryObject as? [String: [[String: String]]] { ad?.accessories = accessories }
                                if let animals = JSON(data)["animals"].arrayObject as? [[String: Any]] { ad?.animals = animals }
                            }
                            moveMainScreen()
                        }
                    } else if httpResponse.statusCode == 400 {
                        DispatchQueue.main.async {
                            GIDSignIn.sharedInstance()?.signOut()
                            LoginManager.init().logOut()
                            let alert = UIAlertController.init(title: "중복가입", message: "이미 가입된 이메일입니다 \n다른 소셜계정으로 다시 로그인해주세요!", preferredStyle: .alert)
                            let okBtn = UIAlertAction.init(title: "확인", style: .default, handler: nil)
                            alert.addAction(okBtn)
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else if httpResponse.statusCode == 404 {
                        DispatchQueue.main.async {
                            ad!.token = token
                            ad!.email = email
                            ad!.provider = provider
                        
                        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
                      //  let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
                            guard let signupVC = storyboard.instantiateViewController(identifier: "SignUpVC1") as? SignUpViewController else {
                            return
                        }
                        self.navigationController?.pushViewController(signupVC, animated: true)
                        }
                    } else if httpResponse.statusCode == 500 {
                        DispatchQueue.main.async {
                        let alert = UIAlertController.init(title: "서버오류", message: "Internal server error", preferredStyle: .alert)
                        let okBtn = UIAlertAction.init(title: "확인", style: .default, handler: nil)
                        alert.addAction(okBtn)
                        self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            task.resume()
    }
}
// MARK: - 구글 로그인 설정
extension Login: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        print("success google login")
        print(user.authentication.accessToken)
        
        print("access token : \(user.authentication.accessToken)")
        print("expire date \(user.authentication.accessTokenExpirationDate)")

//        print(user.authentication.refreshToken)
//        print("expire date \(user.authentication.accessTokenExpirationDate)")
        getData(url: "https://anipal.tk/auth/google", token: user.authentication.accessToken, email: user.profile.email, provider: "google") // 서버로 b토큰 전송
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
}

// MARK: - 메인화면전환
func moveMainScreen() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
}

