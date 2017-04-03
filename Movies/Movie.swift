//
//  Movie.swift
//  Movies
//
//  Created by Sean McRoskey on 4/2/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import Foundation
import Observable

let BASE_URL = "https://image.tmdb.org/t/p/"
let DEFAULT_POSTER_WIDTH = "w342"
let DEFAULT_BACKDROP_WIDTH = "w300"
let API_KEY = "049156cb06397ab4c23876522189a3c2"


//    {
//        "poster_path": "/tnmL0g604PDRJwGJ5fsUSYKFo9.jpg",
//        "adult": false,
//        "overview": "A live-action adaptation of Disney's version of the classic 'Beauty and the Beast' tale of a cursed prince and a beautiful young woman who helps him break the spell.",
//        "release_date": "2017-03-15",
//        "genre_ids": [
//        14,
//        10402,
//        10749
//        ],
//        "id": 321612,
//        "original_title": "Beauty and the Beast",
//        "original_language": "en",
//        "title": "Beauty and the Beast",
//        "backdrop_path": "/6aUWe0GSl69wMTSWWexsorMIvwU.jpg",
//        "popularity": 185.891157,
//        "vote_count": 1037,
//        "video": false,
//        "vote_average": 7.2
//    }

class Movie {
    var movieInfo : NSDictionary = [:]
    var fetchDetailsTask : URLSessionDataTask?

    var title : String {
        return self.movieInfo["title"] as! String
    }
    
    var overview : String {
        return self.movieInfo["overview"] as! String
    }
    
    var voteAverage : Double {
        return Double(self.movieInfo["vote_average"] as! String)!
    }
    
    var releaseDate : String {
        return self.movieInfo["release_date"] as! String
    }
    
    var movieDetails : NSDictionary? {
        didSet {
            // Update runtime property
            if (self.movieDetails != nil){
                // TODO: Could improve by using culture-aware formatting
                let runtimeInMinutes = self.movieDetails!["runtime"] as! Int
                let hours = runtimeInMinutes / 60
                let minutes = runtimeInMinutes % 60
                self.runtime ^= "\(hours)h \(minutes)m"
                
                let prodCos = self.movieDetails!["production_companies"] as! NSArray
                self.productionCompanies ^= prodCos.map({"\(($0 as! NSDictionary).value(forKey: "name")!)"}).joined(separator: ", ")
            } 
        }
    }

    var runtime : Observable<String> = Observable<String>("")
    var productionCompanies : Observable<String> = Observable<String>("")
    
    init(withMovieInfo movieInfo : NSDictionary){
        self.movieInfo = movieInfo
    }
    
    func ensureDetailsAsync() {
        if (self.movieDetails == nil && self.fetchDetailsTask == nil){
            let url = URL(string:"https://api.themoviedb.org/3/movie/\(movieInfo["id"]!)?api_key=\(API_KEY)")
            let request = URLRequest(url: url!)
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            self.fetchDetailsTask = session.dataTask(
                with: request as URLRequest,
                completionHandler: { (data, response, error) in
                    if let data = data {
                        if let responseDictionary = try! JSONSerialization.jsonObject(
                            with: data, options:[]) as? NSDictionary {
                            self.movieDetails = responseDictionary
                        }
                    }
            });
            self.fetchDetailsTask!.resume()
        }
    }
    
    func getPosterImageURL() -> URL {
        return URL(string:"\(BASE_URL)/\(DEFAULT_POSTER_WIDTH)\(self.movieInfo["poster_path"] as! String)?api_key=\(API_KEY)")!
    }
    
    func getBackdropImageURL() -> URL{
        return URL(string:"\(BASE_URL)/\(DEFAULT_BACKDROP_WIDTH)\(self.movieInfo["backdrop_path"] as! String)?api_key=\(API_KEY)")!
    }
}
