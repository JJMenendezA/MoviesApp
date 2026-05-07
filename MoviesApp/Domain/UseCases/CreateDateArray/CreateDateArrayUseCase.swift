//
//  CreateDateArrayUseCase.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 27/03/26.
//  Copyright © 2026 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation

protocol CreateDateArrayUseCase {
    func create(moviesDictionary: [String: MoviesEntity]) -> [Date]
}

class CreateDateArrayUseCaseImpl: CreateDateArrayUseCase {
    func create(moviesDictionary: [String: MoviesEntity]) -> [Date] {
       var dateSet: Set<Date> = []
       moviesDictionary.forEach({ movie in
           dateSet.formUnion(movie.value.releaseDatesSet)
       })
       
       return Array(dateSet).sorted()
   }
}
