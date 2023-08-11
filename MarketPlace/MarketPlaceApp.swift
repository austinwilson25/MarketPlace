//
//  MarketPlaceApp.swift
//  MarketPlace
//
//  Created by Sadie Wilson on 8/7/23.
//

import SwiftUI

@main
struct MarketPlaceApp: App {
    @StateObject private var arr = ItemList()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(arr)
        }
    }
}
