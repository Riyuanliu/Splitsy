//
//  UploadView.swift
//  Splitsy
//
//  Created by Riyuan Liu on 2/17/24.
//
import SwiftUI
import Foundation
import UIKit
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        imagePickerController.sourceType = sourceType
        return imagePickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = pickedImage
            }

            picker.dismiss(animated: true, completion: nil)
        }
    }
}

struct UploadView: View {
    @State private var isPresentingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var jsonResponse: String = "" // Store the JSON response
    @State private var isJSONSaved: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Button(action: {
                    // Action for the button
                    isPresentingImagePicker.toggle()
                }) {
                    Text("Upload Image")
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $isPresentingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage, sourceType: selectedSourceType)
                        .onDisappear {
                            if let selectedImage = selectedImage {
                                uploadImageAndProcess(image: selectedImage)
                            }
                        }
                }

                
                    NavigationLink(destination: DivideView()) {
                        Text("Navigate to Divide View")
                            .foregroundColor(.green)
                    }
                

                if !jsonResponse.isEmpty {
                    Text("JSON Response:")
                    Text(jsonResponse)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
            .navigationBarTitle("Upload and Save JSON")
        }
    }



    func uploadImageAndProcess(image: UIImage) {
        print("tf")
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert image to data")
            return
        }
        
        let url = URL(string: "https://api.taggun.io/api/receipt/v1/verbose/file")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("0398d800ce0911eeb72409b0b60cbbed", forHTTPHeaderField: "apikey")
        
        var body = Data()
        
        // Append image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Append other parameters
        let parameters = [
            "refresh": "false",
            "incognito": "false",
            "extractTime": "false"
        ]
        
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            print("Response status code: \(httpResponse.statusCode)")

            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response data: \(jsonString)")

                        // Save response data to a JSON file
                        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            let fileURL = documentsDirectory.appendingPathComponent("response.json")

                            do {
                                try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted).write(to: fileURL)
                                print("Response data saved to: \(fileURL)")
                            } catch {
                                print("Failed to save response data to file: \(error)")
                            }
                        }
                    }
                } catch {
                    print("Failed to parse response data as JSON: \(error)")
                }
            }
        }

        task.resume()
    }

    // Example usage:
    // Assuming you have a UIImage named "image"
    // uploadImageAndProcess(image: image)


    // Example usage:
    // Assuming you have a UIImage named "image"
    // uploadImageAndProcess(image: image)


    // Example usage:
    // Assuming you have a UIImage named "image"
    // uploadImageAndProcess(image: image)

}
#Preview {
    ContentView()
}
