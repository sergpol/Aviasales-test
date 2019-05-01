//
//  ViewController.swift
//  Aviasales test
//
//  Created by Сергей Полицинский on 30/04/2019.
//  Copyright © 2019 Сергей Полицинский. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var places: [PurpleRoute] = []
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.tableFooterView = UIView()
        
        definesPresentationContext = true
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }

    @objc func searchPlaces() {
        if let place = searchController.searchBar.text {
            NetworkComponents.shared.searchPlace(place: place, completion: { [weak self] result in
                switch result {
                case .success(let value):
                    print(value)
                    self?.places = value
                    self?.tableView.reloadData()
                    break
                case .failure(let error):
                    print("Error searching place: \(error.localizedDescription)")
                    break
                }
            })
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        let purplePlace = places[indexPath.row]
        cell.textLabel?.text = purplePlace.airportName
        cell.detailTextLabel?.text = purplePlace.iata
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController {
            vc.place = places[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchPlaces), object: searchBar)
        perform(#selector(searchPlaces), with: searchBar, afterDelay: 0.25)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        places.removeAll()
        tableView.reloadData()
    }
}
