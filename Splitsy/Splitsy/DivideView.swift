//
//  DivideView.swift
//  Splitsy
//
//  Created by Riyuan Liu on 2/17/24.
//
import SwiftUI

struct DivideView: View {
    var body: some View {
        ZStack {
            VStack {
                HStack{
                    NavigationLink(destination: UploadView()) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Image("Logo")
                    Spacer()
                }
                
                Spacer() // Add spacer to push buttons to the top

                NavigationLink(destination: DivideEvenlyView()) {
                    Text("Divide Evenly")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(20) // Set corner radius for a rounded appearance
                        .aspectRatio(1.0, contentMode: .fit) // Set aspect ratio for a square box
                }
                .padding() // Add padding to the button

                NavigationLink(destination: DivideByPersonView()) {
                    Text("Divide by Person")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(20) // Set corner radius for a rounded appearance
                        .aspectRatio(1.0, contentMode: .fit) // Set aspect ratio for a square box
                }
                .padding() // Add padding to the button

                Spacer() // Add spacer to push buttons to the bottom
            }
        }
        .padding()
    }
}


#Preview {
    DivideView()
}
