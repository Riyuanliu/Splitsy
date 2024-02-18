//
//  UploadView.swift
//  Splitsy
//
//  Created by Riyuan Liu on 2/17/24.
//
import SwiftUI

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
        let apiKey = "TEST" // Replace with your actual API key
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Error: Failed to convert image to data")
            return
        }

        let url = URL(string: "https://ocr.asprise.com/api/v1/receipt")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append(Data("--\(boundary)\r\n".utf8))
        body.append(Data("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".utf8))
        body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
        body.append(imageData)
        body.append(Data("\r\n--\(boundary)--\r\n".utf8))

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: responseData, options: .prettyPrinted)
                        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                        let jsonURL = documentsDirectory.appendingPathComponent("response.json")
                        try jsonData.write(to: jsonURL)
                        print("JSON Response saved to:", jsonURL.absoluteString)
                        self.isJSONSaved = true
                    } catch {
                        print("Error saving JSON: \(error.localizedDescription)")
                    }
                }
            } else {
                print("HTTP Error: \(response.debugDescription)")
            }
        }.resume()
    }
}
