//
//  Settings.swift
//  iTasks
//
//  Created by Nihaal Garud on 20/08/2024.
//

import Foundation
import SwiftUI
import LaunchAtLogin

struct SettingsView: View {
    var body: some View {
        VStack {
            
            Text("iTasks")
                .font(.system(size: 30))
                .fontWeight(.bold)
            
            Text("Version: \(getAppVersion())")
                .font(.title3)
                .padding()
            
            LaunchAtLogin.Toggle("Launch on start")
                .toggleStyle(.switch)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.gray, lineWidth: 0.5)
                )
        }
    }
    
    func getAppVersion() -> String {
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                return appVersion
            }
            return "Unknown"
        }
}
