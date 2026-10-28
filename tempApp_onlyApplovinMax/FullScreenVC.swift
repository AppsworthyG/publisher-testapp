//
//  CardSelectionVC.swift
//  CardWorkoutProgrammatic
//
//  Created by Garvit Kaushik on 04/04/24.
//

import UIKit
import AppLovinSDK
import GoogleMobileAds

class FullScreenVC: UIViewController {
    let bannerButton = CWButton(backgroundColor: .systemRed, title: "banner")
    let intButton = CWButton(backgroundColor: .systemBlue, title: "Interstitial")
    let rewButton = CWButton(backgroundColor: .systemBlue, title: "Rewarded")
    let rewIntButton = CWButton(backgroundColor: .systemBlue, title: "Show Int")
    let natButton = CWButton(backgroundColor: .systemGreen, title: "Native Ads")
    let adSpace = UIView()
    
    var interstitialAd: MAInterstitialAd!
    var rewardedAd: MARewardedAd!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [ "8cf23cacc6066293d12ffb20af1b9f35" ]
        
        let initConfig = ALSdkInitializationConfiguration(sdkKey: "SxsydnkBpsVItFPpCgeLDT0PspivxcQ5AGfkMXn9_GTnz5RbVbvXDqwHAveKerTyx5HqCUdlXd_xd5NQ354FAV") { builder in
            builder.mediationProvider = ALMediationProviderMAX
        }
        
        // Initialize the SDK with the configuration
        ALSdk.shared().initialize(with: initConfig) { sdkConfig in
        // Start loading ads
            print("Applovin SDK initialized")
        }
        
        ALSdk.shared().settings.isVerboseLoggingEnabled = true
        
        view.backgroundColor = .systemBackground
        
        interstitialAd = MAInterstitialAd(adUnitIdentifier: "c35f2ab12a348848")
        interstitialAd.delegate = self
        
        rewardedAd = MARewardedAd.shared(withAdUnitIdentifier: "05a86618066c2f30")
        rewardedAd.delegate = self
        
//        let ads = MobileAds.shared
//            ads.start { status in
//              let adapterStatuses = status.adapterStatusesByClassName
//              for adapter in adapterStatuses {
//                let adapterStatus = adapter.value
//                NSLog("Adapter Name: %@, Description: %@, Latency: %f", adapter.key,
//                adapterStatus.description, adapterStatus.latency)
//              }
//              // Start loading ads here...
//        }
//        "/21775744923/example/native"
        
        configureUI()
    }
    
    func configureUI() {
        configureAdSpace()
        configureBannerButton()
        configureIntButton()
        configureRewdButton()
        configureRewIntButton()
        configureNatButton()
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
    
    func configureBannerButton() {
        view.addSubview(bannerButton)
        bannerButton.addTarget(self, action: #selector(loadBanner), for: .touchUpInside)
        NSLayoutConstraint.activate([
            bannerButton.widthAnchor.constraint(equalToConstant: 260),
            bannerButton.heightAnchor.constraint(equalToConstant: 40),
            bannerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerButton.topAnchor.constraint(equalTo: adSpace.bottomAnchor, constant: 30),
        ])
    }
    
    func configureIntButton() {
        view.addSubview(intButton)
        intButton.addTarget(self, action: #selector(loadInt), for: .touchUpInside)
        NSLayoutConstraint.activate([
            intButton.widthAnchor.constraint(equalToConstant: 260),
            intButton.heightAnchor.constraint(equalToConstant: 40),
            intButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            intButton.topAnchor.constraint(equalTo: bannerButton.bottomAnchor, constant: 30),
        ])
    }
    
    func configureRewdButton() {
        view.addSubview(rewButton)
        rewButton.addTarget(self, action: #selector(loadRew), for: .touchUpInside)
        NSLayoutConstraint.activate([
            rewButton.widthAnchor.constraint(equalToConstant: 260),
            rewButton.heightAnchor.constraint(equalToConstant: 40),
            rewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rewButton.topAnchor.constraint(equalTo: intButton.bottomAnchor, constant: 30),
        ])
    }
    
    func configureRewIntButton() {
        view.addSubview(rewIntButton)
        rewIntButton.addTarget(self, action: #selector(loadRewInt), for: .touchUpInside)
        NSLayoutConstraint.activate([
            rewIntButton.widthAnchor.constraint(equalToConstant: 260),
            rewIntButton.heightAnchor.constraint(equalToConstant: 40),
            rewIntButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rewIntButton.topAnchor.constraint(equalTo: rewButton.bottomAnchor, constant: 30),
        ])
    }
    
    func configureNatButton() {
        view.addSubview(natButton)
        natButton.addTarget(self, action: #selector(loadNative), for: .touchUpInside)
        NSLayoutConstraint.activate([
            natButton.widthAnchor.constraint(equalToConstant: 260),
            natButton.heightAnchor.constraint(equalToConstant: 40),
            natButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            natButton.topAnchor.constraint(equalTo: rewIntButton.bottomAnchor, constant: 30),
        ])
    }
    
    @objc func loadBanner() {
        self.navigationController?.pushViewController(BannerVC(), animated: false)
    }
    
    @objc func loadInt() {
        interstitialAd.load()
    }
    
    @objc func loadRew() {
        interstitialAd.show()
    }
    
    @objc func loadRewInt() {
        rewardedAd.load()
    }
    
    @objc func loadNative() {
        rewardedAd.show()
    }
}

extension FullScreenVC: MAAdDelegate {
    func didLoad(_ ad: MAAd) {
        print("didLoad")
    }
    
    func didFailToLoadAd(forAdUnitIdentifier adUnitIdentifier: String, withError error: MAError) {
        print("didFailToLoadAd")
    }
    
    func didDisplay(_ ad: MAAd) {
        print("didDisplay")
    }
    
    func didHide(_ ad: MAAd) {
        print("didHide")
    }
    
    func didClick(_ ad: MAAd) {
        print("didClick")
    }
    
    func didFail(toDisplay ad: MAAd, withError error: MAError) {
        print("didFail")
    }
}

extension FullScreenVC: MARewardedAdDelegate {
    func didRewardUser(for ad: MAAd, with reward: MAReward) {
        print("didRewardUser")
    }
}
