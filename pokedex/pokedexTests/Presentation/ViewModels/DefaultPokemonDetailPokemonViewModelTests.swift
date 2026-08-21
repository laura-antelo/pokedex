//
//  DefaultPokemonDetailPokemonViewModelTests.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
import Combine
@testable import pokedex

struct DefaultPokemonDetailPokemonViewModelTests {
    
    @MainActor
    @Test func When_DetailViewModelIsStarted_Then_PokemonDetailShouldBePublished() async throws {
        let dependencies = PokemonDependenciesMock()
        let sut = DefaultDetailPokemonViewModel(dependencies: dependencies, pokemonId: 25)
        
        sut.viewDidLoad()
        let publisher = sut.pokemonDetailPublisher
        let value = try await publisher.values.first(where: { _ in true })
        let pokemonDetail = try #require(value)
        
        #expect(pokemonDetail.id == 25)
    }
    
    @MainActor
    @Test func When_PokemonDetailPublisherIsRequested_Then_GetPokemonDetailUseCaseShouldBeExecuted() async throws {
        let detail = TestPokemons.pikachuDetail
        let useCase = GetPokemonDetailUseCaseSpy(pokemonDetail: detail)
        let dependencies = PokemonDependenciesMock()
        dependencies.getPokemonDetailUseCase = useCase
        let sut = DefaultDetailPokemonViewModel(dependencies: dependencies, pokemonId: 25)
        
        let publisher = sut.pokemonDetailPublisher
        let value = try await publisher.values.first(where: { _ in true })
        let pokemonDetail = try #require(value)
        
        #expect(useCase.executeCallCount == 1)
    }
}
