//
//  NowPlayingViewController.swift
//  Movies
//
//  Created by Sean McRoskey on 4/1/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import AFNetworking

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
        destination.movie = (sender as! MoviePosterCell).movie
    }

    func loadNowPlayingMoviesAsync(){
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(API_KEY)")
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
        cell.movie = Movie(withMovieInfo: self.moviesArray[indexPath.row] as! NSDictionary)
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
