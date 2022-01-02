//
 /* 
  * SwiftFin is subject to the terms of the Mozilla Public
  * License, v2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at https://mozilla.org/MPL/2.0/.
  *
  * Copyright 2021 Aiden Vigue & Jellyfin Contributors
  */

import JellyfinAPI
import SwiftUI

struct tvOSOverlayContentView: View {
    
    @ObservedObject var viewModel: VideoPlayerViewModel
    @FocusState private var focused: Bool
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                HStack {
                    Button {
                        print("here")
                    } label: {
                        Text("About")
                    }
                    
                    Button {
                        print("here")
                    } label: {
                        Text("Chapters")
                    }
                    
                    Button {
                        print("here")
                    } label: {
                        Text("Subtitles")
                    }
                    
                    Button {
                        print("here")
                    } label: {
                        Text("Audio")
                    }
                }
                .frame(height: 50)
                
                Spacer()
            }
            .padding(.bottom)
            
            Color.gray
                .frame(height: 300)
        }
    }
}

struct tvOSOverlayContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            
            tvOSOverlayContentView(viewModel: VideoPlayerViewModel(item: BaseItemDto(runTimeTicks: 720 * 10_000_000),
                                                                   title: "Glorious Purpose",
                                                                   subtitle: "Loki - S1E1",
                                                                   streamURL: URL(string: "www.apple.com")!,
                                                                   hlsURL: URL(string: "www.apple.com")!,
                                                                   response: PlaybackInfoResponse(),
                                                                   audioStreams: [MediaStream(displayTitle: "English", index: -1)],
                                                                   subtitleStreams: [MediaStream(displayTitle: "None", index: -1)],
                                                                   defaultAudioStreamIndex: -1,
                                                                   defaultSubtitleStreamIndex: -1,
                                                                   playerState: .error,
                                                                   shouldShowGoogleCast: false,
                                                                   shouldShowAirplay: false,
                                                                   subtitlesEnabled: true,
                                                                   sliderPercentage: 0.432,
                                                                   selectedAudioStreamIndex: -1,
                                                                   selectedSubtitleStreamIndex: -1,
                                                                   showAdjacentItems: true,
                                                                   shouldShowAutoPlayNextItem: true,
                                                                   autoPlayNextItem: true))
        }
    }
}
