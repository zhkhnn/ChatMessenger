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
    let storage: Storage
    static let shared = FirebaseManager()
    override init(){
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        super.init()
    }
}
struct LoginView: View {
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
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
                            shouldShowImagePicker.toggle()
                        }label:{
                            VStack{
                                if let image = self.image{
                                    Image(uiImage: image).resizable().scaledToFit().frame(width: 128, height: 128).cornerRadius(64)
                                }
                                else{
                                    Image(systemName: "person.fill").font(.system(size: 64)).padding().foregroundColor(Color(.label))
                                }
                            }.overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 3))
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
        .navigationViewStyle(StackNavigationViewStyle()).fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
            ImagePicker(image: $image)
        }
        
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
            self.persistImageToStorage()
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
    private func persistImageToStorage() {
    //        let filename = UUID().uuidString
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let ref = FirebaseManager.shared.storage.reference(withPath: uid)
            guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
            ref.putData(imageData, metadata: nil) { metadata, err in
                if let err = err {
                    self.loginStatus = "Failed to push image to Storage: \(err)"
                    return
                }
                
                ref.downloadURL { url, err in
                    if let err = err {
                        self.loginStatus = "Failed to retrieve downloadURL: \(err)"
                        return
                    }
                    
                    self.loginStatus = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                    print(url?.absoluteString)
                }
            }
        }
}

struct ContentView_Previews1: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
