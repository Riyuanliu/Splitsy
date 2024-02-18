//
//  DivideView.swift
//  Splitsy
//
//  Created by Riyuan Liu on 2/17/24.
//
import SwiftUI

struct DivideView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("This is Divide View")
                .font(.title)
                .navigationBarTitle("Divide View", displayMode: .inline)

            NavigationLink(destination: DivideEvenlyView()) {
                Text("Divide Evenly")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            NavigationLink(destination: DivideByPersonView()) {
                Text("Divide by Person")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
