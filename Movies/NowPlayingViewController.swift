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

class Movie{
    var movieInfo : NSDictionary = [:]
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

    func loadNowPlayingMoviesAsync(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let threeMonthsAgo = Date.init(timeIntervalSinceNow: (-90 * 24 * 60 * 60))
        let threeMonthsAgoStr = dateFormatter.string(from: threeMonthsAgo)
        let nowStr = dateFormatter.string(from: Date())
        let url = URL(string:"https://api.themoviedb.org/3/discover/movie?api_key=\(API_KEY)&primary_release_date.gte=\(threeMonthsAgoStr)&primary_release_date.lte=\(nowStr)")
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
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        // let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
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
