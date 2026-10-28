//
//  CardSelectionVC.swift
//  CardWorkoutProgrammatic
//
//  Created by Garvit Kaushik on 04/04/24.
//

import UIKit
import CrackleRtbSDK

class CardSelectionVC: UIViewController {
    let bannerButton = CWButton(backgroundColor: .systemRed, title: "banner")
    let intButton = CWButton(backgroundColor: .systemBlue, title: "Interstitial")
    let rewButton = CWButton(backgroundColor: .systemBlue, title: "Rewarded")
    let rewIntButton = CWButton(backgroundColor: .systemBlue, title: "Show Int")
    let natButton = CWButton(backgroundColor: .systemGreen, title: "Native Ads")
    let adSpace = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        CrackleRtb.initialize(appId: "") {
            print("Rtb SDK initialized")
        }
        
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
    }
    
    @objc func loadRew() {
    }
    
    @objc func loadRewInt() {
    }
    
    @objc func loadNative() {
    }
}
