//
//  DefaultGetAllPokemonUseCaseTests.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//


import Testing
import Combine
@testable import pokedex

struct DefaultGetPokemonDetailUseCaseTests {

    @MainActor
    @Test func When_ExecuteIsCalled_Then_ShouldCallRepository() async throws {
        let detail = TestPokemons.pikachuDetail
        let repository = PokemonRepositorySpy(pokemonsDetail: [detail])
        let sut = DefaultGetPokemonDetailUseCase(repository: repository)
        
        let publisher = sut.execute(id: 25)
        _ = try await publisher.values.first(where: { _ in true })
        
        #expect(repository.getAllPokemonDetailCallCount == 1)
    }
    
    @MainActor
    @Test func When_ExecuteIsCalled_Then_ShouldReturnPokemonDetail() async throws {
        let detail = TestPokemons.pikachuDetail
        let repository = PokemonRepositorySpy(pokemonsDetail: [detail])
        let sut = DefaultGetPokemonDetailUseCase(repository: repository)
        
        let publisher = sut.execute(id: 25)
        let value = try await publisher.values.first(where: { _ in true })
        
        #expect(value?.id == 25)
    }
}
