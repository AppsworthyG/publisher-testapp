//
//  CardSelectionVC.swift
//  CardWorkoutProgrammatic
//
//  Created by Garvit Kaushik on 04/04/24.
//

import UIKit
import IronSource

class BannerVC: UIViewController{
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
    
    var bannerView: LPMBannerAdView? = nil
    
    var buttons: [CWButton]!
    var buttonActions: [Selector]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        buttons = [bannerButton, largeBannerButton, mrecButton, leaderBoardButton, adaptiveBannerButton, customBannerButton, pauseButton, playButton, playButton]
        buttonActions = [#selector(loadBanner), #selector(loadLarge), #selector(loadMREC), #selector(loadLeader), #selector(loadAdaptive), #selector(loadCustom), #selector(pauseRef), #selector(playRef), #selector(playRef)]

        configureUI()
        let adConfig = LPMBannerAdViewConfigBuilder()
            .set(adSize: .banner())
            .set(placementName: "7rb1b92tztfyy9nw")
            .build()
        self.bannerView = LPMBannerAdView(adUnitId: "7rb1b92tztfyy9nw", config: adConfig)
        self.bannerView?.setDelegate(self)
        self.bannerView?.backgroundColor = .blue
        if let bannerView = self.bannerView {
            adSpace.addSubview(bannerView)
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bannerView.centerXAnchor.constraint(equalTo: adSpace.centerXAnchor),
                bannerView.centerYAnchor.constraint(equalTo: adSpace.centerYAnchor)
            ])
        }
    }
    
    func configureUI() {
        configureAdSpace()
        configureGrid()
    }
    
    func configureAdSpace() {
        view.addSubview(adSpace)
        adSpace.translatesAutoresizingMaskIntoConstraints = false
        adSpace.backgroundColor = .systemGray
        adSpace.clipsToBounds = true
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
    
    private func loadAd(adSize: LPMAdSize, adUnitId: String) {
        bannerView?.destroy()
        bannerView?.removeFromSuperview()
        let config = LPMBannerAdViewConfigBuilder()
            .set(adSize: adSize)
            .set(placementName: adUnitId)
            .build()
        let bv = LPMBannerAdView(adUnitId: adUnitId, config: config)
        bv.setDelegate(self)
        bv.backgroundColor = .blue
        bv.translatesAutoresizingMaskIntoConstraints = false
        adSpace.addSubview(bv)
        NSLayoutConstraint.activate([
            bv.centerXAnchor.constraint(equalTo: adSpace.centerXAnchor),
            bv.centerYAnchor.constraint(equalTo: adSpace.centerYAnchor)
        ])
        self.bannerView = bv
        bv.loadAd(with: self)
    }

    @objc func loadBanner() {
        loadAd(adSize: .banner(), adUnitId: "mce962shsqo8r06s")
    }

    @objc func loadLarge() {
        loadAd(adSize: .large(), adUnitId: "mce962shsqo8r06s")
    }

    @objc func loadMREC() {
        loadAd(adSize: .mediumRectangle(), adUnitId: "1oogy3y9wwzw0von")
    }

    @objc func loadLeader() {
        loadAd(adSize: .leaderBoard(), adUnitId: "mce962shsqo8r06s")
    }

    @objc func loadAdaptive() {
        guard let size = LPMAdSize.createAdaptive() else { return }
        loadAd(adSize: size, adUnitId: "mce962shsqo8r06s")
    }

    @objc func loadCustom() {
        loadAd(adSize: .customSize(withWidth: 320, height: 50), adUnitId: "mce962shsqo8r06s")
    }

    @objc func pauseRef() {
        bannerView?.pauseAutoRefresh()
    }

    @objc func playRef() {
        bannerView?.resumeAutoRefresh()
    }
}

extension BannerVC: LPMBannerAdViewDelegate {
    func didLoadAd(with adInfo: LPMAdInfo) {
        
    }
    
    func didFailToLoadAd(withAdUnitId adUnitId: String, error: any Error) {
        print("IS didFailToLoadWithError" + error.localizedDescription)
    }
    
    private func didClick(with adInfo: ISAdInfo!) {
        print("IS didClick")
    }
    
    func didLeaveApplication(with adInfo: ISAdInfo!) {
        print("didLeaveApplication")
    }
    
    func didPresentScreen(with adInfo: ISAdInfo!) {
        print("didPresentScreen")
    }
    
    func didDismissScreen(with adInfo: ISAdInfo!) {
        print("didDismissScreen")
    }
}
