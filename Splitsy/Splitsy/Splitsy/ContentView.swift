//
//  ContentView.swift
//  Splitsy
//
//  Created by Manny Reyes on 2/16/24.
//

import SwiftUI


///
///
///
///
///
//This Is just the start up screen, the first thing the user will see when they open the app
let customColor = Color(red: 249.0/255.0, green: 246.0/255.0, blue: 238.0/255.0)



struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var signUpScreen: Bool = false

    
    var body: some View {
        
        NavigationView {
            //zstack controls the depth of everything, its waht allows the background to stay in the back and the foreground to stay in the front
            ZStack {
                Color(.green)
                    .ignoresSafeArea()
                
                VStack {
                    Image("Splitsy")
                                .resizable()
                                .cornerRadius(10)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fit/*@END_MENU_TOKEN@*/)
                                .position(.init(x: 195, y: 90))
                    
                    VStack {
                
                        TextField("Username", text: $username )
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(/*@START_MENU_TOKEN@*/.all, 13.0/*@END_MENU_TOKEN@*/)
                        TextField("Password", text: $password )
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(/*@START_MENU_TOKEN@*/.all, 13.0/*@END_MENU_TOKEN@*/)
                    }
                    .position(CGPoint(x: 195, y: 0))
                    
//                    Button("Sign In") {
//                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
//                    }
                    NavigationLink("Sign In",destination: HomepageView())
                                                    .font(.title3)
                                                    .accentColor(.white)
                    .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                    .accentColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                    .position(CGPoint(x: 195, y: 200))
                    
                    NavigationLink("Don't Have an Account?",destination: signUpView())
                                                    .font(.title3)
                                                    .accentColor(.white)
                }
            }
        }
        .navigationBarHidden(true)

        
    }
}
///
///
///
///
///
///
///

///
///
///
///
//user info

struct Userdata{
    var users: [[String : String]] = []
    
    func isUserDataEmpty() -> Bool{
        return users.isEmpty
    }
    
    mutating func addUser(Email: String,Username: String, Password: String, dateofbirth: String){
        let newUser = ["Email":Email, "username":Username, "password":Password, "dateofbirth":dateofbirth]
        users.append(newUser)
    }
}
///
///
///
///
///


///
///
///
///
//sign up screen
struct signUpView:View {
    @State private var newEmail: String = ""
    @State private var newUser: String = ""
    @State private var newpassword: String = ""
    @State private var newpasswordmatch: String = ""
    @State private var newDoB:String = ""
    @State private var newUserFlag: Bool = false
    
    
    var body: some View {
        ZStack {
            Color(.green)
                .ignoresSafeArea()
            
            VStack {
                Image("Splitsy")
                            .resizable()
                            .cornerRadius(10)
                            .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fit/*@END_MENU_TOKEN@*/)
                            .position(.init(x: 195, y: 90))
                
                VStack{
                    VStack{
                        Text("Email")
                        TextField("Email", text: $newEmail )
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack{
                        Text("Username")
                        TextField("Username", text: $newUser )
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack{
                        Text("Password")
                        TextField("Password", text: $newpassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                        TextField("Re-Type Password", text: $newpasswordmatch)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack{
                        Text("Date Of Birth")
                        TextField("MM/DD/YYYY", text: $newDoB)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                }
                .padding(.all)
                .position(CGPoint(x: 195, y: 0))
                
                Button("Sign up") {
                    if(newpassword == newpasswordmatch){
                        newUserFlag = true
                    }
                    
                    else{
                        print("Passwords do not match")
                        newUserFlag = false
                    }
                    
                    
                }
                
                                
            }
        }
        
        
    }
}
///
///
///
///
struct HomepageView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack(alignment: .top) {
                        NavigationLink(destination: UploadView()) {
                                                    Image("Camera")
                                                }
                        Spacer()
                        Image("Logo")
                        Spacer()
                        Image("PFP")
                    }
                    .padding()
                    
                    
                    VStack {
                        // Box for past translation
                        VStack(spacing: 0) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(maxHeight: .infinity) // Ensure the rectangle fills the height
                                    .cornerRadius(20)
                                    .fixedSize(horizontal: false, vertical: true) // Allow horizontal expansion
                                Text("Your Text Here") // Add your text
                                        .foregroundColor(.white)
                                        .padding()
                            }
                            Rectangle()
                                .fill(customColor)
                        }
                        // Box for spending summary
                        Rectangle()
                            .fill(Color.green)
                            .cornerRadius(20)
                            .frame(height: 400) // Adjust height as needed
                            .padding()
                    }
                    .padding()
                    Spacer() // Add spacer to push content to the top
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Customize navigation view style
    }
}





#Preview {
    ContentView()
}


#Preview{
    HomepageView()
}
