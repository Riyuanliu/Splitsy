//
//  DivideEvenlyView.swift
//  Splitsy
//
//  Created by Riyuan Liu on 2/17/24.
//

import SwiftUI
struct DivideEvenlyView: View {
    @State private var tipPercentage = 10.0
    @State private var numberOfPeople = ""
    @State private var isConfirmed = false

    var body: some View {
        VStack {
            ZStack {
                VStack{
                    Image("Logo")
                    Rectangle()
                        .fill(customColor)
                        .padding()
                        .cornerRadius(20)
                        .overlay(
                            VStack {
                                Text("Tip Percentage: \(Int(tipPercentage))%")
                                    .padding()
                                Slider(value: $tipPercentage, in: 0...30, step: 1)
                                    .padding()
                                TextField("Number of People", text: $numberOfPeople)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding()
                                Spacer()
                                Button(action: {
                                    // Action for the button
                                    isConfirmed.toggle()
                                }) {
                                    Text("Confirm")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .sheet(isPresented: $isConfirmed) {
                                    PayView()
                                }
                            }
                        )
                }
            }
        }
    }
}
