//
//  DefaultGetAllPokemonUseCaseTests.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
@testable import pokedex
import Combine

struct DefaultGetAllPokemonUseCaseTests {
    
    @MainActor
    @Test func When_ExecuteIsCalled_Then_ShouldCallRepository() async throws {
        let repository = PokemonRepositorySpy(pokemons: [])
        let sut = DefaultGetAllPokemonUseCase(repository: repository)
        
        let publisher = sut.execute()
        _ = try await publisher.values.first(where: { _ in true })
        
        #expect(repository.getAllPokemonsCallCount == 1)
    }
    
    @MainActor
    @Test func When_ExecuteIsCalled_Then_ShouldReturnPokemons() async throws {
        let pokemons = TestPokemons.samplePokemons
        let repository = PokemonRepositorySpy(pokemons: pokemons)
        let sut = DefaultGetAllPokemonUseCase(repository: repository)
        
        let publisher = sut.execute()
        let value = try await publisher.values.first(where: { _ in true })
        
        #expect(value?.count == 2)
    }
    
}
