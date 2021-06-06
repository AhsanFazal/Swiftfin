/* JellyfinPlayer/Swiftfin is subject to the terms of the Mozilla Public
 * License, v2.0. If a copy of the MPL was not distributed with this
 * file, you can obtain one at https://mozilla.org/MPL/2.0/.
 *
 * Copyright 2021 Aiden Vigue & Jellyfin Contributors
 */

import Foundation

struct UserSettings: Decodable {
    var LocalMaxBitrate: Int;
    var RemoteMaxBitrate: Int;
    var AutoSelectSubtitles: Bool;
    var AutoSelectSubtitlesLangcode: String;
    var SubtitlePositionOffset: Int;
    var SubtitleFontName: String;
}

struct Bitrates: Codable, Hashable {
    public var name: String
    public var value: Int
}
