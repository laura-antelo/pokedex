//
//  DefaultPokemonRepository.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 20/4/26.
//

 import UIKit
import Combine
 
class DefaultPokemonRepository: PokemonRepository {
    
    private let client: PokeAPIClient = DefaultPokeAPIClient()
    private let pokemonLimit: Int = 151
    
    func getAllPokemonsPublisher() -> AnyPublisher<[Pokemon], any Error> {
        client.fetchPokemonList(limit: pokemonLimit)
            .flatMap { response -> AnyPublisher<[Pokemon], any Error> in
                let publishers = response.results.compactMap { item -> AnyPublisher<Pokemon, Error>? in
                    guard let id = self.extractPokemonId(from: item.url) else { return nil }
                    return self.pokemonPublisher(id: id)
                }
                
                guard !publishers.isEmpty else {
                    return Just([])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                
                return Publishers.MergeMany(publishers)
                    .collect()
                    .map{ $0.sorted(by: { $0.id < $1.id }) }
                    .eraseToAnyPublisher()
            } .eraseToAnyPublisher()
    }
    
    func getPokemonDetailByIdPublisher(_ id: Int) -> AnyPublisher<PokemonDetail, any Error> {
        let pokemonPublisher = client.fetchPokemon(id: id)
        let speciesPublisher = client.fetchPokemonSpecies(id: id)
        
        return Publishers.Zip(pokemonPublisher, speciesPublisher)
            .flatMap { pokemonResponse, speciesResponse in
                Publishers.Zip(self.client.fetchImage(from: pokemonResponse.sprites.frontDefault),
                               self.client.fetchImage(from: pokemonResponse.sprites.backDefault))
                .map { frontImage, backImage in
                    let images = [frontImage, backImage].compactMap { $0 }
                    
                    return PokemonDetail(id: pokemonResponse.id, name: pokemonResponse.species.name.capitalized,images: images, description: Self.bestDescription(from: speciesResponse.flavorTextEntries), types: pokemonResponse.types.sorted(by: {$0.slot < $1.slot }).map{ $0.type.name.capitalized}, collectionState: .none)
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - HELPERS
    
    private func pokemonPublisher(id: Int) -> AnyPublisher<Pokemon, Error> {
        client.fetchPokemon(id: id)
            .flatMap { response in
                self.client.fetchImage(from: response.sprites.frontDefault)
                    .map { frontImage in
                        let images = [frontImage].compactMap { $0 }
                        
                        return Pokemon(id: response.id, name: response.species.name.capitalized, images: images, types: response.types.sorted(by: {$0.slot < $1.slot }).map{ $0.type.name.capitalized}, collectionState: .none)
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func extractPokemonId(from urlString: String) -> Int? {
        let parts = urlString.split(separator: "/")
        return Int(parts.last ?? "")
    }
        
    private static func bestDescription(from entries: [FlavorTextEntry]) -> String {
        let selectedEntry = entries.first(where: { $0.language.name == "es" })
        
        return selectedEntry?.flavorText
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\u{00C}", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        ?? "Sin descripción."
    }
}
