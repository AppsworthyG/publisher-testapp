//
//  CardSelectionVC.swift
//  CardWorkoutProgrammatic
//
//  Created by Garvit Kaushik on 04/04/24.
//

import UIKit
import CrackleSDK
import GoogleMobileAds

class BannerVC: UIViewController {
    let mainStackView = UIStackView()
    let adSpace = UIView()
    let bannerButton = CWButton(backgroundColor: .systemBlue, title: "banner")
    let largeBannerButton = CWButton(backgroundColor: .systemBlue, title: "large banner")
    let mrecButton = CWButton(backgroundColor: .systemBlue, title: "MREC")
    let leaderBoardButton = CWButton(backgroundColor: .systemBlue, title: "Leader")
    let adaptiveBannerButton = CWButton(backgroundColor: .systemBlue, title: "Adapt")
    let customBannerButton = CWButton(backgroundColor: .systemBlue, title: "Custom")
    let pauseButton = CWButton(backgroundColor: .systemRed, title: "Pause ref")
    let playButton = CWButton(backgroundColor: .systemGreen, title: "Resume ref")
    var crackleAdView: CrackleAdView!
    
    var buttons: [CWButton]!
    var buttonActions: [Selector]!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [ "6d7ac60904344c7e052db169b2ee484c" ]
        
        buttons = [bannerButton, largeBannerButton, mrecButton, leaderBoardButton, adaptiveBannerButton, customBannerButton, pauseButton, playButton, playButton]
        buttonActions = [#selector(loadBanner), #selector(loadLarge), #selector(loadMREC), #selector(loadLeader), #selector(loadAdaptive), #selector(loadCustom), #selector(pauseRef), #selector(playRef), #selector(playRef)]
        configureUI()
        crackleAdView = CrackleAdView(viewController: self)
        
        crackleAdView.delegate = self
        
        adSpace.addSubview(crackleAdView)
        
        crackleAdView.translatesAutoresizingMaskIntoConstraints = false
        
        crackleAdView.setAdUnit("1")
        
        NSLayoutConstraint.activate([
            crackleAdView.centerXAnchor.constraint(equalTo: adSpace.centerXAnchor),
            crackleAdView.topAnchor.constraint(equalTo: adSpace.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func configureUI() {
        configureAdSpace()
        configureGrid()
    }
    
    func configureAdSpace() {
        view.addSubview(adSpace)
        adSpace.translatesAutoresizingMaskIntoConstraints = false
        adSpace.backgroundColor = .systemGray
        NSLayoutConstraint.activate([
            adSpace.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adSpace.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adSpace.heightAnchor.constraint(equalToConstant: 350),
            adSpace.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func configureGrid() {
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 10
        
        // Add 3 horizontal stack views
        for idx in 0..<3 {
            let rowStackView = createRowStackView(idx: idx)
            mainStackView.addArrangedSubview(rowStackView)
        }
        
        // Add the main stack view to the view controller's view
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        // Set constraints for the main stack view
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: adSpace.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: adSpace.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: adSpace.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // Helper function to create a horizontal stack view
    private func createRowStackView(idx: Int) -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.distribution = .fillEqually
        rowStackView.spacing = 10
        
        // Add 3 UI elements to the row stack view
        for i in 0..<3 {
            let element = buttons[idx*3 + i]
            element.addTarget(self, action: buttonActions[idx*3 + i], for: .touchUpInside)
            rowStackView.addArrangedSubview(element)
        }
        
        return rowStackView
    }
      
    @objc func loadBanner() {
        crackleAdView.setAdSizes([CrackleAdSize.banner])
        crackleAdView.loadAd()
    }
    
    @objc func loadLarge() {
        crackleAdView.setAdSizes([CrackleAdSize.large])
        crackleAdView.loadAd()
    }
    
    @objc func loadMREC() {
        crackleAdView.setAdSizes([CrackleAdSize.rectangle])
        crackleAdView.loadAd()
    }
    
    @objc func loadLeader() {
        crackleAdView.setAdSizes([CrackleAdSize.leaderBoard])
        crackleAdView.loadAd()
    }
    
    @objc func loadAdaptive() {
        crackleAdView.setAdSizes([CrackleAdSize.init(adaptiveWidth: 50)])
        crackleAdView.loadAd()
    }
    
    @objc func loadCustom() {
        crackleAdView.setAdSizes([CrackleAdSize.init(customWidth: 100, height: 100)])
        crackleAdView.loadAd()
    }
    
    @objc func pauseRef() {
    }
    
    @objc func playRef() {
    }
}

extension BannerVC: CrackleAdViewAdDelegate {
    func onAdLoaded(_ eCPM: Double) {
        print("Ad loaded successfully.")
    }
    
    func onAdFailedToLoad() {
        print("Ad failed to load.")
    }
    
    func onAdClicked() {
        print("Ad clicked.")
    }
}
