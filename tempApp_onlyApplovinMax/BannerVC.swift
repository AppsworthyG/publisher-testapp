//
//  BannerVC.swift
//  CardWorkoutProgrammatic
//
//  Created by Garvit Kaushik on 04/04/24.
//

import UIKit
import AppLovinSDK

class BannerVC: UIViewController {
    
    // MARK: - UI
    
    private let adSpace = UIView()
    
    private let bannerButton = CWButton(backgroundColor: .systemBlue, title: "Banner")
    private let largeBannerButton = CWButton(backgroundColor: .systemBlue, title: "Large")
    private let mrecButton = CWButton(backgroundColor: .systemBlue, title: "MREC")
    private let leaderBoardButton = CWButton(backgroundColor: .systemBlue, title: "Leader")
    private let adaptiveBannerButton = CWButton(backgroundColor: .systemBlue, title: "Adaptive")
    private let customBannerButton = CWButton(backgroundColor: .systemBlue, title: "Custom")
    private let pauseButton = CWButton(backgroundColor: .systemRed, title: "Pause")
    private let playButton = CWButton(backgroundColor: .systemGreen, title: "Resume")
    
    // MARK: - AppLovin
    private var adView: MAAdView?
    private var postMortemTimer: Timer?
    
    // Replace with your ad unit ids
    private let bannerAdUnitId = "9bee1ae3e9c38a0b"
    private let mrecAdUnitId = "868366159e5326ad"
    private let leaderAdUnitId = "9bee1ae3e9c38a0b"
    
    private var buttons: [CWButton]!
    private var buttonActions: [Selector]!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        buttons = [
            bannerButton,
            largeBannerButton,
            mrecButton,
            leaderBoardButton,
            adaptiveBannerButton,
            customBannerButton,
            pauseButton,
            playButton,
            UIViewButtonPlaceholder.create()
        ]
        
        buttonActions = [
            #selector(loadBanner),
            #selector(loadLargeBanner),
            #selector(loadMREC),
            #selector(loadLeaderBoard),
            #selector(loadAdaptiveBanner),
            #selector(loadCustomBanner),
            #selector(pauseRefresh),
            #selector(resumeRefresh),
            #selector(dummyAction)
        ]
        
