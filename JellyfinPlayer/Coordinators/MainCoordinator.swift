//
/*
 * SwiftFin is subject to the terms of the Mozilla Public
 * License, v2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * Copyright 2021 Aiden Vigue & Jellyfin Contributors
 */

import Foundation
import Nuke
import Stinsen
import SwiftUI
#if !os(tvOS)
    import WidgetKit
#endif

#if os(iOS)
    final class MainCoordinator: NavigationCoordinatable {
        var stack: NavigationStack<MainCoordinator>

        @Root var mainTab = makeMainTab
        @Root var serverList = makeServerList

        init() {
            if SessionManager.main.currentLogin != nil {
                self.stack = NavigationStack(initial: \MainCoordinator.mainTab)
            } else {
                self.stack = NavigationStack(initial: \MainCoordinator.serverList)
            }
            
            ImageCache.shared.costLimit = 125 * 1024 * 1024 // 125MB memory
            DataLoader.sharedUrlCache.diskCapacity = 1000 * 1024 * 1024 // 1000MB disk

            #if !os(tvOS)
                WidgetCenter.shared.reloadAllTimelines()
                UIScrollView.appearance().keyboardDismissMode = .onDrag
            #endif

            let nc = SwiftfinNotificationCenter.main
            nc.addObserver(self, selector: #selector(didLogIn), name: SwiftfinNotificationCenter.Keys.didSignIn, object: nil)
            nc.addObserver(self, selector: #selector(didLogOut), name: SwiftfinNotificationCenter.Keys.didSignOut, object: nil)
            nc.addObserver(self, selector: #selector(processDeepLink), name: SwiftfinNotificationCenter.Keys.processDeepLink, object: nil)
        }

        @objc func didLogIn() {
            LogManager.shared.log.info("Received `didSignIn` from NSNotificationCenter.")
            root(\.mainTab)
        }

        @objc func didLogOut() {
            LogManager.shared.log.info("Received `didSignOut` from NSNotificationCenter.")
            root(\.serverList)
        }

        @objc func processDeepLink(_ notification: Notification) {
            guard let deepLink = notification.object as? DeepLink else { return }
            if let coordinator = hasRoot(\.mainTab) {
                switch deepLink {
                case let .item(item):
                    coordinator.focusFirst(\.home)
                        .child
                        .popToRoot()
                        .route(to: \.item, item)
                }
            }
        }

        func makeMainTab() -> MainTabCoordinator {
            MainTabCoordinator()
        }

        func makeServerList() -> NavigationViewCoordinator<ServerListCoordinator> {
            NavigationViewCoordinator(ServerListCoordinator())
        }
    }

#elseif os(tvOS)
    // temp for fixing build error
    final class MainCoordinator: NavigationCoordinatable {
        var stack = NavigationStack<MainCoordinator>(initial: \MainCoordinator.mainTab)

        @Root var mainTab = makeEmpty

        @ViewBuilder func makeEmpty() -> some View {
            EmptyView()
        }
    }
#endif
