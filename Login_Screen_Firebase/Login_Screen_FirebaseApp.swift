//
//  Login_Screen_FirebaseApp.swift
//  Login_Screen_Firebase
//
//  Created by Marcin on 02/02/2022.
//

import SwiftUI
import Firebase

@main
struct Login_Screen_FirebaseApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
