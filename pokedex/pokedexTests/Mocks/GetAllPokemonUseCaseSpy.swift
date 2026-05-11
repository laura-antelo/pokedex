//
//  GetAllPokemonUseCaseSpy.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
import Combine
@testable import pokedex

final class GetAllPokemonUseCaseSpy: GetAllPokemonUseCase {
    var executeCallCount = 0
    private let pokemons: [Pokemon]
    
    init(pokemons: [Pokemon] = []) {
        self.pokemons = pokemons
    }
    
    func execute() -> AnyPublisher<[pokedex.Pokemon], any Error> {
        executeCallCount += 1
        return CurrentValueSubject<[Pokemon], Error>(pokemons)
            .eraseToAnyPublisher()
    }
}
