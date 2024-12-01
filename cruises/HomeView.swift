//
//  HomeView.swift
//  cruises
//
//  Created by Manuel Braun on 22.11.24.
//

import Foundation
import SwiftUI


struct HomeView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                CruisesList()
            }
            Tab("Profil", systemImage: "person") {
                ProfileView()
            }
            Tab("Favoriten", systemImage: "bookmark") {
                FavoritesView()
            }
            Tab("Einstellungen", systemImage: "gearshape.fill") {
                SettingsView()
            }
        }
    }
}

#Preview {
    HomeView()
}
