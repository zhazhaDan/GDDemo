//
//  JSBridgeVC.swift
//  GDDemo
//
//  Created by GDD on 2020/12/7.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit
import WebKit
import WebViewJavascriptBridge


class JSBridgeVC: BaseViewController {

    private let applicationName = "artpro"
    var webV: WKWebView!
    private var bridge: WebViewJavascriptBridge!
    override func viewDidLoad() {
        super.viewDidLoad()
        webV = WKWebView.init(frame: self.view.bounds)
        webV.navigationDelegate = self
        view.addSubview(webV)
        if let path = Bundle.main.path(forResource: "index", ofType: "html") {
            do {
                let htmlContent = try String.init(contentsOfFile: path)
                webV.loadHTMLString(htmlContent, baseURL: nil)
            } catch { }
        }

        bridge = WebViewJavascriptBridge.init(webV)
        bridge.registerHandler("testCallHandler") { [weak self](data, callback) in
            guard let self = self else { return }
            print(data)
            callback?("Response from testCallHandler")
        }

        bridge.registerHandler("testCallHandler2222") { [weak self](data, callback) in
            guard let self = self else { return }
            print(data)
            callback?("Response from testCallHandler2222")
        }


        self.bridge.callHandler("testJavascriptHandler", data: ["foo": "before ready"])

    }

    deinit {
        print("\(NSStringFromClass(JSBridgeVC.self)) deinit")
    }
}

extension JSBridgeVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}

