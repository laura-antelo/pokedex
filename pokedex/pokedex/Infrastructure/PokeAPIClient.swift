//
//  PokeAPIClient.swift
//  pokedex
//
//  Created by Laura Antelo Gonzalez on 30/4/26.
//

import UIKit
import Combine

protocol PokeAPIClient {
    func fetchPokemonList(limit: Int) -> AnyPublisher<PokemonListResponse, Error>
    func fetchPokemon(id: Int) -> AnyPublisher<PokemonResponse, Error>
    func fetchPokemonSpecies(id: Int) -> AnyPublisher<PokemonSpeciesResponse, Error>
    func fetchImage(from urlString: String?) -> AnyPublisher<UIImage?, Error>
}

final class DefaultPokeAPIClient: PokeAPIClient {
    private let baseURL = "https://pokeapi.co/api/v2"
    private let session: URLSession = URLSession.shared
    private let decoder: JSONDecoder = JSONDecoder()
    private let imageCache = NSCache<NSString, UIImage>()
    
    func fetchPokemonList(limit: Int) -> AnyPublisher<PokemonListResponse, any Error> {
        guard let url = URL(string: baseURL + "/pokemon/")?.appending(queryItems: [URLQueryItem(name: "limit", value: "\(limit)")]) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return decodePublisher(url: url, type: PokemonListResponse.self)
    }
    
    func fetchPokemon(id: Int) -> AnyPublisher<PokemonResponse, any Error> {
        let url = URL(string: baseURL + "/pokemon/\(id)")!
        
        return decodePublisher(url: url, type: PokemonResponse.self)
    }
    
    func fetchPokemonSpecies(id: Int) -> AnyPublisher<PokemonSpeciesResponse, any Error> {
        let url = URL(string: baseURL + "/pokemon-species/\(id)")!
        
        return decodePublisher(url: url, type: PokemonSpeciesResponse.self)
    }
    
    func fetchImage(from urlString: String?) -> AnyPublisher<UIImage?, any Error> {
        guard let urlString else {
            return Just(nil)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            return Just(cachedImage)
                .map(Optional.some)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        guard let url = URL(string: urlString) else {
            return Fail(error: Error.self as! Error)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { [weak self] result in
                guard let image = UIImage(data: result.data) else {
                    throw URLError(.badServerResponse)
                }
                
                self?.imageCache.setObject(image, forKey: urlString as NSString)
                return image
            }.map(Optional.some)
            .eraseToAnyPublisher()
    }
    
    private func decodePublisher<T: Decodable>(url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
