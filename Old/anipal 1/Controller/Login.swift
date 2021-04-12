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
        facebookBtn.layer.cornerRadius = 10
        googleBtn.layer.cornerRadius = 10
        googleBtn.layer.borderColor = UIColor.gray.cgColor
        googleBtn.layer.borderWidth = 1
        appleBtn.layer.cornerRadius = 10
        logoImage.layer.cornerRadius = logoImage.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
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
                
                self.getData(url: "https://anipal.tk/auth/facebook", token: AccessToken.current!.tokenString, email: fbEmail!) // 서버로 토큰 전송
                
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
    func getData(url: String, token: String, email: String) {
        
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
                if let httpResponse = response as? HTTPURLResponse {
                    
                    if httpResponse.statusCode == 200 {
                        ad?.token = token
                        // ad?.token = HTTPCookie
                        ad?.email = email
                        
                        // JSON 값 저장
//                        let json = JSON(data)
//                        let userInfo = json.arrayValue[0]
//                        ad?.name = userInfo["name"].stringValue
                        moveMainScreen()
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
                        guard let signupVC = self.storyboard?.instantiateViewController(identifier: "SignUpVC1") else {
                            return
                        }
                        self.navigationController?.pushViewController(signupVC, animated: true)
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
        getData(url: "https://anipal.tk/auth/google", token: user.authentication.accessToken, email: user.profile.email) // 서버로 b토큰 전송
//        moveMainScreen()
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

