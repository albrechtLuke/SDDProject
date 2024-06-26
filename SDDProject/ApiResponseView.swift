//
//  ApiResponseView.swift
//  SDDProject
//
//  Created by Luke Albrecht on 29/4/2024.
//

import SwiftUI
import SwiftfulLoadingIndicators



struct ApiResponseView: View {
    @State private var productName: String = ""
    @State private var ingredientsTags: [String] = []
    @Binding var isPresented: Bool
    @Binding var foundBarcode: String?
    let barcodeID: String
    
    var body: some View {
        NavigationStack {
            VStack {
                //changes what to display, change later to a more useful variable
//                if barcodeID != "no response yet :(" {
                    if ingredientsTags.isEmpty {
//                        Text("Loading ingredientsTags: \(barcodeID)...")
//                            .padding()
                        LoadingIndicator(size: .large)
                    } else {
                        List(ingredientsTags, id: \.self) { tag in
                            Text(tag)
                        }
                    }
//                } else {
//                    Text("Loading foundBarcode: \(barcodeID)...")
//                        .padding()
//                    LoadingIndicator(size: .large)
//                }
            }
            .navigationTitle(productName)
            .navigationBarItems(trailing: Button(action: {
                                foundBarcode = nil
                                isPresented = false
                                
                            }) {
                                Image(systemName: "x.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding()
                            })
        }
        .onAppear {
            Task {
                await fetchData()
            }
        }
    }
    
    func fetchData() async {
        // Define the URL

        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(barcodeID).json"

        // Define the URL object
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        // Define the request object
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            // Perform the request
            let (data, response) = try await URLSession.shared.data(for: request)

            // Check for response status
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }

            // Parse the JSON data
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let product = json["product"] as? [String: Any],
               let productNameValue = product["product_name"] as? String,
               let ingredientsTagsArray = product["ingredients_tags"] as? [String] {
                // Access the value of the "product_name" key
                productName = productNameValue
                
                //remove "en:" prefix
                ingredientsTags = ingredientsTagsArray.map { $0.replacingOccurrences(of: "en:", with: "") }
            } else {
                print("Failed to parse JSON or extract product name and ingredients tags")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}

