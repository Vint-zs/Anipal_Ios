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
import AuthenticationServices

var singletonAnimal = SingletonAnimal.shared //동물 저장할 싱글톤

class Login: UIViewController {
    @IBOutlet var facebookBtn: UIButton!
    @IBOutlet var googleBtn: UIButton!
    @IBOutlet var appleBtn: UIButton!
    @IBOutlet var logoImage: UIImageView!
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn() // 구글 로그인여부 확인

        facebookAutoLogin()
        settingViewLayout()
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
                    fbEmail = profile?.email
                })
                self.getData(url: domain + "/auth/facebook", token: AccessToken.current!.tokenString, email: fbEmail!, provider: "facebook") // 서버로 토큰 전송
            
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
    
    // 애플로그인
    @IBAction func appleLogin(_ sender: UIButton) {
        let appleIdDetails = ASAuthorizationAppleIDProvider()
        let request = appleIdDetails.createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    func settingViewLayout() {
        // 네이베이션바 선 없애기
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        facebookBtn.layer.cornerRadius = 10
        googleBtn.layer.cornerRadius = 10
        googleBtn.layer.borderColor = UIColor.gray.cgColor
        googleBtn.layer.borderWidth = 1
        appleBtn.layer.cornerRadius = 10
    }
    
    // 페이스북 자동로그인
    func facebookAutoLogin() {
        if let token = AccessToken.current, !token.isExpired {
            print("facebook auto login")
            var fbEmail: String?
            Profile.loadCurrentProfile { (profile, error) in
                fbEmail = profile?.email
            }
            getData(url: domain + "/auth/facebook", token: AccessToken.current!.tokenString, email: fbEmail ?? "", provider: "facebook")
        }
    }
    
//    // 애플 자동로그인
//    func appleAutoLogin() {
//
//        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.email,.fullName]
//
//        if let details = authorization.credential as? ASAuthorizationAppleIDCredential {
//            print("success apple login")
//            print(details.user)
//            print(details.fullName)
//            print(details.email)
//
//            appleIDProvider.createRequest()
//
//            if let tokenString = String(data: details.identityToken!, encoding: .utf8),
//               let email = details.email {
//                print("값 넘김다")
//                getData(url: "https://anipal.co.kr/auth/apple", token: tokenString, email: email, provider: "apple")
//            }
//
//            appleIDProvider.getCredentialState(forUserID: userId) { (credentialState, error) in
//                switch credentialState {
//                case .authorized:
//                    print("Auto login successful")
//                    let tokenString = String(data: <#T##Data#>, encoding: <#T##String.Encoding#>)
//                    getData(url: "https://anipal.co.kr/auth/apple", token: tokenString, email: email, provider: "apple")
//                    //resume normal app flow
//                    break
//                case .revoked, .notFound:
//                    print("Auto login not successful")
//                    //show login screen or you also invoke handleAuthorizationAppleIDAction
//                    break
//                default:
//                    break
//                }
//            }
//        }
//    }
    
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
                if httpResponse.statusCode == 200 {
                    
                    // 쿠키 저장
                    let responseCookies: [HTTPCookie] = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                    HTTPCookieStorage.shared.setCookies(responseCookies, for: response!.url!, mainDocumentURL: nil)
                    DispatchQueue.main.async { [self] in
                        
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
                            if let favAnimal = JSON(data)["favorite_animal"].dictionaryObject as? [String: String] {
                                let compFav = loadAnimals(urls: favAnimal)
                                ad?.thumbnail = compFav
                            }
                            if let blockUsers = JSON(data)["banned_users_id"].arrayObject as? [String] { ad?.blockUsers = blockUsers }
                        }
                        
                        // 메인화면 이동
                        
                        getAnimal()
                        moveMainScreen()
                    }
                } else if httpResponse.statusCode == 400 {
                    GIDSignIn.sharedInstance()?.signOut()
                    LoginManager.init().logOut()
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController.init(title: "Already Registered".localized, message: "This email has already been signed up.\n Please login with another social account".localized, preferredStyle: .alert)
                        let okBtn = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
                        alert.addAction(okBtn)
                        self.present(alert, animated: true, completion: nil)
                    }
                } else if httpResponse.statusCode == 404 {
                    print("New User")
                    DispatchQueue.main.async {
                        ad!.token = token
                        ad!.email = email
                        ad!.provider = provider
                        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
                        guard let signupVC = storyboard.instantiateViewController(identifier: "SignUpVC1") as? SignUpViewController else {
                            return
                        }
                        self.navigationController?.pushViewController(signupVC, animated: true)
                    }
                } else if httpResponse.statusCode == 500 {
                    DispatchQueue.main.async {
                        let alert = UIAlertController.init(title: "Server Error".localized, message: "Internal server error".localized, preferredStyle: .alert)
                        let okBtn = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                        alert.addAction(okBtn)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    // MARK: - 이미지 합성
    func loadAnimals(urls: [String: String]) -> UIImage {
        let order = urls.sorted(by: <)
        images = []
        for (_, url) in order {
            setImage(from: url)
        }
        return compositeImage(images: images)
    }
    
    func compositeImage(images: [UIImage]) -> UIImage {
        var compositeImage: UIImage!
        if images.count > 0 {
            let size: CGSize = CGSize(width: images[0].size.width, height: images[0].size.height)
            UIGraphicsBeginImageContext(size)
            for image in images {
                let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                image.draw(in: rect)
            }
            compositeImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return compositeImage
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        guard let imageData = try? Data(contentsOf: imageURL) else { return }
        let image = UIImage(data: imageData)
        self.images.append(image!)
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
        print("access token : \(user.authentication.accessToken ?? "")")

        getData(url: domain + "/auth/google", token: user.authentication.accessToken, email: user.profile.email, provider: "google") // 서버로 토큰 전송
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Disconnect")
    }
}

// MARK: - 애플 로그인 설정
extension Login: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("success apple login")
            print(credential.user)
            print(credential.fullName)
            print(credential.email)
            
            if let tokenString = String(data: credential.identityToken!, encoding: .utf8),
               let email = credential.email {
                print("값 넘김다")
                getData(url: domain + "/auth/apple", token: tokenString, email: email, provider: "apple") // 서버로 토큰 전송
            }
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플로그인 에러발생")
        print(error.localizedDescription)
    }
}

