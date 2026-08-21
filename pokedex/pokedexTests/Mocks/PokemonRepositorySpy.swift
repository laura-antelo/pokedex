//
//  PokemonRepositorySpy.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 27/4/26.
//

import Testing
import Combine
@testable import pokedex

final class PokemonRepositorySpy: PokemonRepository {
    var getAllPokemonsCallCount = 0
    var getAllPokemonDetailCallCount = 0
    var receivedPokemonIds: [Int] = []
    
    private let pokemons: [Pokemon]
    private let pokemonDetailById: [PokemonDetail]
    
    init(pokemons: [Pokemon] = [], pokemonsDetail: [PokemonDetail] = []) {
        self.pokemons = pokemons
        self.pokemonDetailById = pokemonsDetail
    }
    
    func getAllPokemonsPublisher() -> AnyPublisher<[Pokemon], any Error> {
        getAllPokemonsCallCount += 1
        return CurrentValueSubject<[Pokemon], Error>(pokemons).eraseToAnyPublisher()
    }
    
    func getPokemonDetailByIdPublisher(_ id: Int) -> AnyPublisher<PokemonDetail, any Error> {
        getAllPokemonDetailCallCount += 1
        receivedPokemonIds.append(id)
        
        guard let detail = pokemonDetailById.first(where: { $0.id == id }) else {
            return Fail(error: PokemonRepositorySpyError.notFound).eraseToAnyPublisher()
        }
        
        return CurrentValueSubject<PokemonDetail, Error>(detail).eraseToAnyPublisher( )
    }
}

private extension PokemonRepositorySpy {
    enum PokemonRepositorySpyError: Error {
        case notFound
    }
}