        configureUI()
    }
    
    deinit {
//        adView?.destroy()
    }
    
    // MARK: - UI Setup
    
    private func configureUI() {
        configureAdSpace()
        configureGrid()
    }
    
    private func configureAdSpace() {
        view.addSubview(adSpace)
        
        adSpace.translatesAutoresizingMaskIntoConstraints = false
        adSpace.backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            adSpace.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            adSpace.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adSpace.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adSpace.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    private func configureGrid() {
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 10
        
        for idx in 0..<3 {
            mainStackView.addArrangedSubview(createRowStackView(idx: idx))
        }
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: adSpace.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func createRowStackView(idx: Int) -> UIStackView {
        
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.distribution = .fillEqually
        rowStackView.spacing = 10
        
        for i in 0..<3 {
            
            let button = buttons[(idx * 3) + i]
            
            button.addTarget(
                self,
                action: buttonActions[(idx * 3) + i],
                for: .touchUpInside
            )
            
            rowStackView.addArrangedSubview(button)
        }
        
        return rowStackView
    }
    
    // MARK: - Ad Loading
    
    private func destroyCurrentAd() {
        postMortemTimer?.invalidate()
        postMortemTimer = nil
//        adView?.stopAutoRefresh()
//        adView?.removeFromSuperview()
//        adView?.destroy()
        adView = nil
    }

    private func startPostMortemTimer() {
        postMortemTimer?.invalidate()
        postMortemTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            self?.logMAAdViewPostMortem()
        }
        postMortemTimer?.fire()
    }

    private func logMAAdViewPostMortem() {
        guard let adView = adView else { return }

        print("#######################")
        print("[PostMortem] MAAdView")
        print("  frame  : \(adView.frame)")
        print("  bounds : \(adView.bounds)")

        func printTree(_ view: UIView, indent: String = "  ") {
            for child in view.subviews {
                print("\(indent)[\(type(of: child))]")
                print("\(indent)  frame  : \(child.frame)")
                print("\(indent)  bounds : \(child.bounds)")
                printTree(child, indent: indent + "  ")
            }
        }
        printTree(adView)
        print("#######################")
    }
    
    private func loadAd(
        adUnitId: String,
        format: MAAdFormat
    ) {
        
        destroyCurrentAd()
        
        let adView = MAAdView(
            adUnitIdentifier: adUnitId,
            adFormat: format
        )
        
        
        
        adView.delegate = self
        adView.backgroundColor = .blue
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        adSpace.addSubview(adView)
        
        let size = format.size
        
        NSLayoutConstraint.activate([
            adView.centerXAnchor.constraint(equalTo: adSpace.centerXAnchor),
            adView.centerYAnchor.constraint(equalTo: adSpace.centerYAnchor),
            adView.widthAnchor.constraint(equalToConstant: size.width),
            adView.heightAnchor.constraint(equalToConstant: size.height)
        ])
        
        self.adView = adView
        
        adView.loadAd()
    }
    
    // MARK: - Actions
    
    @objc private func loadBanner() {
        
        loadAd(
            adUnitId: bannerAdUnitId,
            format: .banner
        )
    }
    
    @objc private func loadLargeBanner() {
        
        loadAd(
            adUnitId: bannerAdUnitId,
            format: .leader
        )
    }
    
    @objc private func loadMREC() {
        
        loadAd(
            adUnitId: mrecAdUnitId,
            format: .mrec
        )
    }
    
    @objc private func loadLeaderBoard() {
        
        loadAd(
            adUnitId: leaderAdUnitId,
        
            format: .leader
        )
    }
    
    @objc private func loadAdaptiveBanner() {
        adView?.removeFromSuperview()
        
        let config = MAAdViewConfiguration { builder in
            builder.adaptiveType = .anchored
        }
        
        let adView = MAAdView(adUnitIdentifier: bannerAdUnitId, configuration: config)
        
        adView.delegate = self
        adView.backgroundColor = .green
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        adSpace.addSubview(adView)
        
        let adaptiveHeight = MAAdFormat.banner.adaptiveSize.height
        
        NSLayoutConstraint.activate([
            adView.centerXAnchor.constraint(equalTo: adSpace.centerXAnchor),
            adView.centerYAnchor.constraint(equalTo: adSpace.centerYAnchor),
            adView.leadingAnchor.constraint(equalTo: adSpace.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: adSpace.trailingAnchor),
            adView.heightAnchor.constraint(equalToConstant: adaptiveHeight)
        ])
        
        self.adView = adView
        adView.loadAd()
    }
    
    @objc private func loadCustomBanner() {
        
        destroyCurrentAd()
        
        let adView = MAAdView(
            adUnitIdentifier: bannerAdUnitId,
            adFormat: .banner
        )
        
        adView.delegate = self
        
        adView.frame = CGRect(
            x: 0,
            y: 0,
            width: 320,
            height: 50
        )
        
        adView.center = CGPoint(
            x: adSpace.bounds.midX,
            y: adSpace.bounds.midY
        )
        
        adSpace.addSubview(adView)
        
        self.adView = adView
        
        adView.loadAd()
    }
    
    @objc private func pauseRefresh() {
        
//        print("Stopping auto refresh")
//        adView?.stopAutoRefresh()
    }
    
    @objc private func resumeRefresh() {
        
//        print("Starting auto refresh")
//        adView?.startAutoRefresh()
    }
    
    @objc private func dummyAction() {
        print("Unused Button")
    }
}

// MARK: - MAAdViewAdDelegate

extension BannerVC: MAAdViewAdDelegate {
    
    func didLoad(_ ad: MAAd) {
        print("✅ didLoad")
        startPostMortemTimer()
    }
    
    func didFailToLoadAd(
        forAdUnitIdentifier adUnitIdentifier: String,
        withError error: MAError
    ) {
        print("❌ didFailToLoadAd")
        print("Code: \(error.code)")
        print("Message: \(error.message)")
    }
    
    func didClick(_ ad: MAAd) {
        print("👉 didClick")
    }
    
    func didExpand(_ ad: MAAd) {
        print("⬆️ didExpand")
    }
    
    func didCollapse(_ ad: MAAd) {
        print("⬇️ didCollapse")
    }
    
    func didFail(
        toDisplay ad: MAAd,
        withError error: MAError
    ) {
        print("❌ didFailToDisplay")
    }
    
    // Deprecated callbacks
    
    func didDisplay(_ ad: MAAd) {
        print("didDisplay")
    }
    
    func didHide(_ ad: MAAd) {
        print("didHide")
    }
}

// MARK: - Placeholder Button

final class UIViewButtonPlaceholder {
    
    static func create() -> CWButton {
        let button = CWButton(
            backgroundColor: .systemGray4,
            title: "-"
        )
        
        button.isEnabled = false
        return button
    }
}
