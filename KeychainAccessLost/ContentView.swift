//
//  ContentView.swift
//  KeychainAccessLost
//
//  Created by Vladimir Espinola Lezcano on 2021-08-15.
//

import SwiftUI

struct ContentView: View {
    @State private var importantData: String = ""
    
    @State private var showingAlert = false
    
    @State private var alertText: String = ""
        
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Important Data 🔥", text: $importantData)
                    Button("Save on Keychain") {
                        guard !importantData.isEmpty  else { return }
                        
                        keychain[KechainDataIdentifiers.importantData] = importantData
                        KeychainDataRestorer.shared.saveImportantDataIfNeeded(importantData, force: true)
                        
                        alertText = "Saved!"
                        showingAlert = true
                    }
                }
                Section {
                    Button("Get data from Backup") {
                        if let stored = KeychainDataRestorer.shared.storedImportantData {
                            importantData = stored
                            alertText = "Got it from backup: \(stored)"
                        } else {
                            alertText = "No stored data have been found"
                        }
            
                        showingAlert = true
                    }
                    Button("Get data from Keychain") {
                        if let stored = keychain[KechainDataIdentifiers.importantData] {
                            importantData = stored
                            alertText = "Got it from Keychain: \(stored)"
                        } else {
                            importantData = ""
                            alertText = "Keychain is empty"
                        }
                        showingAlert = true
                    }
                }
                
                Section(header: Text("Here you will see the solution 🍻")) {
                    Button("Restore Keychain's data from Backup") {
                        
                        if let data = KeychainDataRestorer.shared.getImportantData() {
                            alertText = "\"\(data)\" was Restored! Now verify if your data is on the Keychain."
                        } else {
                            alertText = "Keychain is empty"
                        }
                        showingAlert = true
                    }
                }
                
                Section(footer: Text("You should check your data from Keychain and Backup after this operation.")) {
                    Button("Delete from Keychain") {
                        importantData = ""
                        
                        if let _ = keychain[KechainDataIdentifiers.importantData] {
                            keychain[KechainDataIdentifiers.importantData] = nil
                            
                            alertText = "Deleted!"
                        } else {
                            alertText = "Keychain is empty"
                        }
                        showingAlert = true
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationBarTitle("Implementation Test")
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text(alertText))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
