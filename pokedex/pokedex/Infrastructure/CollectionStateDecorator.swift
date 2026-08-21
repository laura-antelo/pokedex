//
//  CollectionStateDecorator.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 4/5/26.
//

import Foundation
import Combine

final class CollectionStateDecorator: PokemonRepository {
    private let decorate: PokemonRepository
    private let stateRepository: PokemonCollectionStateRepository
    
    init(decorate: PokemonRepository, stateRepository: PokemonCollectionStateRepository) {
        self.decorate = decorate
        self.stateRepository = stateRepository
    }
    
    func getAllPokemonsPublisher() -> AnyPublisher<[Pokemon], any Error> {
        return Publishers.CombineLatest(
            decorate.getAllPokemonsPublisher(),
            stateRepository.allStatesPublisher().setFailureType(to: Error.self)
        ).map { pokemons, states in
            pokemons.map { pokemon in
                Pokemon(id: pokemon.id, name: pokemon.name, images: pokemon.images, types: pokemon.types, collectionState: states[pokemon.id] ?? .none)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getPokemonDetailByIdPublisher(_ id: Int) -> AnyPublisher<PokemonDetail, any Error> {
        return Publishers.CombineLatest(
            decorate.getPokemonDetailByIdPublisher(id),
            stateRepository.statePublisher(for: id).setFailureType(to: Error.self)
        ).map { detail, state in
            PokemonDetail(id: detail.id, name: detail.name, images: detail.images, description: detail.description, types: detail.types, collectionState: state)
        }
        .eraseToAnyPublisher()
    }
}
