//
//  MockNetworkManager.swift
//  MoviesApp
//
//  Created by Juan José Menéndez Alarcón on 22/11/24.
//  Copyright © 2024 Juan José Menéndez Alarcón. All rights reserved.
//

import Foundation


class MockMoviesService: MoviesServiceProtocol {
    var shouldFail: Bool = false
    
    func fetchAllMovies(completion: @escaping (Result<[String : Movies], AppError>) -> Void) {
         if shouldFail {
             completion(.failure(.noData))
         } else {
             var moviesList: [String : Movies] = [:]
             moviesList["popular"] = Movies(dates: nil, page: 1, results: [dummyMovieInfo], total_pages: 5, total_results: 100)
             
             completion(.success(moviesList))
         }
    }
    
    func fetchMovies(endpoint: String, completion: @escaping (Result<Movies, AppError>) -> Void) {
        if shouldFail {
            completion(.failure(.noData))
        } else {
            completion(.success(Movies(dates: nil, page: 1, results: [dummyMovieInfo], total_pages: 5, total_results: 100)))
        }
    }
    
    func fetchMovieDetails(endPoint: String, completion: @escaping (Result<MovieDetails, AppError>) -> Void) {
        if shouldFail {
            completion(.failure(.noData))
        } else {
            completion(.success(dummyDetailsMovieInfo))
        }
    }
}

let dummyMovieInfo: MovieInfo = MovieInfo(adult: false, backdrop_path: Optional("/18TSJF1WLA4CkymvVUcKDBwUJ9F.jpg"), genre_ids: [27, 53], id: 1034541, original_language: "en", original_title: "Terrifier 3", overview: "Five years after surviving Art the Clown\'s Halloween massacre, Sienna and Jonathan are still struggling to rebuild their shattered lives. As the holiday season approaches, they try to embrace the Christmas spirit and leave the horrors of the past behind. But just when they think they\'re safe, Art returns, determined to turn their holiday cheer into a new nightmare. The festive season quickly unravels as Art unleashes his twisted brand of terror, proving that no holiday is safe.", popularity: 869.462, poster_path: "/63xYQj1BwRFielxsBDXvHIJyXVm.jpg", release_date: "2024-10-09", title: "Terrifier 3", video: false, vote_average: 6.863, vote_count: 1183)

