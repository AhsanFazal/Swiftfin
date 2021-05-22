//
//  NextUpView.swift
//  JellyfinPlayer
//
//  Created by Aiden Vigue on 4/30/21.
//

import SwiftUI
import SwiftyRequest
import SwiftyJSON
import SDWebImageSwiftUI

struct ContinueWatchingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var globalData: GlobalData
    
    @State var resumeItems: [ResumeItem] = []
    @State private var viewDidLoad: Int = 0;
    @State private var isLoading: Bool = true;
    
    func onAppear() {
        if(globalData.server?.baseURI == "") {
            return
        }
        if(viewDidLoad == 1) {
            return
        }
        _viewDidLoad.wrappedValue = 1;
        let request = RestRequest(method: .get, url: (globalData.server?.baseURI ?? "") + "/Users/\(globalData.user?.user_id ?? "")/Items/Resume?Limit=12&Recursive=true&Fields=PrimaryImageAspectRatio%2CBasicSyncInfo&ImageTypeLimit=1&EnableImageTypes=Primary%2CBackdrop%2CThumb&MediaTypes=Video")
        request.headerParameters["X-Emby-Authorization"] = globalData.authHeader
        request.contentType = "application/json"
        request.acceptType = "application/json"
        
        request.responseData() { (result: Result<RestResponse<Data>, RestError>) in
            switch result {
            case .success(let response):
                let body = response.body
                do {
                    let json = try JSON(data: body)
                    for (_,item):(String, JSON) in json["Items"] {
                        // Do something you want
                        let itemObj = ResumeItem()
                        if(item["PrimaryImageAspectRatio"].double! < 1.0) {
                            //portrait; use backdrop instead
                            itemObj.Image = item["BackdropImageTags"][0].string ?? ""
                            itemObj.ImageType = "Backdrop"
                            itemObj.BlurHash = item["ImageBlurHashes"]["Backdrop"][itemObj.Image].string ?? ""
                        } else {
                            itemObj.Image = item["ImageTags"]["Primary"].string ?? ""
                            itemObj.ImageType = "Primary"
                            itemObj.BlurHash = item["ImageBlurHashes"]["Primary"][itemObj.Image].string ?? ""
                        }
                        itemObj.Name = item["Name"].string ?? ""
                        itemObj.Type = item["Type"].string ?? ""
                        itemObj.IndexNumber = item["IndexNumber"].int ?? nil
                        itemObj.Id = item["Id"].string ?? ""
                        itemObj.ParentIndexNumber = item["ParentIndexNumber"].int ?? nil
                        itemObj.SeasonId = item["SeasonId"].string ?? nil
                        itemObj.SeriesId = item["SeriesId"].string ?? nil
                        itemObj.SeriesName = item["SeriesName"].string ?? nil
                        itemObj.ItemProgress = item["UserData"]["PlayedPercentage"].double ?? 0.00
                        _resumeItems.wrappedValue.append(itemObj)
                    }
                    _isLoading.wrappedValue = false;
                } catch {
                    
                }
                break
            case .failure(let error):
                _viewDidLoad.wrappedValue = 0;
                debugPrint(error)
                break
            }
        }
    }
    
    var body: some View {
        if(resumeItems.count != 0) {
            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        if(isLoading == false) {
                            Spacer().frame(width:16)
                            ForEach(resumeItems, id: \.Id) { item in
                                NavigationLink(destination: ItemView(item: item)) {
                                    VStack(alignment: .leading) {
                                        Spacer().frame(height: 10)
                                        if(item.Type == "Episode") {
                                            WebImage(url: URL(string: "\(globalData.server?.baseURI ?? "")/Items/\(item.Id)/Images/\(item.ImageType)?maxWidth=500&quality=96&tag=\(item.Image)")!)
                                                .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                                                .placeholder {
                                                    Image(uiImage: UIImage(blurHash: (item.BlurHash == "" ?  "W$H.4}D%bdo#a#xbtpxVW?W?jXWsXVt7Rjf5axWqxbWXnhada{s-" : item.BlurHash), size: CGSize(width: 32, height: 32))!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .cornerRadius(10)
                                                }
                                                .frame(width: 320, height: 180)
                                                .cornerRadius(10)
                                                .overlay(
                                                    ZStack {
                                                        Text("S\(String(item.ParentIndexNumber ?? 0)):E\(String(item.IndexNumber ?? 0)) - \(item.Name)")
                                                            .font(.caption)
                                                            .padding(6)
                                                            .foregroundColor(.white)
                                                    }.background(Color.black)
                                                    .opacity(0.8)
                                                    .cornerRadius(10.0)
                                                    .padding(6), alignment: .topTrailing
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10, style: .circular)
                                                        .fill(Color(red: 172/255, green: 92/255, blue: 195/255).opacity(0.4))
                                                        .frame(width: CGFloat((item.ItemProgress/100)*320), height: 180)
                                                    .padding(0), alignment: .bottomLeading
                                                )
                                                .shadow(radius: 5)
                                        } else {
                                            WebImage(url: URL(string: "\(globalData.server?.baseURI ?? "")/Items/\(item.Id)/Images/\(item.ImageType)?maxWidth=500&quality=96&tag=\(item.Image)")!)
                                                .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                                                .placeholder {
                                                    Image(uiImage: UIImage(blurHash: (item.BlurHash == "" ?  "W$H.4}D%bdo#a#xbtpxVW?W?jXWsXVt7Rjf5axWqxbWXnhada{s-" : item.BlurHash), size: CGSize(width: 32, height: 32))!)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .cornerRadius(10)
                                                }
                                                .frame(width: 320, height: 180)
                                                .cornerRadius(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10, style: .circular)
                                                        .fill(Color(red: 172/255, green: 92/255, blue: 195/255).opacity(0.4))
                                                        .frame(width: CGFloat((item.ItemProgress/100)*320), height: 180)
                                                    .padding(0), alignment: .bottomLeading
                                                )
                                                .shadow(radius: 5)
                                        }
                                        Text("\(item.Type == "Episode" ? item.SeriesName ?? "" : item.Name)")
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        Spacer().frame(height: 5)
                                    }.padding(.trailing, 5)
                                }
                            }
                            Spacer().frame(width:14)
                        }
                    }
                }
                .frame(height: 200)
                .padding(.bottom, 10)
            }
        } else {
            VStack() {
                EmptyView()
            }.onAppear(perform: onAppear)
        }
    }
}

struct ContinueWatchingView_Previews: PreviewProvider {
    static var previews: some View {
        ContinueWatchingView()
    }
}
