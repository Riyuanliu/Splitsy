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
//user info

class UserData: ObservableObject {
    static let shared = UserData()

    @Published var users: [[String: String]] = {
        return UserDefaults.standard.array(forKey: "UserDataKey") as? [[String: String]] ?? []
    }()

    private init() {}

    private func saveUserData() {
        UserDefaults.standard.set(users, forKey: "UserDataKey")
    }

    func addUser(Email: String, Username: String, Password: String, dateofbirth: String) {
        let newUser = ["Email": Email, "username": Username, "password": Password, "dateofbirth": dateofbirth]
        users.append(newUser)
        saveUserData()
    }

    func isUserArrayEmpty() -> Bool {
        return users.isEmpty
    }

    func isUserExists(username: String, password: String) -> Bool {
        return users.contains { $0["username"] == username && $0["password"] == password }
    }

    func printUserData() {
        print("User Data:")
        for user in users {
            print("Username: \(user["username"] ?? "") | Password: \(user["password"] ?? "")")
        }
    }
    
    func isCurrentEmailValid(currentEmail: String) -> Bool {
            return users.contains { $0["Email"] == currentEmail }
        }

    
    
    func updateEmail(currentEmail: String, newEmail: String) {
            guard var user = users.first(where: { $0["Email"] == currentEmail }) else {
                // Handle case where the current email is not found
                return
            }

            user["Email"] = newEmail

            // Update the user in the array
            if let index = users.firstIndex(where: { $0["Email"] == currentEmail }) {
                users[index] = user
            }
        }
    
    func updatePassword(username: String, newPassword: String) {
            if let index = users.firstIndex(where: { $0["username"] == username }) {
                users[index]["password"] = newPassword
            }
        }
    
    func removeUser(email: String, password: String) -> Bool {
            guard let index = users.firstIndex(where: { $0["Email"] == email && $0["password"] == password }) else {
                return false // User not found
            }

            users.remove(at: index)
            objectWillChange.send()
            return true
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
//This Is just the start up screen, the first thing the user will see when they open the app
struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var signUpScreen: Bool = false
    @State private var signInSuccess: Bool = false
    @ObservedObject var userData: UserData
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.green)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Image("Splitsy")
                        .resizable()
                        .cornerRadius(10)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fit/*@END_MENU_TOKEN@*/)

                    VStack {
                        TextField("Username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.all, 13.0)

                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.all, 13.0)
                    }
                    .padding(.vertical)

                    NavigationLink(destination: HomeView(), isActive: $signInSuccess) {
                        EmptyView()
                    }

                    Button("Sign In") {
                        if UserData.shared.isUserExists(username: username, password: password) {
                            print("Sign in successful!")
                            signInSuccess = true
                        } else {
                            print("Invalid username or password.")
                            UserData.shared.printUserData()
                        }
                    }
                    .font(.largeTitle)
                    .foregroundColor(.white)

                    NavigationLink("Don't Have an Account?", destination: signUpView(userData: UserData.shared, showSignIn: $signUpScreen))
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }
            .navigationBarHidden(true)
        }
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
//sign up screen
struct signUpView: View {
    @State private var newEmail: String = ""
    @State private var newUser: String = ""
    @State private var newPassword: String = ""
    @State private var newPasswordMatch: String = ""
    @State private var newDoB: String = ""
    @State private var newUserFlag: Bool = false
    @ObservedObject var userData: UserData
    @Binding var showSignIn: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var shouldShowAlert = false

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

