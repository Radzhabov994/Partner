//
//  MainViewController.swift
//  Partner
//
//  Created by Гамид Раджабов on 19.11.2019.
//  Copyright © 2019 Gamid Radzhabov. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    let partners = ["Yandex", "Vkontakte", "Mail.ru", "Avito", "Telegram"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return partners.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        cell.nameLabel?.text = partners[indexPath.row]
        cell.imageOfPartner?.image = UIImage(named: partners[indexPath.row])
        cell.imageOfPartner?.layer.cornerRadius = cell.imageOfPartner.frame.size.height / 2
        cell.imageOfPartner?.clipsToBounds = true

        return cell
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
