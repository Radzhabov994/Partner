//
//  MainViewController.swift
//  Partner
//
//  Created by Гамид Раджабов on 19.11.2019.
//  Copyright © 2019 Gamid Radzhabov. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var partners: Results<Partner>!
    private var filteredPartners: Results<Partner>!
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        partners = realm.objects(Partner.self)
        
        // Setup the search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    


    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering{
            return filteredPartners.count
        }
        
        return partners.isEmpty ? 0 : partners.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        var partner = Partner()
        
        if isFiltering {
            partner = filteredPartners[indexPath.row]
        } else {
            partner = partners[indexPath.row]
        }

        cell.nameLabel.text = partner.name
        cell.locationLabel.text = partner.location
        cell.typeLabel.text = partner.type
        cell.imageOfPartner.image = UIImage(data: partner.imageData!)
        cell.imageOfPartner?.layer.cornerRadius = cell.imageOfPartner.frame.size.height / 2
        cell.imageOfPartner?.clipsToBounds = true

        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let delPartner = partners[indexPath.row]
            StorageManager.deleteObject(delPartner)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let partner: Partner
            if isFiltering {
                partner = filteredPartners[indexPath.row]
            } else {
                partner = partners[indexPath.row]
            }
            let newPartnerVC = segue.destination as! NewPartnerViewController
            newPartnerVC.currentPartner = partner
        }
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPartnerVC = segue.source as? NewPartnerViewController else {return}
        
        newPartnerVC.savePartner()
        tableView.reloadData()
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        
        sorting()
    }
    
    private func sorting() {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            partners = partners.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            partners = partners.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String){
        
        filteredPartners = partners.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText,searchText)
        
        tableView.reloadData()
    }
}
