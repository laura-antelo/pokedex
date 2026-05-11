//
//  CacheDecoratorTests.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 8/5/26.
//

import Combine
import Testing
@testable import pokedex

struct CacheDecoratorTests {
    
    @MainActor
    @Test func When_GetAllPokemonsIsCalledFirstTime_Then_ShouldAskDecoratedRepositoryOnce() async throws {
        let pokemons = TestPokemons.samplePokemons
        let repository = PokemonRepositorySpy(pokemons: pokemons)
        let sut = CacheDecorator(decorate: repository)
        
        _ = try await sut.getAllPokemonsPublisher().values.first(where: { _ in true })
        
        #expect(repository.getAllPokemonsCallCount == 1)
        
    }
    
    @MainActor
    @Test func When_GetAllPokemonsIsCalledTwice_Then_ResultShouldComeFromCache() async throws {
        let pokemons = TestPokemons.samplePokemons
        let repository = PokemonRepositorySpy(pokemons: pokemons)
        let sut = CacheDecorator(decorate: repository)
        
        _ = try await sut.getAllPokemonsPublisher().values.first(where: { _ in true })
        _ = try await sut.getAllPokemonsPublisher().values.first(where: { _ in true })
        
        #expect(repository.getAllPokemonsCallCount == 1)
    }
    
    @MainActor
    @Test func When_GetPokemonDetailIsCalledFirstTime_Then_ShouldAskDecorateRepositoryOnce() async throws {
        let detail = TestPokemons.pikachuDetail
        let repository = PokemonRepositorySpy(pokemonsDetail: [detail])
        let sut = CacheDecorator(decorate: repository)
        
        _ = try await sut.getPokemonDetailByIdPublisher(25).values.first(where: { _ in true })
        
        #expect(repository.getAllPokemonDetailCallCount == 1)
    }
    
    @MainActor
    @Test func When_GetAllPokemonDetailIsCalledTwice_Then_ResultShouldComeFromCache() async throws {
        let detail = TestPokemons.pikachuDetail
        let repository = PokemonRepositorySpy(pokemonsDetail: [detail])
        let sut = CacheDecorator(decorate: repository)
        
        _ = try await sut.getPokemonDetailByIdPublisher(25).values.first(where: { _ in true })
        _ = try await sut.getPokemonDetailByIdPublisher(25).values.first(where: { _ in true })
        
        #expect(repository.getAllPokemonDetailCallCount == 1)
    }
    
    @MainActor
    @Test func When_GetPokemonDetailIsCalledWithDiferentIds_Then_ShouldCacheEachIdSeperatly() async throws {
        let details = [TestPokemons.pikachuDetail, TestPokemons.charmanderDetail]
        let repository = PokemonRepositorySpy(pokemonsDetail: details)
        let sut = CacheDecorator(decorate: repository)
        
        _ = try await sut.getPokemonDetailByIdPublisher(25).values.first(where: { _ in true })
        _ = try await sut.getPokemonDetailByIdPublisher(4).values.first(where: { _ in true })
        
        #expect(repository.getAllPokemonDetailCallCount == 2)
    }
}
