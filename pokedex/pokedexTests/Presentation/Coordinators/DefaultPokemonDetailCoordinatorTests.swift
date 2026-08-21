//
//  DefaultPokemonDetailCoordinatorTests.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
@testable import pokedex
import UIKit

struct DefaultPokemonDetailCoordinatorTests {
    
    @MainActor
    @Test func When_StartIsCalled_Then_ShouldReturnPokemonDetailViewController() async throws {
        let dependencies = PokemonDependenciesMock()
        let sut = DefaultPokemonDetailCoordinator(dependencies: dependencies)
        
        let result = sut.start(pokemonId: 25)
        
        #expect(result is PokemonDetailViewController)
    }
}
