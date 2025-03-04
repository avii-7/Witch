//
//  SimilarGamesView.swift
//  Witch
//
//  Created by Glny Gl on 19/10/2024.
//

import SwiftUI
import NukeUI

struct SimilarGamesView: View {
    
    var games: [Game]
    @Environment(\.gameService) private var service: GameServiceProtocol
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(games, id: \.id) { game in
                    NavigationLink {
                        GameDetailView(viewModel: GameDetailViewModel(service: service, game: game, urlOpener: UIApplication.shared))
                            .removeNavigationBackButtonTitle()
                    } label: {
                        if let urlString = game.cover?.url {
                            LazyImage(url: GameScreens.list.url(string: urlString)) { state in
                                if let image = state.image {
                                    image.resizable()
                                        .cornerRadius(8)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100)
                                } else {
                                    Rectangle()
                                        .fill(.gray.opacity(0.4))
                                        .frame(width: 100)
                                }
                            }
                        }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
