//
//  AdVC.swift
//  tempApp
//
//  Created by Garvit Kaushik on 17/02/26.
//

import UIKit

class AdVC: UIViewController {
    let bannerButton = CWButton(backgroundColor: .systemRed, title: "Banner Ads")
    let nativeButton = CWButton(backgroundColor: .systemGreen, title: "Native Ads")
    let unifiedButton = CWButton(backgroundColor: .systemBlue, title: "Unified Ads")
    let fullScreenButton = CWButton(backgroundColor: .systemOrange, title: "Full Screen Ads")

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Ad Types"

        configureUI()
    }

    func configureUI() {
        configureBannerButton()
        configureNativeButton()
        configureUnifiedButton()
        configureFullScreenButton()
    }

    func configureBannerButton() {
        view.addSubview(bannerButton)
        bannerButton.addTarget(self, action: #selector(showBannerVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            bannerButton.widthAnchor.constraint(equalToConstant: 260),
            bannerButton.heightAnchor.constraint(equalToConstant: 50),
            bannerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120),
        ])
    }

    func configureNativeButton() {
        view.addSubview(nativeButton)
        nativeButton.addTarget(self, action: #selector(showNativeVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            nativeButton.widthAnchor.constraint(equalToConstant: 260),
            nativeButton.heightAnchor.constraint(equalToConstant: 50),
            nativeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nativeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
        ])
    }

    func configureUnifiedButton() {
        view.addSubview(unifiedButton)
        unifiedButton.addTarget(self, action: #selector(showUnifiedVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            unifiedButton.widthAnchor.constraint(equalToConstant: 260),
            unifiedButton.heightAnchor.constraint(equalToConstant: 50),
            unifiedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unifiedButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
        ])
    }

    func configureFullScreenButton() {
        view.addSubview(fullScreenButton)
        fullScreenButton.addTarget(self, action: #selector(showFullScreenVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            fullScreenButton.widthAnchor.constraint(equalToConstant: 260),
            fullScreenButton.heightAnchor.constraint(equalToConstant: 50),
            fullScreenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fullScreenButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 90),
        ])
    }

    @objc func showBannerVC() {
        navigationController?.pushViewController(BannerVC(), animated: true)
    }

    @objc func showNativeVC() {
        navigationController?.pushViewController(NativeVC(), animated: true)
    }

    @objc func showUnifiedVC() {
        navigationController?.pushViewController(UnifiedVC(), animated: true)
    }

    @objc func showFullScreenVC() {
        navigationController?.pushViewController(FullScreenVC(), animated: true)
    }
}
