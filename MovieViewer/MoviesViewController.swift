//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Kevin Alfonso on 1/31/17.
//  Copyright © 2017 Kevin Alfonso. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD



class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    var endPoint: String!


    // VIEW DID LOAD 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let navigationBar = navigationController?.navigationBar {
            let shadow = NSShadow()
            shadow.shadowColor = UIColor.gray.withAlphaComponent(1.0)
            shadow.shadowOffset = CGSize(width:2,height:2);
            shadow.shadowBlurRadius = 5;
            navigationBar.titleTextAttributes = [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22),
                NSForegroundColorAttributeName : UIColor.yellow,
                NSShadowAttributeName : shadow,
            ]
        }

        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.separatorStyle = .none
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint!)?api_key=\(apiKey)")!
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]

                    self.tableView.reloadData()
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)

        }
        task.resume()
        // Do any additional setup after loading the view.

 
    }
    
    
    // REFRESH CONTROL ACTION
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
    
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint!)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    
                    self.tableView.reloadData()
                }
            }

            
            self.tableView.reloadData()
            
            refreshControl.endRefreshing()
        }
        task.resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TABLE VIEW: NUMBER OF ROWS
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    
    // TABLE VIEW:  CELLS FOR ROW
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.titleLabel.sizeToFit()
        cell.overviewLabel.sizeToFit()
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        // Removes push navigation detail from table view
        cell.accessoryType = UITableViewCellAccessoryType.none


        // Customizing Cell Selection Effect
        cell.selectionStyle = .default
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.gray
        cell.selectedBackgroundView = backgroundView
        
        if let posterPath = movie["poster_path"] as? String {
        let imageUrl = NSURL(string: baseUrl + posterPath )
        cell.posterView.setImageWith(imageUrl as! URL)
        print("row \(indexPath.row)")
        }
        

        return cell
    }
    
    
    // SEARCH BAR: TEXT DID CHANGE
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        movies = searchText.isEmpty ? movies : movies?.filter({(data: NSDictionary) -> Bool in
            let title = data["title"] as! String
            return title.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
    
    
    // SEARCH BAR TEXT
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    
    // SEARCH BAR CANCEL
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    // PREPARE SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
        
        print("Prepare for segue called")
    }
    


}
