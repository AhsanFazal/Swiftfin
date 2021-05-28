//
//  LibraryListView.swift
//  JellyfinPlayer
//
//  Created by PangMo5 on 2021/05/27.
//

import Foundation
import SwiftUI

struct LibraryListView: View {
    @Environment(\.managedObjectContext)
    private var viewContext
    @EnvironmentObject
    var globalData: GlobalData
    @ObservedObject
    var viewModel: LibraryListViewModel

    var body: some View {
        List(viewModel.libraryIDs, id: \.self) { id in
            switch id {
            case "favorites":
                NavigationLink(destination: LibraryView(viewModel: .init(filter: Filter(filterTypes: [.isFavorite])),
                                                        title: viewModel.libraryNames[id] ?? "")) {
                    Text(viewModel.libraryNames[id] ?? "").foregroundColor(Color.primary)
                }
            case "genres":
                Text(viewModel.libraryNames[id] ?? "").foregroundColor(Color.primary)
            default:
                NavigationLink(destination: LibraryView(viewModel: .init(filter: Filter(parentID: id)),
                                                        title: viewModel.libraryNames[id] ?? "")) {
                    Text(viewModel.libraryNames[id] ?? "").foregroundColor(Color.primary)
                }
            }
        }
        .navigationTitle("All Media")
        .navigationBarItems(trailing:
            NavigationLink(destination: LibrarySearchView(viewModel: .init(filter: .init()))) {
                Image(systemName: "magnifyingglass")
            })
    }
}
