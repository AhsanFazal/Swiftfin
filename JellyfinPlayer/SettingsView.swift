//
//  SettingsView.swift
//  JellyfinPlayer
//
//  Created by Aiden Vigue on 4/29/21.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @Binding var close: Bool;
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var globalData: GlobalData
    @EnvironmentObject var jsi: justSignedIn
    @State private var username: String = "";
    @State private var inNetworkStreamBitrate: Int = 40000000;
    
    func onAppear() {
        _username.wrappedValue = globalData.user?.username ?? "";
    }
    
    var body: some View {
        NavigationView() {
            Form() {
                Section(header: Text("Playback settings")) {
                    Picker("Default local playback bitrate", selection: $inNetworkStreamBitrate) {
                        Group {
                            Text("1080p - 60 Mbps").tag(60000000)
                            Text("1080p - 40 Mbps").tag(40000000)
                            Text("1080p - 20 Mbps").tag(20000000)
                            Text("1080p - 15 Mbps").tag(15000000)
                            Text("1080p - 10 Mbps").tag(10000000)
                        }
                        Group {
                            Text("720p - 8 Mbps").tag(80000000)
                            Text("720p - 6 Mbps").tag(60000000)
                            Text("720p - 4 Mbps").tag(40000000)
                        }
                            Text("480p - 3 Mbps").tag(30000000)
                            Text("480p - 1.5 Mbps").tag(20000000)
                            Text("480p - 740 Kbps").tag(10000000)
                    }
                    
                    Picker("Default remote playback bitrate", selection: $inNetworkStreamBitrate) {
                        Group {
                            Text("1080p - 60 Mbps").tag(60000000)
                            Text("1080p - 40 Mbps").tag(40000000)
                            Text("1080p - 20 Mbps").tag(20000000)
                            Text("1080p - 15 Mbps").tag(15000000)
                            Text("1080p - 10 Mbps").tag(10000000)
                        }
                        Group {
                            Text("720p - 8 Mbps").tag(80000000)
                            Text("720p - 6 Mbps").tag(60000000)
                            Text("720p - 4 Mbps").tag(40000000)
                        }
                            Text("480p - 3 Mbps").tag(30000000)
                            Text("480p - 1.5 Mbps").tag(20000000)
                            Text("480p - 740 Kbps").tag(10000000)
                    }
                }
                
                Section() {
                    Button {
                        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Server")
                        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

                        do {
                            try viewContext.execute(deleteRequest)
                        } catch _ as NSError {
                            // TODO: handle the error
                        }
                        
                        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SignedInUser")
                        let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)

                        do {
                            try viewContext.execute(deleteRequest2)
                        } catch _ as NSError {
                            // TODO: handle the error
                        }
                        
                        globalData.server = nil
                        globalData.user = nil
                        globalData.authToken = ""
                        globalData.authHeader = ""
                        jsi.did = true
                        exit(-1)
                    } label: {
                        Text("Log out")
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        close = false
                    } label: {
                        HStack() {
                            Text("Back").font(.callout)
                        }
                    }
                }
            }
        }.onAppear(perform: onAppear)
    }
}
