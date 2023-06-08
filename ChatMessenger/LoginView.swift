//
//  ContentView.swift
//  ChatMessenger
//
//  Created by Aruzhan Zhakhan on 07.06.2023.
//

import SwiftUI
import Firebase
class FirebaseManager: NSObject{
    let auth: Auth
    static let shared = FirebaseManager()
    override init(){
        FirebaseApp.configure()
        self.auth = Auth.auth()
        super.init()
    }
}
struct LoginView: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("picker")){
                        Text("Login").tag(true)
                        Text("Create account").tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    if !isLoginMode{
                        Button{
                            
                        }label:{
                            Image(systemName: "person.fill").font(.system(size: 64)).padding()
                        }
                    }
                    
                    TextField("Email", text: $email).keyboardType(.emailAddress).autocapitalization(.none).padding(12).background(Color.white)
                    SecureField("Password", text: $password).padding(12).background(Color.white)
                    Button{
                        handleAction()
                    }label:{
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account").foregroundColor(.white)
                                .padding(.vertical, 10).font(.system(size: 14, weight: .bold))
                            Spacer()
                        }.background(Color.blue)
                    }
                    Text(self.loginStatus).foregroundColor(.red)
                }
                
            }
            .navigationTitle(isLoginMode ? "Login" : "Create account")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    private func handleAction(){
        if isLoginMode{
            loginUser()
        }
        else{
            createNewAccount()
        }
    }
    @State var loginStatus = ""
    private func createNewAccount(){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password){
            result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatus = "Failed to create user: \(err)"
                return
            }
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.loginStatus = "Successfully created user: \(result?.user.uid ?? "")"
        }
    }
    private func loginUser(){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password){
            result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.loginStatus = "Failed to login user: \(err)"
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.loginStatus = "Successfullt logged in as user: \(result?.user.uid ?? "")"
        }
    }
}

struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
