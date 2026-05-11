//
//  DefaultMainCoordinatorTests.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
@testable import pokedex
import UIKit

struct DefaultMainCoordinatorTests {
    
    @MainActor
    @Test func When_MainCoordinatorIsStarted_Then_ShouldStartPokemonCoordinator() async throws {
        let coordinator = PokemonCoordinatorSpy()
        let dependencies = PokemonDependenciesMock()
        let window = UIWindow()
        dependencies.pokemonCoordinator = coordinator
        let sut = DefaultMainCoordinator(window: window, dependencies: dependencies)
        
        let _ = sut.start()
        
        #expect(coordinator.startCallCount == 1)
    }
}
