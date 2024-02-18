//
//  UploadView.swift
//  Splitsy
//
//  Created by Riyuan Liu on 2/17/24.
//
import SwiftUI
import Foundation
import UIKit

struct ReceiptResponse: Decodable {
    let ocrType: String
    let requestId: String
    let refNo: String
    let fileName: String
    let receipts: [Receipt]
    // Add other properties as needed

    enum CodingKeys: String, CodingKey {
        case ocrType = "ocr_type"
        case requestId = "request_id"
        case refNo = "ref_no"
        case fileName = "file_name"
        case receipts
        // Add other coding keys for the remaining properties
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        ocrType = try container.decode(String.self, forKey: .ocrType)
        requestId = try container.decode(String.self, forKey: .requestId)
        refNo = try container.decode(String.self, forKey: .refNo)
        fileName = try container.decode(String.self, forKey: .fileName)
        receipts = try container.decode([Receipt].self, forKey: .receipts)
        // Decode other properties
    }
}

struct Receipt: Decodable {
    let merchantName: String
    let merchantAddress: String
    let merchantPhone: String?
    let country: String
    let receiptNo: String
    let date: String
    let time: String
    let items: [Item]
    let currency: String
    let total: Double
}

struct Item: Decodable {
    let amount: Double
    let description: String
    let quantity: Int
}


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
    @State private var isProcessingImage: Bool = false
    @State private var jsonResponse: String = "" // Store the JSON response
    @State private var isJSONSaved: Bool = false
    @State private var doneProcessing: Bool = false

    var body: some View {
        ZStack{
            NavigationView {
                VStack {
                }
                .padding()
                .navigationBarTitle("Upload and Save JSON")
            }
            VStack{
                Spacer()
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
                Spacer()
                if isProcessingImage {
                    // Show loading screen while processing
                    ProgressView("Processing Image...")
                }
                if !doneProcessing{
                    
                    NavigationLink(destination: DivideView()) {
                        Text("Navigate to Divide View")
                            .foregroundColor(.green)
                    }
                    
                }

                if !jsonResponse.isEmpty {
                    Text("JSON Response:")
                    Text(jsonResponse)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
        }
    }

    func uploadImageAndProcess(image: UIImage) {
        // Set the processing flag to true
        isProcessingImage = true
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert image to data")
            return
        }
        
        let url = URL(string: "https://ocr.asprise.com/api/v1/receipt")! // Modified URL
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("YOUR_API_KEY_HERE", forHTTPHeaderField: "apikey") // Don't forget to replace "YOUR_API_KEY_HERE" with your actual API key
        
        var body = Data()
        
        // Append image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Append other parameters
        let parameters = [
            "recognizer": "auto",
            "ref_no": ""
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
                        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                                            let fileURL = documentsDirectory.appendingPathComponent("response.json")

                                            do {
                                                try jsonString.write(to: fileURL, atomically: true, encoding: .utf8)
                                                print("Response data saved to: \(fileURL)")
                                            } catch {
                                                print("Failed to save response data to file: \(error)")
                                            }
                                        }
                    }
                } catch {
                    print("Failed to parse response data as JSON: \(error)")
                }
                isProcessingImage = false;
                doneProcessing = true;
                processJSONFile()
            }
            // Handle completion
        }
        func processJSONFile() {
            // Get the URL of the JSON file
            guard let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("response.json") else {
                print("JSON file not found")
                return
            }

            do {
                // Read the JSON data from the file
                let jsonData = try Data(contentsOf: fileURL)

                // Decode the JSON data into ReceiptResponse struct
                let decoder = JSONDecoder()
                let receiptResponse = try decoder.decode(ReceiptResponse.self, from: jsonData)

                // Access the receipts array and iterate over each receipt
                for receipt in receiptResponse.receipts {
                    print("Merchant: \(receipt.merchantName)")
                    print("Address: \(receipt.merchantAddress)")
                    print("Receipt No: \(receipt.receiptNo)")
                    print("Date: \(receipt.date)")
                    print("Time: \(receipt.time)")
                    print("Total: \(receipt.currency) \(receipt.total)")

                    // Iterate over each item in the receipt
                    for item in receipt.items {
                        print("Item: \(item.description)")
                        print("Amount: \(receipt.currency) \(item.amount)")
                        print("Quantity: \(item.quantity)")
                    }
                }
            } catch {
                print("Error processing JSON file: \(error)")
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
    UploadView()
}
