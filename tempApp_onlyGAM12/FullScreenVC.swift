//
//  CardSelectionVC.swift
//  CardWorkoutProgrammatic
//
//  Created by Garvit Kaushik on 04/04/24.
//

import UIKit
import GoogleMobileAds
import CrackleGoogleAdManagerAdapter

class FullScreenVC: UIViewController {
    let bannerButton = CWButton(backgroundColor: .systemRed, title: "banner")
    let intButton = CWButton(backgroundColor: .systemBlue, title: "Interstitial")
    let rewButton = CWButton(backgroundColor: .systemBlue, title: "Rewarded")
    let rewIntButton = CWButton(backgroundColor: .systemBlue, title: "Show Int")
    let natButton = CWButton(backgroundColor: .systemGreen, title: "Native Ads")
    let adSpace = UIView()
    
    private var interstitialAd: InterstitialAd? = nil
    private var rewardedAd: RewardedAd? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        CrackleMediationAdapter.crackleInitialize(with: self)
        
        MobileAds.shared.start(completionHandler: { status in
           print("GAM initialized")
        })
        
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [ "dbd58c1a6eeed92b252af1893ded0932" ]

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
        Task {
              do {
                  interstitialAd = try await AdManagerInterstitialAd.load(with: "/23043175892/P4u4pb/tech_crackle_tempApp_xuc81/P4u4pb_IOS_81_INT_9999_9999_1_YG", request: AdManagerRequest())
                  interstitialAd?.fullScreenContentDelegate = self
              } catch {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
              }
        }
    }
    
    @objc func loadRew() {
        Task {
            do {
                rewardedAd = try await RewardedAd.load(with: "/23043175892/P4u4pb/tech_crackle_tempApp_xuc81/P4u4pb_IOS_81_RWD_9999_9999_1_YG", request: AdManagerRequest())
                rewardedAd?.fullScreenContentDelegate = self
                rewardedAd?.present(from: self, userDidEarnRewardHandler: {
                    print("reward received")
                })
            } catch {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func loadRewInt() {
        if let interstitialAd = interstitialAd {
            interstitialAd.present(from: self)
        } else {
            print("Interstitial ad is not loaded yet.")
        }
    }
    
    @objc func loadNative() {
        if let rewardedAd = rewardedAd {
            rewardedAd.present(from: self, userDidEarnRewardHandler: {
                print("Rewarded")
            })
        } else {
            print("Interstitial ad is not loaded yet.")
        }
    }
}

extension FullScreenVC: FullScreenContentDelegate {
    func ad(_ ad: any FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        print("failed to present")
    }
    
    func adDidRecordImpression(_ ad: any FullScreenPresentingAd) {
        print("impression recorded")
    }
    
    func adDidRecordClick(_ ad: any FullScreenPresentingAd) {
        print("click recorded")
    }
    
    func adWillPresentFullScreenContent(_ ad: any FullScreenPresentingAd) {
        print("will present full screen content")
    }
    
    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        print("did dismiss full screen content")
    }
}

