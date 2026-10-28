//
//  NativeVC.swift
//  tempApp
//
//  Created by Garvit Kaushik on 17/02/26.
//

import UIKit
import CrackleSDK

class NativeVC: UIViewController {
    let showNativeAdButton = CWButton(backgroundColor: .systemGreen, title: "Show NativeAd")

    let adSpace = UIView()

    private var crackleAdLoader: CrackleAdLoader!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureUI()

        Crackle.shared.initialize(with: self, function:{
            print("Crackle initialized")
        })

        crackleAdLoader = CrackleAdLoader()
        crackleAdLoader.delegate = self
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
            adSpace.heightAnchor.constraint(equalToConstant: 200),
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
        crackleAdLoader.loadAd()
    }
}

extension NativeVC: CrackleNativeAdLoaderDelegate {
    func onAdFinishedLoading() {
        
    }
    
    func onAdFailedToLoad() {
        
    }
    
    func onAdLoaded(_ crackleNativeAd: CrackleSDK.CrackleNativeAd) {
        let nibView = Bundle.main.loadNibNamed("NativeBannerAdView", owner: nil, options: nil)?.first

        guard let nativeAdView = nibView as? CrackleNativeAdView else { return }

        nativeAdView.registerAd(with: crackleNativeAd)

        nativeAdView.headlineView?.text = crackleNativeAd.headline

        (nativeAdView.bodyView as? UILabel)?.text = crackleNativeAd.body

        (nativeAdView.callToActionView as? UIButton)?.setTitle(crackleNativeAd.callToAction, for: .normal)

//        (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(
//            fromStarRating: crackleNativeAd.starRating)
//        nativeAdView.starRatingView?.isHidden = crackleNativeAd.starRating == nil

        nativeAdView.mediaView?.contentMode = .scaleAspectFit

        adSpace.addSubview(nativeAdView)

        NSLayoutConstraint.activate([
            nativeAdView.topAnchor.constraint(equalTo: adSpace.topAnchor)
        ])
    }
}
