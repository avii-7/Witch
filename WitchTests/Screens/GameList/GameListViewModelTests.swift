//
//  GameListViewModelTests.swift
//  WitchTests
//
//  Created by Glny Gl on 20/10/2024.
//

import XCTest
@testable import Witch

final class GameListViewModelTests: XCTestCase {
    
    var viewModel: GameListViewModel!
    var mockService: MockGameService!
    var mockPersistenceController: MockPersistenceController!
    
    var games: [Game]!
    var cachedGames: [Game]!
    
    override func setUp() {
        super.setUp()
        mockService = MockGameService()
        mockPersistenceController = MockPersistenceController()
        viewModel = GameListViewModel(service: mockService, persistenceController: mockPersistenceController)
        games = [Game(id: 1, name: "Game", cover: nil, url: nil, storyline: nil, summary: nil, rating: nil, similarGameIds: nil, videos: nil, slug: nil)]
        cachedGames = [Game(id: 1, name: "Cached game", cover: nil, url: nil, storyline: nil, summary: nil, rating: nil, similarGameIds: nil, videos: nil, slug: nil)]
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        mockPersistenceController = nil
        games = nil
        cachedGames = nil
        super.tearDown()
    }
    
    @MainActor
    func test_fetchGameList_success() async throws {
        
        mockService.gameListResult = games
        let result = try await viewModel.fetchGameList()
        
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(result?.first?.name, "Game")
    }
    
    @MainActor
    func test_fetchGameList_fail() async throws {
        
        mockService.gameListResult = nil
        let result = try await viewModel.fetchGameList()
        
        XCTAssertNil(result)
        XCTAssertTrue(viewModel.gameList.isEmpty)
    }
    
    @MainActor
    func test_getGameData_getFromCache() async throws {
        
        mockPersistenceController.cachedGames = cachedGames
        try await viewModel.getGameData()
        
        XCTAssertEqual(viewModel.gameList.count, 1)
        XCTAssertEqual(viewModel.gameList.first?.name, "Cached game")
        XCTAssertFalse(mockPersistenceController.saveCalled)
    }
    
    @MainActor
    func test_getGameData_saveToCache() async throws {
        
        mockService.gameListResult = games
        mockPersistenceController.cachedGames = nil
        try await viewModel.getGameData()
        
        XCTAssertEqual(viewModel.gameList.count, 1)
        XCTAssertEqual(viewModel.gameList.first?.name, "Game")
        XCTAssertTrue(mockPersistenceController.saveCalled)
    }
    
    @MainActor
    func test_getGameData_saveToCache_whenFetchGamesError() async throws {
        
        mockService.gameListResult = nil
        mockPersistenceController.cachedGames = nil
        try await viewModel.getGameData()
        
        XCTAssertEqual(viewModel.gameList.count, 0)
        XCTAssertTrue(mockPersistenceController.saveCalled)
    }
    
}
