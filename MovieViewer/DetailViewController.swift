//
//  DetailViewController.swift
//  Movies Now
//
//  Created by Kevin Alfonso on 2/7/17.
//  Copyright © 2017 Kevin Alfonso. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)

        let title = movie["title"] as? String
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        
        let overview = movie["overview"]
        overviewLabel.text = overview as? String
        overviewLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"

        
        if let posterPath = movie["poster_path"] as? String
        {
            let imageUrl = NSURL(string: baseUrl + posterPath )
            posterImageView.setImageWith(imageUrl as! URL)
        
        }
 
        
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
