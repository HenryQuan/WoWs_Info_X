//
//  File.swift
//  WoWs Info
//
//  Created by Henry Quan on 30/1/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class WelcomeController : UIViewController {
    
    @IBOutlet var gotoSearchController: UITapGestureRecognizer!
    @IBOutlet var gotoSettingsController: UITapGestureRecognizer!
    @IBOutlet weak var searchButton: UIImageView!
    @IBOutlet weak var settingsBtn: UIImageView!
    @IBOutlet weak var onlinePlayerLabel: UILabel!
    @IBOutlet weak var onlinePlayerIcon: UIImageView!
    @IBOutlet weak var dashboardBtn: UIImageView!
    @IBOutlet weak var dashboardBtnConstant: NSLayoutConstraint!
    @IBOutlet weak var settingsBtnConstraint: NSLayoutConstraint!
    let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // If it is first launch
        if UserDefaults.standard.bool(forKey: DataManagement.DataName.FirstLaunch) {
            // Show an alertview
            let welcome = UIAlertController(title: "Welcome", message: "This application is designed to get a quick overview of other players before battle begins. Please first customise some settings.", preferredStyle: .alert)
            welcome.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> () in
                self.performSegue(withIdentifier: "gotoSettings", sender: nil)
            }))
            self.present(welcome, animated: true, completion: nil)
            
            // Change it to false
            UserDefaults.standard.set(false, forKey: DataManagement.DataName.FirstLaunch)
        }
        
        // If it is pro version
        if isProVersion {
            // Hide bannerView
            bannerView.isHidden = true
            
            // Move settings button down
            settingsBtnConstraint.constant -= 50
            dashboardBtnConstant.constant -= 50
        } else {
            // Hide dashboard
            dashboardBtn.isHidden = true
            
            // Load ads
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            bannerView.adSize = kGADAdSizeSmartBannerLandscape
            bannerView.adUnitID = "ca-app-pub-5048098651344514/4703363983"
            bannerView.rootViewController = self
            bannerView.load(request)
        }
        
        // Get ship information
        Shipinformation().getShipInformation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        onlinePlayerLabel.text = " --- "
        
        if searchButton.alpha == 0.0 {
            // Show Ads first
            UIView.animate(withDuration: 0.75, delay: 0.0, options: .curveEaseIn, animations: {
                self.bannerView.alpha = 1.0
            }, completion: nil)
            
            // Show online player
            UIView.animate(withDuration: 0.75, delay: 1.0, options: .curveEaseIn, animations: {
                self.onlinePlayerLabel.alpha = 1.0
                self.onlinePlayerLabel.frame.origin.y += 25
                self.onlinePlayerIcon.alpha = 1.0
                self.onlinePlayerIcon.frame.origin.y += 25
            }, completion: nil)
            
            // Show Search Button
            UIView.animate(withDuration: 0.75, delay: 2.0, options: .curveEaseIn, animations: {
                self.searchButton.alpha = 1.0
                self.searchButton.frame.origin.y -= 25
            }, completion: nil)
            
            // Show Settings and Dashboard Button
            UIView.animate(withDuration: 0.75, delay: 2.5, options: .curveEaseIn, animations: {
                self.settingsBtn.alpha = 1.0
                self.settingsBtn.frame.origin.x += 25
                self.dashboardBtn.alpha = 1.0
                self.dashboardBtn.frame.origin.x -= 25
            }, completion: nil)
            
        }
        
        // Update online player number
        PlayerOnline().getOnlinePlayerNumber { (player) in
            DispatchQueue.main.async {
                self.onlinePlayerLabel.text = "\(player) online"
                print("Updated")
            }
        }
        
        // If there is user information
        if UserDefaults.standard.string(forKey: DataManagement.DataName.UserName) == ">_<" {
            dashboardBtn.isHidden = true
        } else {
            dashboardBtn.isHidden = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoDashboard" {
            let destination = segue.destination as! AdvancedInfoController
            let playerAccount = UserDefaults.standard.string(forKey: DataManagement.DataName.UserName)!
            destination.playerInfo = playerAccount.components(separatedBy: "|")
        }
        
    }

}
