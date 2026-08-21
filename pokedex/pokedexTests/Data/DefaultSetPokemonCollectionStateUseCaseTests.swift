//
//  DefaultSetPokemonCollectionStateUseCaseTests.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 8/5/26.
//

import Combine
import Testing
@testable import pokedex

struct DefaultSetPokemonCollectionStateUseCaseTests {
    
    @MainActor
    @Test func When_ExecuteIsCalled_Then_ShouldCallRepositorySaveOnce() async throws {
        let repository = PokemonCollectionStateRepositorySpy()
        let sut = DefaultSetPokemonCollectionStateUseCase(repository: repository)
        
        sut.execute(.wanted, for: 25)
        
        #expect(repository.saveCallCount == 1)
    }
    
    @MainActor
    @Test func When_ExecuteIsCalled_Then_ShouldPassWantedStateToRepository() async throws {
        let repository = PokemonCollectionStateRepositorySpy()
        let sut = DefaultSetPokemonCollectionStateUseCase(repository: repository)
        
        sut.execute(.wanted, for: 25)
        
        #expect(repository.receivedState == .wanted)
    }
    
    @MainActor
    @Test func When_ExecuteIsCalled_Then_ShouldPassPokemonIdToRepository() async throws {
        let repository = PokemonCollectionStateRepositorySpy()
        let sut = DefaultSetPokemonCollectionStateUseCase(repository: repository)
        
        sut.execute(.wanted, for: 25)
        
        #expect(repository.receivedId == 25)
    }
}
