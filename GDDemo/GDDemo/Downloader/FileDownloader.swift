//
//  FileDownloader.swift
//  GDDemo
//
//  Created by GDD on 2020-07-04.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit


struct FileDownloadToken {
    var url: URL?
    var fileID: Int64?
}

protocol FileDownloaderProtocol {
    func download(url: URL?, fileID: Int64?, progress: FileDownloadProgressCallback?, complete: FileDownloadCompleteCallback?) -> FileDownloadToken?
    func cancel(token: FileDownloadToken)
    func cancelAll()
}

class FileDownloader: NSObject {
    private var downloadOperations: [URL: FileDownloadOperationProtocol] = [:]
    private var operationLock = DispatchSemaphore.init(value: 1)
    private var downloadQueue = OperationQueue()
    private var session: URLSession?
    
    override init() {
        super.init()
        self.downloadQueue.maxConcurrentOperationCount = 6
        self.downloadQueue.name = "com.GDD.fileDownloader"
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.timeoutIntervalForRequest = 15
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: "com.GDD.Art.Download")

        self.session = URLSession.init(configuration: sessionConfig, delegate: self, delegateQueue: nil)
    }
}

extension FileDownloader: FileDownloaderProtocol {
    func cancel(token: FileDownloadToken) {
        if let url = token.url {
            self.operationLock.wait(timeout: .distantFuture)
            if let operation = self.downloadOperations[url] {
                operation.cancel(token: "\(token.fileID)")
            }
            self.downloadOperations.removeValue(forKey: url)
            self.operationLock.signal()
        }
    }
    
    func cancelAll() {
        self.downloadQueue.cancelAllOperations()
    }
    
    func download(url: URL?, fileID: Int64?, progress: FileDownloadProgressCallback?, complete: FileDownloadCompleteCallback?) -> FileDownloadToken? {
        guard let url = url else {
            complete?(nil, nil, false)
            return nil
        }
        self.operationLock.wait(timeout: .distantFuture)
        if let operation = self.downloadOperations[url] as? Operation,  !operation.isCancelled, let op = operation as? FileDownloadOperationProtocol {
            op.dataTask?.resume()
        } else {
            let operation = self.crerateOperation(url: url)
            operation.completionBlock = {[weak self] in
                guard let self = self else {return}
                self.operationLock.wait(timeout: .distantFuture)
                self.downloadOperations.removeValue(forKey: url)
                self.operationLock.signal()
            }
            if let operation = operation as? FileDownloadOperationProtocol {
                self.downloadOperations[url] = operation
            }
            if let op = operation as? FileDownloadOperationProtocol {
                op.add(progress: progress, complete: complete)
            }
            self.downloadQueue.addOperation(operation)
        }
        
        self.operationLock.signal()

        let token = FileDownloadToken.init(url: url, fileID: fileID)
        return token
    }
}

extension FileDownloader {
    private func crerateOperation(url: URL) -> Operation {
        let request = URLRequest.init(url: url, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 60)
//        let operation = FileDownloadOperation().`init`(url: url, session: self.session)
        let operation = FileDownloadOperation().`init`(request: request, session: self.session)

        return operation
    }
    
    private func operation(task: URLSessionTask) -> Operation {
        var findOperation: FileDownloadOperationProtocol? = nil
        for op in self.downloadQueue.operations {
            if let op = op as? FileDownloadOperationProtocol, op.dataTask?.taskIdentifier == task.taskIdentifier {
                findOperation = op
            }
        }
        return findOperation as! Operation
    }
}


extension FileDownloader: URLSessionDataDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let findOperation = operation(task: downloadTask) as? FileDownloadOperationProtocol {
            findOperation.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
        }
    }
        
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let findOperation = operation(task: task) as? FileDownloadOperationProtocol {
            findOperation.urlSession(session, task: task, didCompleteWithError: error)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let findOperation = operation(task: downloadTask) as? FileDownloadOperationProtocol {
            findOperation.urlSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//        if let findOperation = operation(task: task) as? FileDownloadOperationProtocol {
//            findOperation.urlSession(session, task: task, didReceive: challenge, completionHandler: completionHandler)
//        } else {
            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
//        }
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
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
    }
}
