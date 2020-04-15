//
//  MainViewController.swift
//  Partner
//
//  Created by Гамид Раджабов on 19.11.2019.
//  Copyright © 2019 Gamid Radzhabov. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    let partner = Partner.getPartners()

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partner.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        cell.nameLabel?.text = partner[indexPath.row].name
        cell.locationLabel?.text = partner[indexPath.row].location
        cell.typeLabel?.text = partner[indexPath.row].type
        cell.imageOfPartner?.image = UIImage(named: partner[indexPath.row].image)
        cell.imageOfPartner?.layer.cornerRadius = cell.imageOfPartner.frame.size.height / 2
        cell.imageOfPartner?.clipsToBounds = true

        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}

}
