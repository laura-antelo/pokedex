//
//  CacheDecorator.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 30/4/26.
//

import Combine
import Foundation

final class CacheDecorator: PokemonRepository {
    
    private let decorate: PokemonRepository
    private let cacheLifetime: TimeInterval
    
    private struct CacheEntry<Value> {
        let value: Value
        var timestamp: Date
    }
    
    private var pokemonsCache: CacheEntry<[Pokemon]>?
    private var pokemonDetailCache: [Int: CacheEntry<PokemonDetail>] = [:]
    
    init(decorate: PokemonRepository, cacheLifetime: TimeInterval = 300) {
        self.decorate = decorate
        self.cacheLifetime = cacheLifetime
    }
    
    func getAllPokemonsPublisher() -> AnyPublisher<[Pokemon], any Error> {
        if let entry = pokemonsCache,
           Date().timeIntervalSince(entry.timestamp) < cacheLifetime {
            pokemonsCache?.timestamp = Date()
            return Just(entry.value)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return decorate.getAllPokemonsPublisher()
            .handleEvents(receiveOutput: { [weak self] pokemons in
                self?.pokemonsCache = CacheEntry(value: pokemons, timestamp: Date())
            })
            .eraseToAnyPublisher()
    }
    
    func getPokemonDetailByIdPublisher(_ id: Int) -> AnyPublisher<PokemonDetail, any Error> {
        if let entry = pokemonDetailCache[id],
           Date().timeIntervalSince(entry.timestamp) < cacheLifetime {
            pokemonDetailCache[id]?.timestamp = Date()
            return Just(entry.value)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return decorate.getPokemonDetailByIdPublisher(id)
            .handleEvents(receiveOutput: { [weak self] detail in
                self?.pokemonDetailCache[id] = CacheEntry(value: detail, timestamp: Date())
            })
            .eraseToAnyPublisher()
    }
    
    
}
