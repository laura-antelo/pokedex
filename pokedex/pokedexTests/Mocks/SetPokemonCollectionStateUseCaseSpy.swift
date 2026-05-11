//
//  SetPokemonCollectionStateUseCaseSpy.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 8/5/26.
//

@testable import pokedex

final class SetPokemonCollectionStateUseCaseSpy: SetPokemonCollectionStateUseCase {
    var executeCallCount: Int = 0
    var receivedSatate: PokemonCollectionState?
    var receivedId: Int?
    
    func execute(_ state: PokemonCollectionState, for id: Int) {
        executeCallCount += 1
        receivedSatate = state
        receivedId = id
    }
}
