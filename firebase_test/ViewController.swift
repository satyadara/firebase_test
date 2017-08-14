//
//  ViewController.swift
//  firebase_test
//
//  Created by Satya Syahputra on 20/07/17.
//  Copyright © 2017 Satya Syahputra. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFacebookLoginButton()
        setupGoogleSignInButton()
        setupFirebaseSignOutButton()
    }
    
    fileprivate func setupFacebookLoginButton() {
        let loginButton =  FBSDKLoginButton()
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        //Custom Button
        let customButton = UIButton(type : .system)
        customButton.backgroundColor = .blue
        customButton.setTitle("Custom Login Button", for: .normal)
        customButton.setTitleColor(.white, for: .normal)
        customButton.frame = CGRect(x: 16, y: 116, width: view.frame.width - 32, height: 50)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(customButton)
        
        customButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)

    }
    
    fileprivate func setupGoogleSignInButton()  {
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 182, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    fileprivate func setupFirebaseSignOutButton() {
        let firebaseButton = UIButton(type: .system)
        firebaseButton.frame = CGRect(x: 16, y: view.frame.height - 66, width: view.frame.width - 32, height: 50)
        firebaseButton.setTitle("Sign Out Firebase", for: .normal)
        firebaseButton.backgroundColor = .orange
        firebaseButton.setTitleColor(.white, for: .normal)
        view.addSubview(firebaseButton)
        
        firebaseButton.addTarget(self, action: #selector(handleFirebaseSignOutButton), for: .touchUpInside)
        
    }
    
    /***************FIREBASE SIGN OUT**************************/
    func handleFirebaseSignOutButton()    {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Success Logout")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    /***************FACEBOOK SIGN IN*************************/
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        showProfileData()
        
    }
    
    /***************FACEBOOK SIGN OUT************************/
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("You Did Logout")
    }
    
    /*********************CUSTOM BUTTON FACEBOOK**********************/
    func handleCustomFBLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) {
            (result, err) in
            if err != nil {
                print("Custom FB Login Button Failed : ", err ?? "")
                return
            }
            
            self.showProfileData()
        }
    }
    
    func showProfileData()  {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken : accessTokenString)
        
        
        Auth.auth().signIn(with: credentials) { (user, err) in
            if err != nil   {
                print("Somenthing Error : ", err ?? "")
                return
            }
            
            print("Success logged as Facebook : ", user ?? "")
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email"]).start {
            (connection, result, err) in
            if err != nil {
                print("failed to start graph", err ?? "")
                return
            }
            
            print(result ?? "")
        }
    }
    
    
}