let dummyDetailsMovieInfo: MovieDetails = MovieDetails(adult: Optional(false), backdrop_path: Optional("/b3mdmjYTEL70j7nuXATUAD9qgu4.jpg"), belongs_to_collection: nil, budget: 3700000, genres: [Genre(id: 16, name: "Animation"), Genre(id: 14, name: "Fantasy"), Genre(id: 12, name: "Adventure")], homepage: "https://flowthemovie.com/", id: 823219, imdb_id: Optional("tt4772188"), original_language: "lv", original_title: "Straume", origin_country: ["LV"], overview: "A solitary cat, displaced by a great flood, finds refuge on a boat with various species and must navigate the challenges of adapting to a transformed world together.", popularity: 885.787, poster_path: Optional("/imKSymKBK7o73sajciEmndJoVkR.jpg"), production_companies: [ProductionCompany(id: 153335, logo_path: Optional("/bEsO7l12cRGAY25Uqt1a66Ife1U.png"), name: "Dream Well Studio", origin_country: "LV"), ProductionCompany(id: 12433, logo_path: Optional("/sKu7Gr83ie8w6waDwYNHMBEaSah.png"), name: "Sacrebleu Productions", origin_country: "FR"), ProductionCompany(id: 101516, logo_path: Optional("/q7ynwvgbkht96N8qPFexUW3QFeR.png"), name: "Take Five", origin_country: "BE"), ProductionCompany(id: 94, logo_path: Optional("/huC7HqorvUThGIrENrbcHmQVUA0.png"), name: "ARTE France Cinéma", origin_country: "FR"), ProductionCompany(id: 792, logo_path: Optional("/cRhBQP1FFNugNxKkO1pUgeD2Rkr.png"), name: "RTBF", origin_country: "BE")], production_countries: [ProductionCountry(iso_3166_1: "BE", name: "Belgium"),  ProductionCountry(iso_3166_1: "FR", name: "France"),  ProductionCountry(iso_3166_1: "LV", name: "Latvia")], release_date: "2024-08-29", revenue: 17496624, runtime: 85, spoken_languages: [SpokenLanguage(english_name: "No Language", iso_639_1: "xx", name: "No Language")], status: "Released", tagline: "Share in the beauty of togetherness.", title: "Flow", video: false, vote_average: 8.305, vote_count: 1277, videos:  Videos(id: nil, results: [ResultVideo(iso_639_1: "en", iso_3166_1: "US", name: "FLOW wins BEST INTERNATIONAL FILM at the 2025 Film Independent Spirit Awards", key: "fRNXjXTMV6E", site: "YouTube", size: 1080, type: "Featurette", official: true, published_at: "2025-02-23T01:00:59.000Z", id: "67bd2a6818f1e77cfaa4805e"), ResultVideo(iso_639_1: "en", iso_3166_1: "US", name: "Q&A with Gints Zilbalodis | TIFF 2025", key: "o78HTgTL1i4", site: "YouTube", size: 1080, type: "Featurette", official: true, published_at: "2025-02-20T19:57:22.000Z", id: "67b876daa2284666f1eb5f67"), ResultVideo(iso_639_1: "en", iso_3166_1: "US", name: "Director Teaser", key: "FCz3c9Hsxuk", site: "YouTube", size: 2160, type: "Teaser", official: true, published_at: "2025-02-14T16:50:40.000Z", id: "67b49aa2f47a8b922a6de870"), ResultVideo(iso_639_1: "en", iso_3166_1: "US", name: "\'Flow\' With Gints Zibalodis | Academy Conversations", key: "ntLPTgWcpZA", site: "YouTube", size: 1080, type: "Featurette", official: true, published_at: "2024-12-06T16:00:06.000Z", id: "6753266b80e5b8f0a7564195"), ResultVideo(iso_639_1: "en", iso_3166_1: "US", name: "Inside the Making of FLOW | Official Behind the Scenes", key: "yw-a7buP4KA", site: "YouTube", size: 1080, type: "Behind the Scenes", official: true, published_at: "2024-12-05T17:59:19.000Z", id: "676553fb6ceba829b9749831"), ResultVideo(iso_639_1: "en", iso_3166_1: "US", name: "Official US Trailer", key: "ZgZccxuj2RY", site: "YouTube", size: 1080, type: "Trailer", official: true, published_at: "2024-09-26T14:57:15.000Z", id: "66f578c41d10a1709f47e6ba"), ResultVideo(iso_639_1: "en", iso_3166_1: "US", name: "Official Trailer", key: "82WW9dVbglI", site: "YouTube", size: 1080, type: "Trailer", official: true, published_at: "2024-09-16T04:17:00.000Z", id: "66e82308e8211ecd22b104aa"), ResultVideo(iso_639_1: "en", iso_3166_1: "US", name: "Clip", key: "bIkGBw_8sDs", site: "YouTube", size: 1080, type: "Clip", official: true, published_at: "2024-08-27T09:03:22.000Z", id: "66e06f25ca33c5636a6cc783")]), similar:  Movies(dates: nil, page: 1, results: [ MovieInfo(adult: false, backdrop_path: nil, genre_ids: [16, 10751], id: 251996, original_language: "pl", original_title: "Jeśli ujrzysz kota fruwającego po niebie", overview: "A psychedelic animated short about a flying cat.", popularity: 0.54, poster_path: nil, release_date: "1971-02-19", title: "If You Spot a Cat Flying Through the Air", video: false, vote_average: 5.0, vote_count: 1)], total_pages: 5119, total_results: 102365))
