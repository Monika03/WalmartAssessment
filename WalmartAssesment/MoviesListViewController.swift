//
//  MoviesListViewController.swift
//  WalmartAssesment
//
//  Created by Ankam Mounika on 10/27/17.
//  Copyright © 2017 Ankam Mounika. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    //MARK: Variables
    var movies = [Movie]()
    var downloadedImage: UIImage? = nil
    var activeImageDownloads = [IndexPath: Any]()
    lazy var moviesInfoService: WalmartMovieService = WalmartMovieServiceImpl()
    
    //MARK: Private Variables
    fileprivate let MovieCellIdentifier = "MovieCell"
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    var searchActive : Bool = false
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isHidden = true
    }
   
@IBAction func submitButtonTapped(_ sender: Any) {
    self.tableView.isHidden = false
    self.fetchProducts()
    }
}
extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieCellIdentifier, for: indexPath) as! MovieTableViewCell
        
        if (self.movies.count > 0) {
            let movie = self.movies[indexPath.row]
            movieCell.configureCellWithMovie(_movie: movie)
            
            if let image = movie.movieImage {
                movieCell.movieImage?.image = image
            }else {
                self.downloadImage(movie, indexPath: indexPath)
            }
            return movieCell
        }
        return movieCell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
}

extension MoviesListViewController
{
    func fetchProducts(_pageNum:Int = NetworkHelper.PAGE_NUM) {
        
        guard let searchText = self.searchText, searchText != "" else {
            
            self.tableView.isHidden = true
            self.displayAlertController(withTitle: "Invalid Entry", message: "Please enter text to search")
            return
        }
        
        let baseString = NetworkHelper.WALMART_LABE_BASE_PATH
        let pathString = String(format:"%@&page=1&include_adult=false","\(searchText)")
        let urlString = "\(baseString)\(pathString)"
        let urlNew:String = urlString.replacingOccurrences(of: " ", with: "%20")
        
        self.moviesInfoService.fetchProductsInfo(urlNew) { [weak self] (error, moviesArray) in
            if let movies = moviesArray, movies.count > 0 {
                if(((self?.movies)?.count)! > 0)
                {
                    self?.movies = []
                    self?.movies.append(contentsOf: movies)
                }else{
                   self?.movies.append(contentsOf: movies)
                }
                DispatchQueue.main.async {
                    self?.tableView.rowHeight = UITableViewAutomaticDimension
                    self?.tableView.estimatedRowHeight = 100.0
                    self?.tableView.reloadData()
                }
            }else{
                DispatchQueue.main.async {
                    self?.tableView.isHidden = true
                    self?.displayAlertController(withTitle: "Sorry!", message: "No results found")
                }
            }
        }
    }
    
    fileprivate func displayAlertController(withTitle atitle:String, message aMessage:String) {
        
        let alertView = UIAlertController(title: atitle, message: aMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
}

extension MoviesListViewController: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         self.searchText = searchText
    }
}

 //MARK: - `ProductsListViewController` extension with Product Image download logic.
extension MoviesListViewController {
    
    func downloadImage(_ movie: Movie, indexPath: IndexPath) {
        
        if let _ = self.activeImageDownloads[indexPath] as? ImageDownloader {
            
            return
            
        } else {
            
            let imageDownloader = ImageDownloader(movie)
            self.activeImageDownloads[indexPath] = imageDownloader
            imageDownloader.startDownload { (error, image) in
                DispatchQueue.main.async {
                    if let tableViewCell = self.tableView.cellForRow(at: indexPath) as? MovieTableViewCell,
                        let movieImage = image {
                        tableViewCell.movieImage?.image = movieImage
                        self.activeImageDownloads.removeValue(forKey: indexPath)
                    }
                }
            }
        }
    }
    
    func terminateAllDownloads() {
        
        let imageDownloaders = Array(self.activeImageDownloads.values)
        for item in imageDownloaders {
            if let downloader = item as? ImageDownloader {
                downloader.cancelDownload()
            }
        }
    }
}

// MARK: - `ProductsListViewController` extension with navigation logic.
extension MoviesListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueIdentifier = segue.identifier, (segueIdentifier == "MovieDetail"),
            let cell = sender as? MovieTableViewCell{
            if let destinationMoviesListViewController = segue.destination as? MovieDetailsViewController {
                if let indexPath = self.tableView.indexPath(for: cell) {
                   destinationMoviesListViewController.movie = self.movies[indexPath.row]
                    self.tableView.deselectRow(at: indexPath, animated: false)
                }
            }
        }
    }
}
