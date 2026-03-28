//
//  CreateLanguageArrayUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 27/03/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

protocol CreateLanguageArrayUseCase {
    func create(moviesDictionary: [String: MoviesEntity]) -> [String]
}

class CreateLanguageArrayUseCaseImpl: CreateLanguageArrayUseCase {
    func create(moviesDictionary: [String: MoviesEntity]) -> [String] {
        var languageSet: Set<String> = []
        moviesDictionary.forEach({ movie in
            languageSet.formUnion(movie.value.originalLanguagesSet)
        })
        
        return Array(languageSet).sorted()
    }
}
