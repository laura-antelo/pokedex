//
//  GetPokemonDetailUseCaseSpy.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
import Combine
@testable import pokedex

final class GetPokemonDetailUseCaseSpy: GetPokemonDetailUseCase {
    
    var executeCallCount = 0
    var receviedPokemonId: Int?
    private let pokemonDetail: PokemonDetail?
    
    init(pokemonDetail: PokemonDetail? = nil) {
        self.pokemonDetail = pokemonDetail
    }
    
    func execute(id: Int) -> AnyPublisher<pokedex.PokemonDetail, any Error> {
        executeCallCount += 1
        receviedPokemonId = id
        
        return CurrentValueSubject<PokemonDetail?, Error>(pokemonDetail).tryMap { detail in
            guard let detail else {
                throw GetPokemonDetailUseCaseSpyError.notFound
            }
            return detail
        }.eraseToAnyPublisher()
    }
}

private extension GetPokemonDetailUseCaseSpy {
    enum GetPokemonDetailUseCaseSpyError: Error {
        case notFound
    }
}
