import UIKit
import CrackleSDK
import GoogleMobileAds

class FullScreenVC: UIViewController {
    let bannerButton = CWButton(backgroundColor: .systemRed, title: "Load Interstitial")
    let intButton = CWButton(backgroundColor: .systemRed, title: "Show Interstitial")
    let rewButton = CWButton(backgroundColor: .systemBlue, title: "Load Rewarded")
    let rewIntButton = CWButton(backgroundColor: .systemBlue, title: "Show Rewarded")
    let natButton = CWButton(backgroundColor: .systemGreen, title: "Native")
    let appOpenLoadButton = CWButton(backgroundColor: .systemOrange, title: "Load AppOpen")
    let appOpenShowButton = CWButton(backgroundColor: .systemOrange, title: "Show AppOpen")
    
    let adSpace = UIView()
    
    private var interstitialAd: CrackleInterstitialAd!
    private var rewardedAd: CrackleRewardedAd!
    private var appOpenAd: CrackleAppOpenAd!
    
//    private var crackleAdLoader: CrackleAdLoader!
    
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
        
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [ "6d7ac60904344c7e052db169b2ee484c" ]
        
        Crackle.shared.initialize(with: self, function:{
            print("Crackle initialized")
        })
        
        interstitialAd = CrackleInterstitialAd(adUnitId: "P4u4pb_IOS_81_INT_9999_9999_1")
        interstitialAd.delegate = self;
        //interstitialAd.setFloorPrice(0.01)
        
        rewardedAd = CrackleRewardedAd(adUnitId: "P4u4pb_IOS_81_RWD_9999_9999_1")
        rewardedAd.delegate = self
        rewardedAd.rewardDelegate = self
        //rewardedAd.setFloorPrice(0.01)
        
        appOpenAd = CrackleAppOpenAd(adUnitId: "P4u4pb_IOS_81_APP_OPEN_9999_9999_1")
        appOpenAd.delegate = self
        //appOpenAd.setFloorPrice(0.01)
    }
    
    func configureUI() {
        configureAdSpace()
        configureBannerButton()
        configureIntButton()
        configureRewdButton()
        configureRewIntButton()
        configureNatButton()
        configureAppOpenLoadButton()
        configureAppOpenShowButton()
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
    
    func configureAppOpenLoadButton() {
        view.addSubview(appOpenLoadButton)
        appOpenLoadButton.addTarget(self, action: #selector(loadAppOpen), for: .touchUpInside)
        NSLayoutConstraint.activate([
            appOpenLoadButton.widthAnchor.constraint(equalToConstant: 260),
            appOpenLoadButton.heightAnchor.constraint(equalToConstant: 40),
            appOpenLoadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appOpenLoadButton.topAnchor.constraint(equalTo: natButton.bottomAnchor, constant: 30),
        ])
    }
    
    func configureAppOpenShowButton() {
        view.addSubview(appOpenShowButton)
        appOpenShowButton.addTarget(self, action: #selector(showAppOpen), for: .touchUpInside)
        NSLayoutConstraint.activate([
            appOpenShowButton.widthAnchor.constraint(equalToConstant: 260),
            appOpenShowButton.heightAnchor.constraint(equalToConstant: 40),
            appOpenShowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appOpenShowButton.topAnchor.constraint(equalTo: appOpenLoadButton.bottomAnchor, constant: 30),
        ])
    }
    
    @objc func loadBanner() {
        self.navigationController?.pushViewController(BannerVC(), animated: false)
    }
    
    @objc func loadInt() {
        interstitialAd.loadAd()
    }
    
    @objc func loadRew() {
        interstitialAd.show(with: self)
    }
    
    @objc func loadRewInt() {
        rewardedAd.loadAd()
    }
    
    @objc func loadNative() {
        rewardedAd.show(with: self)
    }
    
    @objc func loadAppOpen() {
        appOpenAd.loadAd()
    }
    
    @objc func showAppOpen() {
        appOpenAd.show(with: self)
    }
    
    deinit {
        print("dsfsdf");
    }
}

extension FullScreenVC: CrackleUserRewardDelegate {
    func onUserRewarded(_ crackleReward: CrackleSDK.CrackleReward) {
        print("user rewarded")
    }
}

extension FullScreenVC: CrackleAdDelegate {
    func onAdLoaded(_ eCPM: Double) {
        print("onadloaded")
    }
    
    func onAdFailedToLoad() {
        print("onAdFailedToLoad")
    }
    
    func onAdFailedToShow() {
        print("onAdFailedToShow")
    }
    
    func onAdDisplayed() {
        print("onAdDisplayed")
    }
    
    func onAdDismissed() {
        print("onAdDismissed")
    }
    
    func onAdClicked() {
        print("onAdClicked")
    }
}
