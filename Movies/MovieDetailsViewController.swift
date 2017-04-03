//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Sean McRoskey on 4/1/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit
import Observable

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

class MovieDetailsViewController: UIViewController {

    var runtimeChanged : EventSubscription<ValueChange<String>>?
    
    var movie : Movie? {
        willSet {
            if (self.runtimeChanged != nil){
                movie!.runtime -= self.runtimeChanged!
            }
        }
        didSet{
            if (self.movie != nil){
                self.movie!.ensureDetailsAsync()
                self.runtimeChanged = self.movie!.runtime.afterChange += {
                    self.runtimeLabel.text = $1
                    self.runtimeLabel.sizeToFit()
                }
            }
        }
    }
    
    var bgImage : UIImage?
    
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage.addBlurEffect()
        self.backgroundImage.image = self.bgImage
        self.posterImage.setImageWith(self.movie!.getPosterImageURL())
        
        self.titleLabel.text = self.movie!.title
        self.overviewLabel.text = self.movie!.overview
        self.overviewLabel.sizeToFit()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
