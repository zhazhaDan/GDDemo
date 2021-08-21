//
//  FileDownloadOperation.swift
//  GDDemo
//
//  Created by GDD on 2020-07-03.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

enum FileDownloadOptions {
    case `default`, resume
}

typealias FileDownloadProgressCallback = (_ receivedSize: Int64, _ expectedSize: Int64, _ url: URL)->()
typealias FileDownloadCompleteCallback = (_ filePath: String?, _ error: Error?, _ finished: Bool)->()

protocol FileDownloadOperationProtocol {
    func `init`(request: URLRequest?, session: URLSession?) -> Operation
        
//    func `init`(url: URL?, session: URLSession?) -> Operation

    func cancel(token: String)
    
    func add(progress: FileDownloadProgressCallback?, complete: FileDownloadCompleteCallback?)
    
    var dataTask: URLSessionDownloadTask? { get }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
}

typealias FileCallbackDict = [String : Any?]

enum FileCallbackKeyEnum: String {
    case progress, complete
}

class FileDownloadOperation: Operation {
    private var task:URLSessionDownloadTask?
    private var request: URLRequest?
    private var response: URLResponse?
//    private var url: URL?
    private var session: URLSession?
    private var fileData: Data?
    private var expectedSize: Int64 = 0
    private var fileFinished: Bool = false {
        willSet {
            self.willChangeValue(forKey: "isFinished")
        }
        didSet {
            self.didChangeValue(forKey: "isFinished")
        }
    }
    private var fileExecuting: Bool = false {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
        }
        didSet {
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    private var callbacks: [FileCallbackDict] = []
    private var callbackLock = DispatchSemaphore.init(value: 1)
    override func start() {
        synced(self) {
            if self.isCancelled {
                self.fileFinished = true
                self.reset()
                return
            }
            if let _ = session { } else {
                let sessionConfig = URLSessionConfiguration.default
                sessionConfig.timeoutIntervalForRequest = 15
                session = URLSession.init(configuration: sessionConfig, delegate: self, delegateQueue: nil)
            }
            if let request = self.request {
                self.task = session?.downloadTask(with: request)
                self.fileExecuting = true
            }
//            if let url = url {
//                self.task = session?.downloadTask(with: url)
//                self.fileExecuting = true
//            }
            if let task = self.task {
                task.resume()
            }
        }
    }
    
    private func reset() {
        self.callbackLock.wait(timeout: .distantFuture)
        self.callbacks.removeAll()
        self.callbackLock.signal()
        synced(self) {
            self.task = nil
            self.session?.invalidateAndCancel()
            self.session = nil
        }
    }
    
    private func done() {
        self.fileFinished = true
        self.fileExecuting = false
        self.reset()
    }
    
    override var isConcurrent: Bool {
        return true
    }
    
    override var isFinished: Bool {
        return fileFinished
    }
    
    override var isExecuting: Bool {
        return fileExecuting
    }
}


extension FileDownloadOperation: FileDownloadOperationProtocol {
//    func `init`(url: URL?, session: URLSession?) -> Operation {
//        self.url = url
//        self.session = session
//        return self
//    }
    
    func `init`(request: URLRequest?, session: URLSession?) -> Operation {
        self.request = request
        self.session = session
        return self
    }
    
    
    
    func cancel(token: String) {
        if self.fileFinished {
            return
        }
        super.cancel()
        if let task = self.task {
            task.cancel()
            if self.fileExecuting {
                self.fileExecuting = false
            }
            if self.fileFinished {
                self.fileFinished = true
            }
        }
    }
    
    func add(progress: FileDownloadProgressCallback?, complete: FileDownloadCompleteCallback?) {
        var dict = FileCallbackDict()
        self.callbackLock.wait(timeout: .distantFuture)
        if let progress = progress {
            dict[FileCallbackKeyEnum.progress.rawValue] = progress
        }
        if let complete = complete {
            dict[FileCallbackKeyEnum.complete.rawValue] = complete
        }
        self.callbacks.append(dict)
        self.callbackLock.signal()
    }
    
    var dataTask: URLSessionDownloadTask? {
        get {
            return self.task
        }
    }
    
    func synced(_ lock: Any, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
}


//extension FileDownloadOperation: URLSessionDataDelegate {
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
//        var disposition = URLSession.ResponseDisposition.allow
//        var expected = response.expectedContentLength
//        self.expectedSize = expected
//        if self.fileData == nil {
//            self.fileData = Data.init(capacity: Int(expected))
//        }
//        expected = expected > 0 ? expected : 0
//        self.response = response
//        var code = 200
//        if let response = response as? HTTPURLResponse {
//            code = response.statusCode
//        }
//        if code < 400, code != 304 {
//            for progress in self.callbacks(for: FileCallbackKeyEnum.progress.rawValue) {
//                if let progress = progress as? FileDownloadProgressCallback, let url = self.request?.url {
//                    progress(0, expected, url)
//                }
//            }
//        } else {
//            disposition = URLSession.ResponseDisposition.cancel
//        }
//        completionHandler(disposition)
//
//    }
//
//
//    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
//        if let fileData = self.fileData {
//            self.fileData?.append(data)
//        }
//        for progress in self.callbacks(for: FileCallbackKeyEnum.progress.rawValue) {
//            if let progress = progress as? FileDownloadProgressCallback, let url = self.request?.url {
//                progress(Int64(self.fileData?.count ?? 0), self.expectedSize, url)
//            }
//        }
//        for complete in self.callbacks(for: FileCallbackKeyEnum.complete.rawValue) {
//            if let complete = complete as? FileDownloadCompleteCallback, let url = self.request?.url {
//                progress(Int64(self.fileData?.count ?? 0), self.expectedSize, url)
//                complete()
//            }
//        }
//    }
//
//    private func callbacks(for key: String) -> [Any] {
//        var callbacks: [Any] = []
//        self.callbackLock.wait(timeout: .distantFuture)
//        callbacks = self.callbacks.map({ (obj) -> Any in
//            return obj[key]
//        })
//        self.callbackLock.signal()
//        return callbacks
//
//    }
//}


extension FileDownloadOperation: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let _ = downloadTask.originalRequest?.url?.absoluteString {
            let filePath = location.path
            for complete in self.callbacks(for: FileCallbackKeyEnum.complete.rawValue) {
                if let complete = complete as? FileDownloadCompleteCallback {
                    complete(filePath, nil, true)
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
             if error != nil {
            // 下载时进程杀死，重新启动时回调错误
            if let resumeData = (error as NSError?)?.userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
                self.fileData = resumeData
            }
            for complete in self.callbacks(for: FileCallbackKeyEnum.complete.rawValue) {
                if let complete = complete as? FileDownloadCompleteCallback {
                    complete(nil, error, false)
                }
            }
        }

    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        self.expectedSize = totalBytesExpectedToWrite
//        let progress = 1.0 * Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        for progress in self.callbacks(for: FileCallbackKeyEnum.progress.rawValue) {
            if let progress = progress as? FileDownloadProgressCallback, let url = self.request?.url {
                progress(totalBytesWritten, self.expectedSize, url)
            }
        }
        
    }
    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credntial = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credntial)
        }
        else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
         if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                   let credntial = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                   completionHandler(.useCredential, credntial)
               }
               else {
                   completionHandler(.performDefaultHandling, nil)
               }
    }
    
     private func callbacks(for key: String) -> [Any] {
         var callbacks: [Any] = []
         self.callbackLock.wait(timeout: .distantFuture)
         callbacks = self.callbacks.map({ (obj) -> Any in
             return obj[key]
         })
         self.callbackLock.signal()
         return callbacks
     }
}
