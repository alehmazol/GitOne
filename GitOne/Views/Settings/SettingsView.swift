//
//  SettingsView.swift
//  GitOne
//
//  Created by Aleh Mazol on 29/03/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(wrappedValue: ColorTheme.systemTheme.id, "systemColorScheme") var applicationColorScheme
    let theme = String(localized: "Theme", defaultValue: "Theme")
    let generalSection = String(localized: "General", defaultValue: "General")
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker(theme, selection: $applicationColorScheme) {
                        Text(ColorTheme.systemTheme.name).tag(ColorTheme.systemTheme.id)
                        Text(ColorTheme.darkTheme.name).tag(ColorTheme.darkTheme.id)
                        Text(ColorTheme.lightTheme.name).tag(ColorTheme.lightTheme.id)
                    }
                    .onChange(of: applicationColorScheme) { _, newValue in
                        let scenes = UIApplication.shared.connectedScenes
                        guard let scene = scenes.first as? UIWindowScene else { return }
                        scene.keyWindow?.overrideUserInterfaceStyle =
                            newValue == ColorTheme.darkTheme.id
                                ? .dark
                                : newValue == ColorTheme.lightTheme.id
                                    ? .light
                                    : .unspecified
                    }
                    
                    NavigationLink {
                        DescriptionView()
                    } label: {
                        Text(String(localized: "Description", defaultValue: "Description"))
                    }
                } header: {
                    Text(generalSection)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .settingsStyling()
        }
    }
}

#Preview {
    SettingsView()
}
