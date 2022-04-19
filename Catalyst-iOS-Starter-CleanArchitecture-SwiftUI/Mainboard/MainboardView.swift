//
//  MainboardView.swift
//  Catalyst-iOS-Starter-CleanArchitecture-SwiftUI
//
//  Created by Gabriel Vermesan on 13.04.2022.
//

import SwiftUI
import CustomViews
import UseCase

struct MainboardView: View {
    
    @StateObject private var viewModel: MainboardViewModel = MainboardViewModel()

    var body: some View {
        List {
            GeometryReader { geometry in
                ZStack {
                    if geometry.frame(in: .global).minY <= 0 {
                        CatalystImage(url: viewModel.profileUrl)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(y: geometry.frame(in: .global).minY / 9)
                        .clipped()
                    } else {
                        CatalystImage(url: viewModel.profileUrl)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                            .clipped()
                            .offset(y: -geometry.frame(in: .global).minY)
                    }

                    
                    HStack(spacing: 10) {
                        VStack(alignment: .leading) {
                            Text(viewModel.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color.white)
                            Text(viewModel.userName)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color.white)
                        }
                        CatalystImage(url: viewModel.avatarUrl)
                            .frame(width: 50, height: 50, alignment: .center)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 20)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .frame(height: 300)
            
            ForEach(viewModel.tweets, id: \.id) { tweet in
                Section(header:
                            HStack {
                    CatalystImage(url: URL(string: tweet.sender.avatar)!)
                                    .frame(width: 50, height: 50, alignment: .top)
                                    .clipShape(Circle())
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(tweet.sender.name)
                                        .frame(alignment: .leading)
                                        .foregroundColor(.blue)
                                    Text(tweet.content ?? "No Content")
                                        .frame(alignment: .leading)
                                    LazyVGrid(columns: Array(repeating: .init(.adaptive(minimum: 80)), count: 3), spacing: 10) {
                                        ForEach(tweet.images, id: \.id) { image in
                                            CatalystImage(url: URL(string: image.urlString)!)
                                        }
                                    }
                                }
                            }
                    
                ) {
                    ForEach(tweet.comments, id: \.id) { comment in
                        HStack(alignment: .center, spacing: 5) {
                            Text(comment.sender.name ?? "No name")
                                .foregroundColor(.blue)
                            Text(comment.comment)
                        }
                    }
                }
            }
        }
    }
}

private extension MainboardView {

}

struct MainboardView_Previews: PreviewProvider {
    static var previews: some View {
        MainboardView()
    }
}
