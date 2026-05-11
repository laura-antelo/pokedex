//
//  CollectionStateDecoratorTest.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 8/5/26.
//
/*
import Testing
@testable import pokedex
import Combine

struct CollectionStateDecoratorTests {
    
    @MainActor
    @Test func When_NoStateIsSaved_Then_ListPokemonShouldKeepNoneState() async throws {
        let pokemons = [TestPokemons.pikachu]
        let repository = PokemonRepositorySpy(pokemons: pokemons)
        let stateRepository = DefaultPokemonCollectionStateRepository()
        let sut = CollectionStateDecorator(decorate: repository, stateRepository: stateRepository)
        
        let value = try await sut.getAllPokemonsPublisher().values.first(where: { _ in true })
        let pokemon = try #require(value?.first)
        
        #expect(pokemon.collectionState == PokemonCollectionState.none)
    }
    
    @MainActor
    @Test func When_WantedStateIsSaved_Then_ListPokemonShouldExposeWantedState() async throws {
        let pokemons = [TestPokemons.pikachu]
        let repository = PokemonRepositorySpy(pokemons: pokemons)
        let stateRepository = DefaultPokemonCollectionStateRepository()
        stateRepository.save(.wanted, for: 25)
        let sut = CollectionStateDecorator(decorate: repository, stateRepository: stateRepository)
        
        let value = try await sut.getAllPokemonsPublisher().values.first(where: { _ in true })
        let pokemon = try #require(value?.first)
        
        #expect(pokemon.collectionState == PokemonCollectionState.wanted)
    }
    
    @MainActor
    @Test func When_OwnedStateIsSaved_Then_ListPokemonShouldExposeOwnedState() async throws {
        let pokemons = [TestPokemons.pikachu]
        let repository = PokemonRepositorySpy(pokemons: pokemons)
        let stateRepository = DefaultPokemonCollectionStateRepository()
        stateRepository.save(.owned, for: 25)
        let sut = CollectionStateDecorator(decorate: repository, stateRepository: stateRepository)
        
        let value = try await sut.getAllPokemonsPublisher().values.first(where: { _ in true })
        let pokemon = try #require(value?.first)
        
        #expect(pokemon.collectionState == PokemonCollectionState.owned)
    }
    
    @MainActor
    @Test func When_StateChangesAfterSubscription_Then_ListShouldEmitUpdateState() async throws {
        let pokemons = [TestPokemons.pikachu]
        let repository = PokemonRepositorySpy(pokemons: pokemons)
        let stateRepository = DefaultPokemonCollectionStateRepository()
        let sut = CollectionStateDecorator(decorate: repository, stateRepository: stateRepository)
        
        let publisher = sut.getAllPokemonsPublisher()
        var iterator = publisher.values.makeAsyncIterator()
        
        _ = try await #require(iterator.next())
        stateRepository.save(.owned, for: 25)
        let second = try await #require(iterator.next())
        let pokemon = try #require(second.first)
        
        #expect(pokemon.collectionState == PokemonCollectionState.owned)
    }
}
*/
