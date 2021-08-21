//
//  CustomJSbridgeVC.swift
//  GDDemo
//
//  Created by GDD on 2020/12/10.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit
import WebKit

class CustomJSbridgeVC: BaseViewController {
    private let applicationName = "artpro"
    var webV: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let content = WKUserContentController()
        let model = CustomJSModel()
        model.applicationName = self.applicationName
        model.delegate = self
        content.add(model, name: model.applicationName)

        let toast: CustomJSCallback? = {
            [weak self] text, callback in
            guard let self = self else { return }
            print("toast \(text)")
            if let value = callback as? String {
                model.callHandler(handleFuncName: value)
            }
        }

        let test: CustomJSCallback? = {
            [weak self] text, callback in
            guard let self = self else { return }
            print("test \(text)")
            if let value = callback as? String {
                model.callHandler(handleFuncName: value)
            }
        }


        model.registHandler(handler: toast, for: "__toast:")
        model.registHandler(handler: test, for: "test")


        let config = WKWebViewConfiguration()
        config.userContentController = content

        webV = WKWebView.init(frame: self.view.bounds, configuration: config)
        webV.navigationDelegate = self
        model.web = webV
        view.addSubview(webV)
        if let path = Bundle.main.path(forResource: "vip", ofType: "html") {
            do {
                let htmlContent = try String.init(contentsOfFile: path)
                webV.loadHTMLString(htmlContent, baseURL: nil)
            } catch { }
        }

    }
}

extension CustomJSbridgeVC: CustomWKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("CustomJSbridgeVC userContentController \(message.name)")
    }
}

extension CustomJSbridgeVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
}


typealias CustomJSCallback = (Any?, Any?) -> Void
protocol WindJSProtocol: WKScriptMessageHandler {
    // js调用App的功能后 App再调用js函数执行回调
    func callHandler(handleFuncName: String)
    func registHandler(handler: CustomJSCallback?, for name: String)
    func removeHandler(for name: String)
}

protocol CustomJSProtocol: WindJSProtocol  {
//    var toast: CustomJSCallback? { get set }
//    var test:  CustomJSCallback? { get set }
}

protocol CustomWKScriptMessageHandler: NSObjectProtocol {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage)
}

class CustomJSModel: NSObject, CustomJSProtocol {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        if message.name != self.applicationName { return }
        if let body = message.body as? [String: Any],
           let method = body["method"] as? String {
            let para = body["parameter"]
            let callback = body["callback"]
//            if let closure = messageHandler[method] as? CustomJSCallback,
//               let para = para as? String,
//               let callback = callback as? String {
//                closure(para, callback)
//            }
            if let closure = messageHandler[method] as? CustomJSCallback  {
                closure(para, callback)
            }
        }

        delegate?.userContentController(userContentController, didReceive: message)
    }

    weak var web: WKWebView?
    var applicationName = "artpro"

    weak var delegate: CustomWKScriptMessageHandler?
    private var messageHandler: [String: CustomJSCallback?] = [:]
    func callHandler(handleFuncName: String) {
        web?.evaluateJavaScript(handleFuncName, completionHandler: nil)
    }

    func registHandler(handler: CustomJSCallback?, for name: String) {
        messageHandler[name] = handler
    }

    func removeHandler(for name: String) {
        if messageHandler.keys.contains(name) {
            messageHandler.removeValue(forKey: name)
        }
    }

//    var toast: CustomJSCallback?
//
//    var test: CustomJSCallback?
//
//    override init() {
//        super.init()
//        toast = {
//            [weak self] text, callback in
//            guard let self = self else { return }
//            print("toast \(text)")
//            if let value = callback {
//                self.callHandler(handleFuncName: value)
//            }
//        }
//
//        test = {
//            [weak self] text, callback in
//            guard let self = self else { return }
//            print("test \(text)")
//            if let value = callback {
//                self.callHandler(handleFuncName: value)
//            }
//        }
//    }
}