// MARK: - 메인화면전환
func moveMainScreen() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let tabBarController = storyboard.instantiateViewController(identifier: "TabBarController")
    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(tabBarController)
}

// MARK: - 이미지 합성
func compositeImage(images: [UIImage]) -> UIImage {
    var compositeImage: UIImage?
    if images.count > 0 {
        let size: CGSize = CGSize(width: images[0].size.width, height: images[0].size.height)
        UIGraphicsBeginImageContext(size)
        for image in images {
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            image.draw(in: rect)
        }
        compositeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    return compositeImage ?? #imageLiteral(resourceName: "emptyCheckBox")
}

func getAnimal() {
    if let session = HTTPCookieStorage.shared.cookies?.filter({$0.name == "Authorization"}).first {
        get(url: "/own/animals", token: session.value) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }

            if let httpStatus = response as? HTTPURLResponse {
                if httpStatus.statusCode == 200 {
                    var myAnimalList: [MyAnimal] = []   // 동물들 정보 순서대로
                    var imageUrls: [[String]] = [] //동물들 url 정보
                    var images: [UIImage] = []  // 동물들 이미지 정보
                    var order: [String: Int] = ["head": 1, "top": 2, "pants": 3, "shoes": 4, "gloves": 5 ]
                    var baseAnimalImage: [UIImage] = []
                    
                    for idx in 0..<JSON(data).count {
                        let json = JSON(data)[idx]
                        let animalUrl: [String: String] = [
                            "animal_url": json["animal_url"].stringValue,
                            "head_url": json["head_url"].stringValue,
                            "top_url": json["top_url"].stringValue,
                            "pants_url": json["pants_url"].stringValue,
                            "shoes_url": json["shoes_url"].stringValue,
                            "gloves_url": json["gloves_url"].stringValue]
                        myAnimalList.append(MyAnimal(id: json["_id"].stringValue, time: json["animal"]["delay_time"].stringValue, name: json["animal"]["localized"].stringValue, animalUrl: animalUrl))
                    }
                    
                    // 이미지url 저장배열 생성 및 동물사진url 첫번쨰로 위치
                    if imageUrls.count != myAnimalList.count {
                        // imageUrls = []
                        for i in 0..<myAnimalList.count {
                            let sortedUrl = myAnimalList[i].animalUrl.sorted(by: <)
                            var temp: [String] = []
                            
                            for row in sortedUrl {
                                temp.append(row.value)
                            }
                            imageUrls.append(temp)
                            temp = []
                        }
                    }
                        
                    // url -> 이미지로 변환 후 합성 및 저장
                    for i in 0..<imageUrls.count {
                        var ingredImage: [UIImage] = []
                        // 기본동물
                        if let imageURL = URL(string: imageUrls[i][0]) {
                            if let imageData = try? Data(contentsOf: imageURL) {
                                if let img = UIImage(data: imageData) {
                                    baseAnimalImage.append(img)
                                }
                            }
                        }
                        // 꾸며진 동물
                        for url in imageUrls[i] {
                            if let imageURL = URL(string: url) {
                                if let imageData = try? Data(contentsOf: imageURL) {
                                    if let img = UIImage(data: imageData) {
                                        ingredImage.append(img)
                                    }
                                }
                            }
                        }
                        images.append(compositeImage(images: ingredImage))
                        ingredImage = []
                    }
                    
                    singletonAnimal.animal = myAnimalList
                }
            }
        }
    }
    
}
