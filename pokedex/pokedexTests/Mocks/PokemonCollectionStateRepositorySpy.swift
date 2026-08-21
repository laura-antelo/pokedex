//
//  CollectionStateRepositorySpy.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 8/5/26.
//

import Combine
@testable import pokedex

final class PokemonCollectionStateRepositorySpy: PokemonCollectionStateRepository {
    var saveCallCount = 0
    var receivedState: PokemonCollectionState?
    var receivedId: Int?
    
    private let subject: CurrentValueSubject<[Int: PokemonCollectionState], Never>
    
    init(initialStates: [Int : PokemonCollectionState] = [:]) {
        self.subject = CurrentValueSubject(initialStates)
    }
    
    func allStatesPublisher() -> AnyPublisher<[Int : PokemonCollectionState], Never> {
        subject.eraseToAnyPublisher()
    }
    
    func statePublisher(for id: Int) -> AnyPublisher<PokemonCollectionState, Never> {
        subject.map { states in
            states[id] ?? .none
        }.removeDuplicates().eraseToAnyPublisher()
    }
    
    func save(_ state: PokemonCollectionState, for id: Int) {
        saveCallCount += 1
        receivedState = state
        receivedId = id
        
        var currentStates = subject.value
        
        if state == .none {
            currentStates.removeValue(forKey: id)
        } else {
            currentStates[id] = state
        }
        
        subject.send(currentStates)
    }
}
