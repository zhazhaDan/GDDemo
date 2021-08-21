//
//  WebViewController.swift
//  GDDemo
//
//  Created by GDD on 2020/12/2.
//  Copyright © 2020 GDD. All rights reserved.
//

/**
    优点  --          减少代码量，只需要和js约定一个函数名即可， 格式 参数固定，具体内容自己解析param
    缺点  --          函数名固定 参数格式固定 数量固定。 fun   xxx(_ param: Any?, _callback: String?)
            一旦格式不正确，就会崩溃
    建议 --           以特殊开头区别 js交互函数，避免其他人误改
 */
import UIKit
import WebKit



class WebViewController: BaseViewController {

    private let applicationName = "artpro"
    var webV: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let content = WKUserContentController()
        content.add(self, name: self.applicationName)

        let config = WKWebViewConfiguration()
        config.userContentController = content

        webV = WKWebView.init(frame: self.view.bounds, configuration: config)
        webV.navigationDelegate = self
        view.addSubview(webV)
        if let path = Bundle.main.path(forResource: "vip", ofType: "html") {
            do {
                let htmlContent = try String.init(contentsOfFile: path)
                webV.loadHTMLString(htmlContent, baseURL: nil)
            } catch { }
        }
    }
}


extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name != self.applicationName { return }
        if let body = message.body as? [String: Any],
           let method = body["method"] as? String {
            let aSel = NSSelectorFromString(method)
            if !self.canPerformAction(aSel, withSender: nil) {
                return
            }
            let para = body["parameter"]
            let callback = body["callback"]
            let paramsCount = method.components(separatedBy: [":"]).count
            switch paramsCount {
            case 1:
                self.perform(aSel)
            case 2:
                self.perform(aSel, with: para)
            case 3:
                self.perform(aSel, with: para, with: callback)
            default:
                self.perform(aSel, with: para, with: callback)
            }
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        var js = "document.webView.mainFrame.javaScriptContext"
        webV.evaluateJavaScript(js) { (info, error) in
            print("webView didFinish info: \(info) error: \(error.debugDescription)")
        }

        js = "document"
        webV.evaluateJavaScript(js) { (info, error) in
            print("webView didFinish info: \(info) error: \(error.debugDescription)")
        }
    }
}

@objc protocol WebJSFunctionProtocol: NSObjectProtocol {
    func test(_ value: Any?)
    func managerIAPAutoRenew()
    func __toast(_ value: Any?)
    func listIapProducts(_ value: Any?, _ callback: String?)
    // js调用App的功能后 App再调用js函数执行回调
    func callHandler(handleFuncName: String)

}

class WebJSModel: NSObject,  WebJSFunctionProtocol {
    weak var webVC: WebViewController?
    func callHandler(handleFuncName: String) {
        if let webV = webVC?.webV {
            webV.evaluateJavaScript(handleFuncName, completionHandler: nil)
        }
    }

    internal func test(_ value: Any?) {
        print("js call test(_ value: \(value ?? ""))")
    }

    internal func managerIAPAutoRenew() {
        print("js call managerIAPAutoRenew")
    }

    internal func __toast(_ value: Any?) {
        print("js call __toast \(value ?? "")")
    }

    internal func listIapProducts(_ value: Any?, _ callback: String?) {
        print("js call ListIapProducts")
        if let callback = callback {
            let js = callback + "(\(true), \("ListIapProducts"))"
            self.callHandler(handleFuncName: js)
        }
    }
}


