//
//  WebTableController.swift
//  WoWs Info
//
//  Created by Henry Quan on 21/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class WebTableController: UITableViewController {

    
    let website = ["https://worldofwarships.com/", "http://wiki.wargaming.net/en/World_of_Warships", "https://warships.today/", "http://wows-numbers.com/", "http://maplesyrup.sweet.coocan.jp/wows/ranking/", "https://github.com/HenryQuan/WOWS_TrainingRoom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Go to certain website according to tag
        let tag = tableView.cellForRow(at: indexPath)?.tag
        UIApplication.shared.openURL(URL(string: website[tag! - 1])!)

    }

}