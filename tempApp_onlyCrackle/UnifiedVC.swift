//
//  UnifiedVC.swift
//  tempApp
//
//  Created by Garvit Kaushik on 17/02/26.
//

import UIKit
import CrackleSDK

class UnifiedVC: UIViewController {
    let showNativeAdButton = CWButton(backgroundColor: .systemGreen, title: "Show UnifiedAd")

    let adSpaceTop = UIView()
    let adSpaceBottom = UIView()

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
        configureAdSpaceTop()
        configureShowNativeAdButton()
        configureAdSpaceBottom()
    }

    func configureAdSpaceTop() {
        view.addSubview(adSpaceTop)
        adSpaceTop.translatesAutoresizingMaskIntoConstraints = false
        adSpaceTop.backgroundColor = .systemGray
        NSLayoutConstraint.activate([
            adSpaceTop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adSpaceTop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adSpaceTop.heightAnchor.constraint(equalToConstant: 200),
            adSpaceTop.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }

    func configureShowNativeAdButton() {
        view.addSubview(showNativeAdButton)
        showNativeAdButton.addTarget(self, action: #selector(loadNative), for: .touchUpInside)
        NSLayoutConstraint.activate([
            showNativeAdButton.widthAnchor.constraint(equalToConstant: 260),
            showNativeAdButton.heightAnchor.constraint(equalToConstant: 40),
            showNativeAdButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showNativeAdButton.topAnchor.constraint(equalTo: adSpaceTop.bottomAnchor, constant: 30),
        ])
    }

    func configureAdSpaceBottom() {
        view.addSubview(adSpaceBottom)
        adSpaceBottom.translatesAutoresizingMaskIntoConstraints = false
        adSpaceBottom.backgroundColor = .systemGray
        NSLayoutConstraint.activate([
            adSpaceBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adSpaceBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adSpaceBottom.heightAnchor.constraint(equalToConstant: 200),
            adSpaceBottom.topAnchor.constraint(equalTo: showNativeAdButton.bottomAnchor, constant: 30)
        ])
    }

    @objc func loadNative() {
        crackleAdLoader.loadAd()
    }
}

extension UnifiedVC: CrackleBannerAdLoaderDelegate {
    func onAdLoaded(_ eCPM: Double, adView: CrackleAdView!) {
        adView.translatesAutoresizingMaskIntoConstraints = false
        adSpaceBottom.addSubview(adView)
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: adSpaceBottom.topAnchor),
            adView.centerXAnchor.constraint(equalTo: adSpaceBottom.centerXAnchor)
        ])
    }

    func validBannerSizesForAdLoader() -> [CrackleAdSize]! {
        return [CrackleAdSize.banner]
    }
}

extension UnifiedVC: CrackleNativeAdLoaderDelegate {
    func onAdFinishedLoading() {

    }

    func onAdFailedToLoad() {

    }

    func onAdLoaded(_ crackleNativeAd: CrackleSDK.CrackleNativeAd) {
        let nibView = Bundle.main.loadNibNamed("CustomNativeAdView", owner: nil, options: nil)?.first

        guard let nativeAdView = nibView as? CrackleNativeAdView else { return }

        nativeAdView.registerAd(with: crackleNativeAd)

        nativeAdView.headlineView?.text = crackleNativeAd.headline

        (nativeAdView.bodyView as? UILabel)?.text = crackleNativeAd.body

        (nativeAdView.callToActionView as? UIButton)?.setTitle(crackleNativeAd.callToAction, for: .normal)

        nativeAdView.mediaView?.contentMode = .scaleAspectFit

        adSpaceTop.addSubview(nativeAdView)

        NSLayoutConstraint.activate([
            nativeAdView.topAnchor.constraint(equalTo: adSpaceTop.topAnchor)
        ])
    }
}
