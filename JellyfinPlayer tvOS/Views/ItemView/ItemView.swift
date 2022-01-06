/* JellyfinPlayer/Swiftfin is subject to the terms of the Mozilla Public
 * License, v2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * Copyright 2021 Aiden Vigue & Jellyfin Contributors
 */

import Defaults
import Introspect
import JellyfinAPI
import SwiftUI

// Useless view necessary in tvOS because of iOS's implementation
struct ItemNavigationView: View {
    private let item: BaseItemDto

    init(item: BaseItemDto) {
        self.item = item
    }

    var body: some View {
        ItemView(item: item)
    }
}

struct ItemView: View {
    
    @Default(.tvOSEpisodeItemCinematicView) var tvOSEpisodeItemCinematicView
    @Default(.tvOSMovieItemCinematicView) var tvOSMovieItemCinematicView
    
    private var item: BaseItemDto

    init(item: BaseItemDto) {
        self.item = item
    }

    var body: some View {
        Group {
            if item.type == "Movie" {
                if tvOSMovieItemCinematicView {
                    CinematicMovieItemView(viewModel: MovieItemViewModel(item: item))
                } else {
                    MovieItemView(viewModel: MovieItemViewModel(item: item))
                }
            } else if item.type == "Series" {
                SeriesItemView(viewModel: .init(item: item))
            } else if item.type == "Season" {
                SeasonItemView(viewModel: .init(item: item))
            } else if item.type == "Episode" {
                if tvOSEpisodeItemCinematicView {
                    CinematicEpisodeItemView(viewModel: EpisodeItemViewModel(item: item))
                } else {
                    EpisodeItemView(viewModel: EpisodeItemViewModel(item: item))
                }
            } else {
                Text(L10n.notImplementedYetWithType(item.type ?? ""))
            }
        }
    }
}
