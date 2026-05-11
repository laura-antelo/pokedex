//
//  PokemonCollectionStateRepository.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 4/5/26.
//


import Foundation
import Combine

protocol PokemonCollectionStateRepository {
    func allStatesPublisher() -> AnyPublisher<[Int: PokemonCollectionState], Never>
    func statePublisher(for id: Int) -> AnyPublisher<PokemonCollectionState, Never>
    func save(_ state: PokemonCollectionState, for id: Int)
}

final class DefaultPokemonCollectionStateRepository: PokemonCollectionStateRepository {
    private let subject = CurrentValueSubject<[Int: PokemonCollectionState], Never>([:])
    
    func allStatesPublisher() -> AnyPublisher<[Int : PokemonCollectionState], Never> {
        return subject.eraseToAnyPublisher()
    }
    
    func statePublisher(for id: Int) -> AnyPublisher<PokemonCollectionState, Never> {
        return subject.map { states in
                states[id] ?? .none
        }
        .removeDuplicates()
        .eraseToAnyPublisher()
    }
    
    func save(_ state: PokemonCollectionState, for id: Int) {
        var currentStates = subject.value
        
        if state == .none {
            currentStates.removeValue(forKey: id)
        } else {
            currentStates[id] = state
        }
        
        subject.send(currentStates)
    }
    
    
}
