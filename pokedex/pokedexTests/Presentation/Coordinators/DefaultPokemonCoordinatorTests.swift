//
//  DefaultPokemonCoordinatorTests.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
@testable import pokedex
import UIKit

struct DefaultPokemonCoordinatorTests {
    
    @MainActor
    @Test func When_StartIsCalled_Then_ShouldSetViewOnViewModel() async throws {
        let dependencies = PokemonDependenciesMock()
        let sut = DefaultPokemonCoordinator(dependencies: dependencies)

        let viewController = sut.start()
        
        #expect(viewController is PokemonViewController)
    }
    
    @MainActor
    @Test func When_GoToPokemonDetailIsCalled_Then_ShouldStartDetailCoordinator() async throws {
        let detailCoordinator = PokemonDetailCoordinatorSpy()
        let dependencies = PokemonDependenciesMock()
        dependencies.pokemonDetailCoordinator = detailCoordinator
        
        let sut = DefaultPokemonCoordinator(dependencies: dependencies)
        let root = sut.start()
        let navigationController = UINavigationController(rootViewController: root)
        
        sut.goToPokemonDetail(id: 25)
        
        #expect(detailCoordinator.startCallCount == 1)
    }
    
    @MainActor
    @Test func When_GoToAdvancedFiltersIsCalled_Then_ShouldPushFilterViewController() async throws {
        let dependencies = PokemonDependenciesMock()
        let sut = DefaultPokemonCoordinator(dependencies: dependencies)
        let root = sut.start()
        let navigationController = UINavigationController(rootViewController: root)
        
        sut.goToAdvancedFilters()
        
        #expect(navigationController.topViewController is FiltersViewController)
    }
}
