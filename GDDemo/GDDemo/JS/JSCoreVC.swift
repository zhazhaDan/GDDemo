//
//  JSCoreVC.swift
//  GDDemo
//
//  Created by GDD on 2020/12/3.
//  Copyright © 2020 GDD. All rights reserved.
//

/**
 JavaScriptCore  基于UIWebView 获取上下文JSContext 来处理，  wkwebview无法获得上下文，因为布局和javascript是在另一个进程上处理的。
 故此方法已不推荐
 */

import UIKit
import JavaScriptCore
import WebKit


class JSCoreVC: BaseViewController {

    private let applicationName = "artpro"
    private var webV: UIWebView!
    private var wkwebV: WKWebView!
    private var htmlContent: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        uiwebview()

    }

    deinit {
        if wkwebV != nil {
            wkwebV.configuration.userContentController.removeAllUserScripts()
        }
    }
}

extension JSCoreVC {
    private func uiwebview() {
        webV = UIWebView.init(frame: self.view.bounds)
        webV.delegate = self
        view.addSubview(webV)
        if let path = Bundle.main.path(forResource: "JSCore", ofType: "html") {
            do {
                let htmlContent = try String.init(contentsOfFile: path)
                self.htmlContent = htmlContent
                webV.loadHTMLString(htmlContent, baseURL: nil)

            } catch {

            }
        }
    }

    private func wkwebview() {
        let content = WKUserContentController()
        content.add(self, name: self.applicationName)

        let config = WKWebViewConfiguration()
        config.userContentController = content

        wkwebV = WKWebView.init(frame: self.view.bounds, configuration: config)
        wkwebV.navigationDelegate = self
        view.addSubview(wkwebV)
        if let path = Bundle.main.path(forResource: "vip", ofType: "html") {
            do {
                let htmlContent = try String.init(contentsOfFile: path)
                webV.loadHTMLString(htmlContent, baseURL: nil)
            } catch { }
        }
    }

    private func testJSCoreCallback() {

        let context = JSContext()
        let _ = context?.evaluateScript("var num = 1")
        let _ = context?.evaluateScript("var name = ['x', 'y', 'z']")
        let _ = context?.evaluateScript("var triple = (value) => value + 3")
        let returnV = context?.evaluateScript("triple(3)")
        print("__testValueInContext --- returnValue = \(returnV?.toNumber())")

        // 往js中注入swift的 block  则一定要使用此关键字
        let stringHandler: @convention(block) (String) -> String = {
            [weak self] value in
            guard let self = self else { return "" }
            return value.appending("this is append string")
        }
        let handerValue = JSValue(object: stringHandler, in: context)
        context?.setObject(handerValue, forKeyedSubscript: "stringHandler" as NSString)
        let result = context?.evaluateScript("stringHandler('hello')")
        print("\(result?.toString())")
    }
}

extension JSCoreVC: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let jsContext = webView.value(forKeyPath:"documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            let model = SwiftJavaScriptModel()
            model.jsContext = jsContext
            jsContext.setObject(model, forKeyedSubscript: ("WebViewJavascriptBridge" as NSString)) //注入
            jsContext.evaluateScript(self.htmlContent)
            jsContext.exceptionHandler = {
                [weak self] (context, exception) in
                guard let self = self else { return }
                print("exception：", exception)

            }
        }
    }
}


@objc protocol SwiftJavaScriptProtocol: JSExport {
    func test(_ value: String?)
    func managerIAPAutoRenew()
    func __toast(_ value: String?)
    func listIapProducts(_ value: Any?, _ callback: String?)
    // js调用App的功能后 App再调用js函数执行回调
    func callHandler(handleFuncName: String)

    var stringCallback: (@convention(block) (String) -> String)? { get set }
}

//js
class SwiftJavaScriptModel: NSObject, SwiftJavaScriptProtocol  {
    weak var jsContext: JSContext? //js 的执行环境，调用js 或者注入js
    var stringCallback: (@convention(block) (String) -> String)?

    func test(_ value: String?) {
        print("js call test(_ value: \(value ?? ""))")
    }

    func managerIAPAutoRenew() {
        print("js call managerIAPAutoRenew")
    }

    func __toast(_ value: String?) {
        print("js call __toast \(value ?? "")")
    }

    func listIapProducts(_ value: Any?, _ callback: String?) {
        print("js call ListIapProducts")
        if let callback = callback {
            let js = callback + "(\(true), \("ListIapProducts"))"
            self.callHandler(handleFuncName: js)
        }
    }
    func callHandler(handleFuncName: String) {
        let jsHandlerFunc = self.jsContext?.objectForKeyedSubscript("\(handleFuncName)")
        let dict = ["name": "sean", "age": 18] as [String : Any]
        jsHandlerFunc?.call(withArguments: [dict])
    }

    override init() {
        super.init()
        self.stringCallback = {
            [weak self] value in
            print("SwiftJavaScriptModel stringCallback \(value)")
            return value.appending("this is append string")

        }
    }
}


extension JSCoreVC: WKScriptMessageHandler {
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

extension JSCoreVC: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        var js = "document.webView.mainFrame.javaScriptContext"
//        wkwebV.evaluateJavaScript(js) { (info, error) in
//            print("webView didFinish info: \(info) error: \(error.debugDescription)")
//        }
//
//        js = "document"
//        wkwebV.evaluateJavaScript(js) { (info, error) in
//            print("webView didFinish info: \(info) error: \(error.debugDescription)")
//        }
        webView.evaluateJavaScript("sureType('WKWebView')", completionHandler: nil)
    }

/*
     实现原理：
     1、JS与iOS约定好xdart协议，用作JS在调用iOS时url的scheme；
     2、JS拿到的url：(xdart://lot_detail?id=123)；
     3、iOS的WKWebView在请求跳转前会调用-webView:decidePolicyForNavigationAction:decisionHandler:方法来确认是否允许跳转；
     4、iOS在此方法内截取xdart协议获取JS传过来的数据，执行内部schema跳转逻辑
     5、通过decisionHandler(.cancel)可以设置不允许此请求跳转
     */
    //! WKWeView在每次加载请求前会调用此方法来确认是否进行请求跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {return}
        guard let scheme = url.scheme else {return}

        if scheme == "xdart" {
            // THSchemeManager.handleScheme(url.absoluteString)
        }
        decisionHandler(.allow)

    }

}

extension JSCoreVC: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        // call toast
        completionHandler()
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        // call alert
        completionHandler(true)
    }
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        // call input
        completionHandler("this is a message")
    }
}
