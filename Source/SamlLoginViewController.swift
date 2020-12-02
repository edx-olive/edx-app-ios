//
//  SamlLoginViewController.swift
//  edX
//
//  Created by andrey.canon on 10/11/18.
//  Copyright © 2018 edX. All rights reserved.
//

import WebKit

@objc class SamlLoginViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    var webView: WKWebView!
    var sessionCookie: HTTPCookie!
    private let loadingIndicatorView = SpinnerView(size: .Large, color: .Primary)

    typealias Environment = OEXConfigProvider & OEXStylesProvider & OEXRouterProvider
    fileprivate let environment: Environment
    private let authEntry: String

    init(environment: Environment, authEntry: String) {
        self.environment = environment
        self.authEntry = authEntry
        super.init(nibName: nil, bundle :nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: UIScreen.main.bounds)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view.addSubview(webView)
        let path = NSString.oex_string(withFormat: SAML_PROVIDER_URL, parameters: ["idpSlug": environment.config.samlProviderConfig.samlIdpSlug, "authEntry": authEntry])
        if let url = URL(string: (environment.config.apiHostURL()?.absoluteString)!+path) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        let closeButton = UIBarButtonItem(image: UIImage(named: "ic_cancel"), style: .plain, target: self, action: #selector(navigateBack))
        navigationItem.leftBarButtonItem = closeButton
        
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_next_blue"), style: .plain, target: self, action: #selector(goBack))
        navigationItem.rightBarButtonItem = backButton
    }
    
    @objc func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc func navigateBack() {
        dismiss(animated: true, completion: nil)
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
////        switch navigationAction.navigationType {
////        case .linkActivated, .formSubmitted, .formResubmitted:
////            if let URL = navigationAction.request.url {
////                UIApplication.shared.openURL(URL)
////            }
////            decisionHandler(.cancel)
////        default:
////            decisionHandler(.allow)
////        }
//        
//        decisionHandler(.allow)
//    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
            frame.isMainFrame {
            return nil
        }
        // for _blank target or non-mainFrame target
        webView.load(navigationAction.request)
        return nil
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicatorView.startAnimating()
        view.addSubview(loadingIndicatorView)
        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        webView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.title") { (response, error) in
            if let response = response as? String {
                self.navigationItem.title = response
            }
        }
        
        loadingIndicatorView.removeFromSuperview()
        guard let url = webView.url?.URLString else {
            return
        }
        if url.contains(find: (environment.config.apiHostURL()?.absoluteString)!) {
            guard  let cookies = HTTPCookieStorage.shared.cookies else {
                return
            }
            for cookie in cookies {
                if cookie.name.contains("sessionid"){
                    self.sessionCookie = cookie
                    getUserDetails(sessionCookie: cookie)

                }
            }
        } else {
            webView.isHidden = false
        }
    }

    func handleSuccessfulLoginWithSaml(userDetails: OEXUserDetails) {

        guard let session = OEXSession.shared() else {
            return
        }
        session.saveCookies(sessionCookie, userDetails: userDetails)
        self.dismiss(animated: false, completion: nil)

    }

    //// This methods is used to get user details when user session cookie is available
    func getUserDetails(sessionCookie: HTTPCookie) {
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config, delegate: nil, delegateQueue: nil)
        let cookie = String(format: "%@=%@", sessionCookie.name, sessionCookie.value)
        let request = NSMutableURLRequest.init(url: URL(string: String(format: "%@%@", (environment.config.apiHostURL()?.absoluteString)!, URL_GET_USER_INFO))!)
        request.addValue(cookie, forHTTPHeaderField: "Cookie")
        let task = session.dataTask(with: request as URLRequest, completionHandler: self.completionGetUserDetails)
        task.resume()
    }

    func completionGetUserDetails(data:Data?, response: URLResponse?, error: Error?) {
        guard error == nil && data != nil else {
            return
        }
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                let dictionary = try? JSONSerialization.jsonObject(with: data!)
                let userDetails = OEXUserDetails(userDictionary: dictionary as! [AnyHashable : Any])
                handleSuccessfulLoginWithSaml(userDetails: userDetails)
            } else if httpResponse.statusCode == 401 && authEntry == "register"{
                DispatchQueue.main.async {
                    self.webView.isHidden = false
                }                
            } else if httpResponse.statusCode == 401 {
                guard let session = OEXSession.shared() else {
                    return
                }
                session.closeAndClear()
                let message = Strings.serviceAccountNotAssociatedMessage(service: environment.config.samlProviderConfig.samlName, platformName: environment.config.platformName(), destinationName: environment.config.platformDestinationName())
                let alert = UIAlertController(title: Strings.floatingErrorLoginTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction) in
                    self.dismiss(animated: false, completion: nil)
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }

}
