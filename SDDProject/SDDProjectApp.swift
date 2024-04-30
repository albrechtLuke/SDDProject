//
//  SDDProjectApp.swift
//  SDDProject
//
//  Created by Luke Albrecht on 23/4/2024.
//

import SwiftUI
import SwiftData

@main
struct SDDProjectApp: App {
   
    
    
    
    //initialise AppViewModel
    @StateObject private var vm = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                
                CameraView()
                    .environmentObject(vm)
                //request scanner access
                    .task {
                        await vm.requestDataScannerAccessStatus()
                    }
                    .tag(1)
                    .tabItem {
                        Label("Scan", systemImage: "camera")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
                    .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                    
                        
                

                    
                
                SwiftUITestView()
                    .tag(2)
                    .tabItem {
                        Label("List", systemImage: "list.clipboard")
                    }
            }
        }
    }
}
