//
//  GameDetailViewModelTests.swift
//  WitchTests
//
//  Created by Glny Gl on 20/10/2024.
//

import XCTest
@testable import Witch

final class GameDetailViewModelTests: XCTestCase {
    
    var viewModel: GameDetailViewModel!
    var mockService: MockGameService!
    var mockURLOpener: MockURLOpener!
    
    var game: Game!
    var similarGames: [Game]!
    
    override func setUp() {
        super.setUp()
        mockService = MockGameService()
        mockURLOpener = MockURLOpener()
        game = Game(id: 1, name: "Game", cover: nil, url: "www.google.com", storyline: nil, summary: nil, rating: 94.0, similarGameIds: nil, videos: nil, slug: nil)
        similarGames = [Game(id: 2, name: "Similar", cover: nil, url: nil, storyline: nil, summary: nil, rating: nil, similarGameIds: nil, videos: nil, slug: nil)]
        viewModel = GameDetailViewModel(service: mockService, game: game, urlOpener: mockURLOpener)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        game = nil
        similarGames = nil
        super.tearDown()
    }
    
    @MainActor
    func test_fetchSimilarGameList_success() async throws {
        
        mockService.similarGameListResult = similarGames
        try await viewModel.fetchSimilarGameList(ids: [2])
        
        XCTAssertEqual(viewModel.gameList.count, 1)
        XCTAssertEqual(viewModel.gameList.first?.name, "Similar")
    }
    
    @MainActor
    func test_fetchSimilarGameList_fail() async throws {
        
        mockService.similarGameListResult = nil
        try await viewModel.fetchSimilarGameList(ids: [2])
        
        XCTAssertTrue(viewModel.gameList.isEmpty)
    }
    
    @MainActor
    func test_openUrl_true() {
        
        mockURLOpener.canOpenURLResult = true
        viewModel.openURL(urlString: game.url)
        
        XCTAssertTrue(mockURLOpener.openURLCalled)
    }
    
    @MainActor
    func test_openUrl_false() {
        
        mockURLOpener.canOpenURLResult = false
        viewModel.openURL(urlString: "//")
        
        XCTAssertFalse(mockURLOpener.openURLCalled)
    }
    
    @MainActor
    func test_openUrl_nil() {
        
        viewModel.openURL(urlString: similarGames.first?.url)
        XCTAssertFalse(mockURLOpener.openURLCalled)
    }
    
    func test_convertRating_true() {

         let rating = viewModel.convertStarRating()
         XCTAssertEqual(rating, 4.7)
     }
     
     func test_convertRating_nil() {
         
         let game = Game(id: 1, name: "Game", cover: nil, url: nil, storyline: nil, summary: nil, rating: nil, similarGameIds: nil, videos: nil, slug: nil)
         viewModel = GameDetailViewModel(service: mockService, game: game, urlOpener: mockURLOpener)
         let rating = viewModel.convertStarRating()
         
         XCTAssertEqual(rating, 0.0)
     }
    
}