                VStack {
                    VStack {
                        Text("Email")
                        TextField("Email", text: $newEmail)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack {
                        Text("Username")
                        TextField("Username", text: $newUser)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack {
                        Text("Password")
                        SecureField("Password", text: $newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        SecureField("Re-Type Password", text: $newPasswordMatch)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }

                    VStack {
                        Text("Date Of Birth")
                        TextField("MM/DD/YYYY", text: $newDoB)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding()

                Button("Sign up") {
                    if userData.isUserArrayEmpty() {
                        if validateSignUp() {
                            newUserFlag = true
                            userData.addUser(Email: newEmail, Username: newUser, Password: newPassword, dateofbirth: newDoB)
                            showAlert = true
                            alertMessage = "Account created successfully!"
                            showSignIn = true
                            shouldShowAlert = true

                            // Reset input fields
                            newEmail = ""
                            newUser = ""
                            newPassword = ""
                            newPasswordMatch = ""
                            newDoB = ""
                        } else {
                            newUserFlag = false
                            showAlert = true
                            alertMessage = "Unable to create account. Check that passwords match and user is older than 13."
                            shouldShowAlert = true
                        }
                    } else {
                        if userData.isUserExists(username: newUser, password: newPassword) {
                            newUserFlag = true
                            showAlert = true
                            alertMessage = "Username is already taken. Choose a different username."
                            shouldShowAlert = true
                        } else {
                            if validateSignUp() {
                                newUserFlag = true
                                userData.addUser(Email: newEmail, Username: newUser, Password: newPassword, dateofbirth: newDoB)
                                showAlert = true
                                alertMessage = "Account created successfully!"
                                showSignIn = true
                                shouldShowAlert = true

                                // Reset input fields
                                newEmail = ""
                                newUser = ""
                                newPassword = ""
                                newPasswordMatch = ""
                                newDoB = ""
                            } else {
                                newUserFlag = false
                                showAlert = true
                                alertMessage = "Unable to create account. Check that passwords match and user is older than 13."
                                shouldShowAlert = true
                            }
                        }
                    }
                }
                .alert(isPresented: $shouldShowAlert) {
                    Alert(
                        title: Text("Alert"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("Dismiss"), action: {
                            shouldShowAlert = false
                        })
                    )
                }
            }
        }
    }

    private func validateSignUp() -> Bool {
        guard newPassword == newPasswordMatch else {
            print("Passwords do not match.")
            return false
        }

        guard !newUser.isEmpty else {
            print("Username is required")
            return false
        }

        guard let year = extractYearFromDOB(newDoB), year <= 2011 else {
            print("Invalid date of birth. Must be older than 13.")
            return false
        }

        return true
    }

    private func extractYearFromDOB(_ dob: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: dob) {
            let calendar = Calendar.current
            return calendar.component(.year, from: date)
        }
        return nil
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
///
///
struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(.green)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    Image("splitsy-logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()

                    Spacer()

                    HStack {
                        NavigationLink(destination: CameraView()) {
                            Image(systemName: "camera")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }

                        Spacer()

                        NavigationLink(destination: TransactionHistoryView()) {
                            Image(systemName: "clock")
                                .font(.system(size: 40)) // Adjust the size of the clock icon
                                .foregroundColor(.white)
                        }
                        .padding(.top, -10) // Adjust the top padding to move the clock icon up

                        Spacer()

                        NavigationLink(destination: ProfileView(userData: UserData.shared)) {
                            Image(systemName: "gear")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                    .padding()
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
///
///
///
///
///
///
///
struct TransactionHistoryView: View {
    struct Transaction {
        let id = UUID()
        let restaurant: String
        let totalAmount: Double
        let userAmount: Double
        let participants: [String]
    }

    let transactions = [
        Transaction(restaurant: "Restaurant A", totalAmount: 100.0, userAmount: 25.0, participants: ["User1", "User2"]),
        Transaction(restaurant: "Cafe B", totalAmount: 50.0, userAmount: 15.0, participants: ["User3", "User4"]),
        Transaction(restaurant: "Coffee Shop C", totalAmount: 20.0, userAmount: 5.0, participants: ["User2", "User3"]),
    ]

    var body: some View {
        ZStack {
            Color(.green)
                .ignoresSafeArea()

            VStack {
                Text("Transaction History")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                List(transactions, id: \.id) { transaction in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dinner at \(transaction.restaurant)")
                            .foregroundColor(.red)
                        Text(String(format: "You paid $%.2f / $%.2f", transaction.userAmount, transaction.totalAmount))
                            .foregroundColor(.green)
                        Text("Participants: \(transaction.participants.joined(separator: ", "))")
                            .foregroundColor(.red)
                    }
                    .padding(.vertical, 8)
                }
                .listStyle(InsetListStyle())
            }
            .padding()
        }
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
///
///
struct CameraView: View {
    @State private var showUploadScreen = false

    var body: some View {
        ZStack {
            Color(.green)
                .ignoresSafeArea()

            VStack {
                Spacer()

                RoundedRectangle(cornerRadius: 15)
                    .frame(width: 200, height: 200)
                    .foregroundColor(.white)
                    .overlay(
                        Image(systemName: "camera.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                    )

                Spacer()

                Button("Upload Pictures") {
                    // Set the flag to show the upload screen
                    showUploadScreen = true
                }
                .font(.title)
                .foregroundColor(.white)
                .sheet(isPresented: $showUploadScreen) {
                    // Present the upload screen
                    UploadPicturesView()
                }

                Text("Camera View")
                    .foregroundColor(.white)
            }
        }
    }
}

struct UploadPicturesView: View {
    var body: some View {
        // Your code for the upload pictures view goes here
        Text("Upload Pictures Screen")
            .foregroundColor(.black)
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
///
///
struct ProfileView: View {
    @State private var signOut = false
    @State private var showUserDataView = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var userData: UserData

    var body: some View {
        NavigationView {
            ZStack {
                Color(.green)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Profile & Settings")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    Button("My Profile") {
                        // Set the flag to show the user data view
                        showUserDataView = true
                    }
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .sheet(isPresented: $showUserDataView) {
                        // Present the user data view
                        UserDataView(userData: userData)
                    }

                    NavigationLink(destination: CUserView(userData: UserData.shared)) {
                        Text("Change Username")
                            .modifier(ProfileButtonStyle())
                    }

                    NavigationLink(destination: CEmailView(userData: UserData.shared)) {
                        Text("Change Email")
                            .modifier(ProfileButtonStyle())
                    }

                    NavigationLink(destination: CPasswordView(userData: UserData.shared)) {
                        Text("Change Password")
                            .modifier(ProfileButtonStyle())
                    }

                    NavigationLink(destination: ContentView(userData: userData), isActive: $signOut) {
                        EmptyView()
                    }

                    Button("Sign Out") {
                        // Perform any necessary sign-out logic here
                        // For now, just set the signOut flag to trigger NavigationLink
                        signOut = true
                    }
                    .modifier(ProfileButtonStyle())

                    NavigationLink(destination: DeleteAccountView()) {
                        Text("Permanently Delete Account")
                            .modifier(ProfileDeleteButtonStyle())
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
            .onAppear {
                signOut = false
            }
        }
    }
}

// Custom modifier for profile buttons
struct ProfileButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.black)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
    }
}

// Custom modifier for delete account button
struct ProfileDeleteButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .accentColor(.red)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
    }
}

struct UserDataView: View {
    @ObservedObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("User Data View")
                .font(.largeTitle)
                .foregroundColor(.black)
            
            Spacer()

            // Display the user's username (dummy data)
            Text("Username:JohnDoe")
                .foregroundColor(.black)
                .padding()

            // Display the user's email (dummy data)
            Text("Email: john.doe@example.com")
                .foregroundColor(.black)
                .padding()

            // Display the user's date of birth (dummy data)
            Text("Date of Birth: 01/01/1990")
                .foregroundColor(.black)
                .padding()

            Spacer()

            // Close button to dismiss the UserDataView
            Button("Close") {
                // Close the UserDataView by setting the presentationMode
                presentationMode.wrappedValue.dismiss()
            }
            .font(.title)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .padding()
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
///
///
///
///
struct CUserView: View {
    
    @ObservedObject var userData: UserData
    @State private var curUserN: String = ""
    @State private var curPass: String = ""
    @State private var newchUserN: String = ""
    @State private var newchUserNmatch: String = ""
    @State private var showAlert = false
    
    
    
    var body: some View {
        ZStack {
            Color(.green)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text("Change Username")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Spacer()
                
                TextField("Current Username", text: $curUserN)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer(minLength: 10) // Adjust the spacing between text fields
                
                TextField("Enter your password", text: $curPass)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer(minLength: 10) // Adjust the spacing between text fields
                
                TextField("New Username", text: $newchUserN)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer(minLength: 10) // Adjust the spacing between text fields
                
                TextField("Confirm New Username", text: $newchUserNmatch)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                
                Button("Confirm") {
                    if !UserData.shared.isUserExists(username: curUserN, password: curPass) {
                        showAlert = true
                    } else if newchUserN == newchUserNmatch {
                        // New usernames match
                        showAlert = false
                        // Update the existing username in UserData
                        if let userIndex = userData.users.firstIndex(where: { $0["username"] == curUserN }) {
                            userData.users[userIndex]["username"] = newchUserN
                            // Handle accordingly, you might want to show a success message or perform some action
                            print("Change Sucessful")
                            UserData.shared.printUserData()

                        }
                    } else {
                        // New usernames do not match
                        showAlert = false
                        // Handle accordingly, you might want to show an alert or perform some action
                        print("Change Un-Sucessful")
                        UserData.shared.printUserData()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .alert(isPresented: $showAlert){
                    Alert(                        
                        title: Text("Alert"),
                        message: Text("Incorrect username or password."),
                        dismissButton: .default(Text("Dismiss"))
                    )
                }
        
                    
            }
            .padding()
                
        }
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
///
///
///
struct CEmailView: View {
    @ObservedObject var userData: UserData
    @State private var curEmail: String = ""
    @State private var newchEmail: String = ""
    @State private var newchEmailmatch: String = ""
    @State private var showAlert = false
    @State private var emailChangeSuccess = false

    var body: some View {
        ZStack {
            Color(.green)
                .ignoresSafeArea()

            VStack(spacing: 10) {
                Text("Change Email")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                Spacer()

                TextField("Current Email", text: $curEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer(minLength: 10)

                TextField("New Email", text: $newchEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer(minLength: 10)

                TextField("Confirm New Email", text: $newchEmailmatch)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()

                Button("Confirm") {
                    if UserData.shared.isCurrentEmailValid(currentEmail: curEmail) {
                        if newchEmail == newchEmailmatch {
                            // Update the existing email to the new one
                            UserData.shared.updateEmail(currentEmail: curEmail, newEmail: newchEmail)
                            showAlert = true
                            emailChangeSuccess = true
                            UserData.shared.printUserData()
                        } else {
                            showAlert = true
                            emailChangeSuccess = false
                            UserData.shared.printUserData()
                        }
                    } else {
                        showAlert = true
                        emailChangeSuccess = false
                        UserData.shared.printUserData()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Alert"),
                    message: Text(emailChangeSuccess ? "Email changed successfully!" : "Failed to change email. Please check your input."),
                    dismissButton: .default(Text("Dismiss"))
                )
            }
        }
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
///
///
///
struct CPasswordView: View {
    @ObservedObject var userData: UserData
    @State private var curUsername: String = ""
    @State private var curPassword: String = ""
    @State private var newPassword: String = ""
    @State private var newPasswordMatch: String = ""
    @State private var showAlert = false
    @State private var passwordChangeSuccess = false

    var body: some View {
        ZStack {
            Color(.green)
                .ignoresSafeArea()

            VStack(spacing: 10) {
                Text("Change Password")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                Spacer()

                TextField("Current Username", text: $curUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer(minLength: 10)

                SecureField("Current Password", text: $curPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer(minLength: 10)

                SecureField("New Password", text: $newPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer(minLength: 10)

                SecureField("Confirm New Password", text: $newPasswordMatch)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()

                Button("Confirm") {
                    if userData.isUserExists(username: curUsername, password: curPassword) {
                        if newPassword == newPasswordMatch {
                            // Update the existing password to the new one
                            userData.updatePassword(username: curUsername, newPassword: newPassword)
                            showAlert = true
                            passwordChangeSuccess = true
                            UserData.shared.printUserData()
                        } else {
                            showAlert = true
                            passwordChangeSuccess = false
                            UserData.shared.printUserData()
                        }
                    } else {
                        showAlert = true
                        passwordChangeSuccess = false
                        UserData.shared.printUserData()
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Alert"),
                    message: Text(passwordChangeSuccess ? "Password changed successfully!" : "Failed to change password. Please check your input."),
                    dismissButton: .default(Text("Dismiss"))
                )
            }
        }
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
///
///
///
///
struct DeleteAccountView: View {
    @EnvironmentObject var userData: UserData // Inject the UserData environment object
    @Environment(\.presentationMode) var presentationMode
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false

    var body: some View {
        ZStack{
            Color(.green)
                .ignoresSafeArea()
            
            VStack {
                Text("Permanently Delete Account")
                    .font(.largeTitle)
                    .foregroundColor(.white)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Delete Account") {
                    // Assuming you have email and password as @State variables
                    if UserData.shared.removeUser(email: email, password: password) {
                        print("Account deleted successfully!")
                        presentationMode.wrappedValue.dismiss() // This will dismiss the current view
                    }else {
                        print("Unable to delete account. Check email and password.")
                    }
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Account Deleted"),
                    message: Text("Your account has been permanently deleted."),
                    dismissButton: .default(Text("OK")) {
                        // No action needed here, as we're already navigating back
                    }
                )
            }
        }
    }

    private func deleteAccount(email: String, password: String) -> Bool {
        // Implement the logic to delete the account from the array
        // Return true if the deletion is successful, otherwise false
        // You may want to use your UserData class for this logic
        UserData.shared.removeUser(email: email, password: password)
        UserData.shared.printUserData()
        
        return true
    }

   
}
///
///
///
///
///
///




#Preview {
    ContentView(userData: UserData.shared)
}

#Preview {
    signUpView(userData: UserData.shared, showSignIn: .constant(true))
}

#Preview {
    HomeView()
}

#Preview {
    CameraView()
}

#Preview {
    ProfileView(userData: UserData.shared)
}
