//
//  DefaultGetAllPokemonUseCaseTests.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//


import Testing
import Combine
@testable import pokedex

struct TestPokemonRepositoryTests {

    @MainActor
    @Test func When_GetAllPokemonsIsCalled_Then_ShouldReturnPokemons() async throws {
        let sut = TestPokemonRepository()
        
        let publisher = sut.getAllPokemonsPublisher()
        let value = try await publisher.values.first(where: { _ in true })
        let pokemons = try  #require(value)
        
        #expect(pokemons.count > 0)
    }

    @MainActor
    @Test func When_GetPokemonByIdIsCalled_Then_ShouldReturnPokemon() async throws {
        let sut = TestPokemonRepository()
        
        let publisher = sut.getPokemonDetailByIdPublisher(25)
        let value = try await publisher.values.first(where: { _ in true })
        let pokemon = try #require(value)
        
        #expect(pokemon.id == 25)
    }
}
