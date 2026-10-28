//
//  CardSelectionVC.swift
//  CardWorkoutProgrammatic
//
//  Created by Garvit Kaushik on 04/04/24.
//

import UIKit
import GoogleMobileAds

class CardSelectionVC: UIViewController {
    let bannerButton = CWButton(backgroundColor: .systemRed, title: "banner")
    let intButton = CWButton(backgroundColor: .systemBlue, title: "Interstitial")
    let rewButton = CWButton(backgroundColor: .systemBlue, title: "Rewarded")
    let rewIntButton = CWButton(backgroundColor: .systemBlue, title: "Show Int")
    let natButton = CWButton(backgroundColor: .systemGreen, title: "Native Ads")
    let adSpace = UIView()
    
    private var interstitialAd: GADInterstitialAd? = nil
    private var rewardedAd: GADRewardedAd? = nil
    private var adLoader: GADAdLoader!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
//        CrackleMediationAdapter.crackleInitialize(viewController: self)
        
        GADMobileAds.sharedInstance().start(completionHandler: { status in
            print("GAM initialized")
         })
        
//        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [ "66f5b2070f60cf3cfc811fe912879c9f" ]
        
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
        
        self.adLoader = GADAdLoader(adUnitID: "/23043175892/P4u4pb/tech_crackle_tempApp_xuc81/P4u4pb_IOS_81_NAT_1_1_1_YG", rootViewController: self, adTypes: [ .native ], options: [])
        self.adLoader.delegate = self
        
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
                  interstitialAd = try await GADInterstitialAd.load(withAdUnitID: "/23043175892/P4u4pb/tech_crackle_tempApp_xuc81/P4u4pb_IOS_81_INT_9999_9999_1_YG", request: GAMRequest())
                  interstitialAd?.fullScreenContentDelegate = self
              } catch {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
              }
        }
    }
    
    @objc func loadRew() {
        Task {
            do {
                rewardedAd = try await GADRewardedAd.load(withAdUnitID: "/23043175892/P4u4pb/tech_crackle_tempApp_xuc81/P4u4pb_IOS_81_RWD_9999_9999_1_YG", request: GAMRequest())
                rewardedAd?.fullScreenContentDelegate = self
            } catch {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func loadRewInt() {
        if let interstitialAd = interstitialAd {
            interstitialAd.present(fromRootViewController: self)
        } else {
            print("Interstitial ad is not loaded yet.")
        }
    }
    
    @objc func loadNative() {
//        rewardedAd?.present(from: self, userDidEarnRewardHandler: {
//            print("reward granted!")
//        })
        self.adLoader.load(GAMRequest())
    }
}

extension CardSelectionVC: GADFullScreenContentDelegate {
    func ad(_ ad: any GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        print("failed to present")
    }
    
    func adDidRecordImpression(_ ad: any GADFullScreenPresentingAd) {
        print("impression recorded")
    }
    
    func adDidRecordClick(_ ad: any GADFullScreenPresentingAd) {
        print("click recorded")
    }
    
    func adWillPresentFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        print("will present full screen content")
    }
    
    func adDidDismissFullScreenContent(_ ad: any GADFullScreenPresentingAd) {
        print("did dismiss full screen content")
    }
}

extension CardSelectionVC : GADNativeAdLoaderDelegate  {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: any Error) {
        print("AdLoader failed to receive ad: \(error)")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        print("AdLoader received a native ad: \(nativeAd)")
        let nibView = Bundle.main.loadNibNamed("CustomNativeAdView1", owner: nil, options: nil)?.first
        guard let nativeAdView = nibView as? GADNativeAdView else {
          return
        }
        
//        CrackleMediationAdapter.registerAd(nativeAd: nativeAd, nativeAdView: nativeAdView)

        // Set ourselves as the native ad delegate to be notified of native ad events.
//        nativeAd.delegate = self

        // Populate the native ad view with the native ad assets.
        // The headline and mediaContent are guaranteed to be present in every native ad.
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

        // Some native ads will include a video asset, while others do not. Apps can use the
        // GADVideoController's hasVideoContent property to determine if one is present, and adjust their
        // UI accordingly.
        // Update the ViewController for video content.
        
        
//        let hasVideoContent = nativeAd.mediaContent.hasVideoContent
//        updateVideoStatusLabel(hasVideoContent: hasVideoContent)
//        if hasVideoContent {
//          // By acting as the delegate to the GADVideoController, this ViewController receives messages
//          // about events in the video lifecycle.
//          nativeAd.mediaContent.videoController.delegate = self
//        }

        // This app uses a fixed width for the GADMediaView and changes its height to match the aspect
        // ratio of the media it displays.
        if let mediaView = nativeAdView.mediaView, nativeAd.mediaContent.aspectRatio > 0 {
          let aspectRatioConstraint = NSLayoutConstraint(
            item: mediaView,
            attribute: .width,
            relatedBy: .equal,
            toItem: mediaView,
            attribute: .height,
            multiplier: CGFloat(nativeAd.mediaContent.aspectRatio),
            constant: 0)
          mediaView.addConstraint(aspectRatioConstraint)
          nativeAdView.layoutIfNeeded()
        }
        // These assets are not guaranteed to be present. Check that they are before
        // showing or hiding them.
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil

        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(
            fromStarRating: nativeAd.starRating as Decimal?)
        nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

        (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
        nativeAdView.storeView?.isHidden = nativeAd.store == nil

        (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
        nativeAdView.priceView?.isHidden = nativeAd.price == nil

        (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
        nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

        // In order for the SDK to process touch events properly, user interaction should be disabled.
        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        // Associate the native ad view with the native ad object. This is
        // required to make the ad clickable.
        // Note: this should always be done after populating the ad views.
        nativeAdView.nativeAd = nativeAd
        
        adSpace.addSubview(nativeAdView)
    }
    
    func imageOfStars(fromStarRating starRating: Decimal?) -> UIImage? {
        guard let swiftDecimal = starRating else {
            return nil
        }

        let rating = NSDecimalNumber(decimal: swiftDecimal).doubleValue

        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
}

extension CardSelectionVC: GADNativeAdDelegate {
    func nativeAdDidRecordImpression(_ nativeAd: GADNativeAd) {
        // Handle ad impression recorded
        print("Ad impression recorded.")
    }

    func nativeAdDidRecordClick(_ nativeAd: GADNativeAd) {
        // Handle ad click recorded
        print("Ad click recorded.")
    }

    func nativeAdDidRecordSwipeGestureClick(_ nativeAd: GADNativeAd) {
        // Handle swipe gesture click recorded
        print("Swipe gesture click recorded.")
    }

    func nativeAdWillPresentScreen(_ nativeAd: GADNativeAd) {
        // Pause any ongoing tasks or animations
        print("Ad will present screen.")
    }

    func nativeAdWillDismissScreen(_ nativeAd: GADNativeAd) {
        // Prepare for the ad screen to be dismissed
        print("Ad will dismiss screen.")
    }

    func nativeAdDidDismissScreen(_ nativeAd: GADNativeAd) {
        // Resume tasks that were paused or stopped
        print("Ad did dismiss screen.")
    }

    func nativeAdIsMuted(_ nativeAd: GADNativeAd) {
        // Handle the ad being muted
        print("Ad was muted by the user.")
    }
}
