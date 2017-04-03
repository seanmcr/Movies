//
//  NowPlayingViewController.swift
//  Movies
//
//  Created by Sean McRoskey on 4/1/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import AFNetworking
import ARSLineProgress

class NowPlayingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var moviesTable: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    var moviesArray : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let titleFrame = UIView(frame: self.nowPlayingLabel.frame)
//        titleFrame.addSubview(self.nowPlayingLabel)
//        self.navigationItem.titleView = titleFrame
        
        self.moviesTable.rowHeight = 200
        self.moviesTable.delegate = self
        self.moviesTable.dataSource = self
        
        self.loadNowPlayingMoviesAsync()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.moviesTable.addSubview(refreshControl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MovieDetailsViewController
        let sourceCell = (sender as! MoviePosterCell)
        destination.movie = sourceCell.movie
        destination.bgImage = sourceCell.backdropImage.image
    }

    func refreshControlAction(_ refreshControl : UIRefreshControl){
        loadNowPlayingMoviesAsync(refreshControl: refreshControl)
    }
    
    func loadNowPlayingMoviesAsync(refreshControl : UIRefreshControl? = nil){
        if (refreshControl == nil){
            ARSLineProgress.show()
        }
        var dataLoaded = false
        
        // Ensure the progress shows for a minimum period of
        // time to prevent flashing
        var minimumDelayTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
            if (dataLoaded){
                ARSLineProgress.hide()
                self.moviesTable.reloadData()
            }
        }
        
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
                defer {
                    if (minimumDelayTimer.isValid == false){
                        ARSLineProgress.hide()
                        self.moviesTable.reloadData()
                    }
                    refreshControl?.endRefreshing()
                }
                if (error != nil){
                    self.networkErrorView.isHidden = false
                }
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.moviesArray = responseDictionary["results"] as! NSArray
                        dataLoaded = true
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0;
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
