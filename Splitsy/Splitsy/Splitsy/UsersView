
import SwiftUI
import Foundation
import UIKit

struct User {
    let name: String
    var total: Double
    var useritems: [Item]
}

struct Item {
    let name: String
    let price: Double
}


var scanned_items: [Item] =  [
    Item(name:"Salad", price: 9.99),
    Item(name:"Burger", price: 5.99),
    Item(name:"Pasta", price: 20.99)
]

struct CurrentlyAddedUsersView: View {
    @State private var users : [User] = []
    @State private var isAddUserViewPresented = false
    @State private var individualUser: User?
    
    var body: some View {
        NavigationView {
            VStack {
                List(users, id: \.name) { user in
                    NavigationLink(destination: UserDetailsView(user: user)) {
                        Text(user.name)
                        Text(String(format: "%.2f", user.total))
                    }
                }
                
                Button("Add User") {
                    self.isAddUserViewPresented = true
                }
                .padding()
            }
            .navigationBarTitle("Users")
        }
        .fullScreenCover(isPresented: $isAddUserViewPresented) {
            AddUserView(users: self.$users) // Pass the users array to the Add User view
        }
    }
}

struct AddUserView: View {
    @Binding var users: [User]
    @State private var newUserName = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Enter Name", text: $newUserName)
                .padding()
            
            Button("Add") {
                self.users.append(User(name: self.newUserName, total: 0.00, useritems: []))
                self.presentationMode.wrappedValue.dismiss()
            }
            
        }
        .navigationBarTitle("USERS")
    }
}

struct UserDetailsView: View {
    @State var user: User
    @State private var checkedItems: [Item] = []
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(0 ..< scanned_items.count, id: \.self) { food in
                    CheckboxListItem(user: user, individualItem: scanned_items[food])
                }
            }
        }
        Text("Total")
        .navigationBarTitle(user.name)
    }
}

struct CheckboxListItem: View {
    @State private var isChecked = false
    @State var user: User
    let individualItem: Item
    
    
    var body: some View {
        HStack {
            Button(action: {
                isChecked.toggle()
            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .blue : .gray)
            }
            Text(individualItem.name)
                .foregroundColor(isChecked ? .blue : .black)
            Text(String(format: "%.2f", individualItem.price))
        }
    }
}


#Preview {
    CurrentlyAddedUsersView()
//    addUser()
}
