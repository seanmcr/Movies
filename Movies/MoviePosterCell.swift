//
//  MoviePosterCell.swift
//  Movies
//
//  Created by Sean McRoskey on 4/1/17.
//  Copyright © 2017 codepath. All rights reserved.
//

import UIKit

class MoviePosterCell: UITableViewCell {

    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var movie : Movie? {
        didSet {
            if (self.movie != nil){
                self.backdropImage?.setImageWith(self.movie!.getBackdropImageURL())
                self.titleLabel?.text = self.movie!.title
            } else {
                self.backdropImage?.image = nil
                self.titleLabel?.text = nil
                self.ratingLabel?.text = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.movie = nil
    }

}
