//
//  NativeVC.swift
//  tempApp_onlyGAM12
//
//  Created by Garvit Kaushik on 27/07/26.
//

import UIKit
import GoogleMobileAds

class NativeVC: UIViewController {
    let showNativeAdButton = CWButton(backgroundColor: .systemGreen, title: "Show NativeAd")
    let adSpace = UIView()

    private var adLoader: AdLoader!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        adLoader = AdLoader(adUnitID: "/23043175892/P4u4pb/tech_crackle_tempApp_xuc81/P4u4pb_IOS_81_NAT_1_1_1_YG", rootViewController: self, adTypes: [.native], options: [])
        adLoader.delegate = self

        configureUI()
    }

    func configureUI() {
        configureAdSpace()
        configureShowNativeAdButton()
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

    func configureShowNativeAdButton() {
        view.addSubview(showNativeAdButton)
        showNativeAdButton.addTarget(self, action: #selector(loadNative), for: .touchUpInside)
        NSLayoutConstraint.activate([
            showNativeAdButton.widthAnchor.constraint(equalToConstant: 260),
            showNativeAdButton.heightAnchor.constraint(equalToConstant: 40),
            showNativeAdButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showNativeAdButton.topAnchor.constraint(equalTo: adSpace.bottomAnchor, constant: 30),
        ])
    }

    @objc func loadNative() {
        adLoader.load(AdManagerRequest())
    }
}

extension NativeVC: NativeAdLoaderDelegate {
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: any Error) {
        print("AdLoader failed to receive ad: \(error)")
    }

    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        print("AdLoader received a native ad: \(nativeAd)")
        let nibView = Bundle.main.loadNibNamed("CustomNativeAdView1", owner: nil, options: nil)?.first
        guard let nativeAdView = nibView as? NativeAdView else {
            return
        }

        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

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

        nativeAdView.callToActionView?.isUserInteractionEnabled = false

        nativeAdView.nativeAd = nativeAd

        adSpace.subviews.forEach { $0.removeFromSuperview() }
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

extension NativeVC: NativeAdDelegate {
    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        print("Ad impression recorded.")
    }

    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        print("Ad click recorded.")
    }

    func nativeAdDidRecordSwipeGestureClick(_ nativeAd: NativeAd) {
        print("Swipe gesture click recorded.")
    }

    func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
        print("Ad will present screen.")
    }

    func nativeAdWillDismissScreen(_ nativeAd: NativeAd) {
        print("Ad will dismiss screen.")
    }

    func nativeAdDidDismissScreen(_ nativeAd: NativeAd) {
        print("Ad did dismiss screen.")
    }

    func nativeAdIsMuted(_ nativeAd: NativeAd) {
        print("Ad was muted by the user.")
    }
}
