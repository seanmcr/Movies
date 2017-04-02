//
//  NowPlayingViewController.swift
//  Movies
//
//  Created by Sean McRoskey on 4/1/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import AFNetworking

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

class Movie{
    var movieInfo : NSDictionary = [:]
    
    var title : String {
        return self.movieInfo["title"] as! String
    }
    
    var description : String {
        return self.movieInfo["overview"] as! String
    }
    
    var voteAverage : Double {
        return Double(self.movieInfo["vote_average"] as! String)!
    }
    
    init(info : NSDictionary){
        self.movieInfo = info
    }
    
    func getPosterImageURL() -> URL {
        return URL(string:"\(BASE_URL)/\(DEFAULT_POSTER_WIDTH)\(self.movieInfo["poster_path"] as! String)?api_key=\(API_KEY)")!
    }
    
    func getBackdropImageURL() -> URL{
        return URL(string:"\(BASE_URL)/\(DEFAULT_BACKDROP_WIDTH)\(self.movieInfo["backdrop_path"] as! String)?api_key=\(API_KEY)")!
    }
}

class NowPlayingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var moviesTable: UITableView!
    
    var moviesArray : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.moviesTable.rowHeight = 200
        self.moviesTable.delegate = self
        self.moviesTable.dataSource = self
        
        self.loadNowPlayingMoviesAsync()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destination = segue.destination as! MovieDetailsViewController
        destination.
    }

    func loadNowPlayingMoviesAsync(){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let threeMonthsAgo = Date.init(timeIntervalSinceNow: (-90 * 24 * 60 * 60))
//        let threeMonthsAgoStr = dateFormatter.string(from: threeMonthsAgo)
//        let nowStr = dateFormatter.string(from: Date())
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(API_KEY)")
//        &primary_release_date.gte=\(threeMonthsAgoStr)&primary_release_date.lte=\(nowStr)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.moviesArray = responseDictionary["results"] as! NSArray
                        self.moviesTable.reloadData()
                    }
                }
        });
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.moviesTable.dequeueReusableCell(withIdentifier: "MoviePosterCell") as! MoviePosterCell
        cell.prepareForReuse()
        let movie = Movie(info: self.moviesArray[indexPath.row] as! NSDictionary)
        cell.backdropImage.setImageWith(movie.getBackdropImageURL())
        cell.titleLabel?.text = movie.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesArray.count
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
