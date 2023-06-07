//
//  ContentView.swift
//  ChatMessenger
//
//  Created by Aruzhan Zhakhan on 07.06.2023.
//

import SwiftUI

struct ContentView: View {
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
                        
                    }label:{
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Log In" : "Create Account").foregroundColor(.white)
                                .padding(.vertical, 10).font(.system(size: 14, weight: .bold))
                            Spacer()
                        }.background(Color.blue)
                    }
                }
                
            }
            .navigationTitle(isLoginMode ? "Login" : "Create account")
            
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
