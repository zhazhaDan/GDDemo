//
//  SocketTanster.swift
//  GDDemo
//
//  Created by GDD on 2021/8/15.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit
import CocoaAsyncSocket


class SocketClient: NSObject {
    var didReceiveMessage: ((String) -> Void)?
    var addInfo: ((String) -> Void)?
    var tag = 0

    private lazy var socket: GCDAsyncSocket? = {
        let v = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
        v.autoDisconnectOnClosedReadStream = true

        return v
    }()

    func startConnect(host: String, port: String) {
        do {
            try self.socket?.connect(toHost: host, onPort: UInt16(port) ?? 0)
            addInfo?("client connect success")
        } catch {
            addInfo?("client error \(error.localizedDescription)")
        }
    }

    func disConnect() {
        self.socket?.disconnect()
        self.socket = nil
        addInfo?("disconnect")
    }

    func send(message: String) {
        let data = message.data(using: .utf8)
        self.send(data: data, type: "text")
    }
    func send(image: UIImage) {
        let data = image.pngData()
        self.send(data: data, type: "image")
    }

    func send(data: Data?, type: String) {
        guard let data = data else { return }
        let size = data.count
        let dict: NSDictionary = ["size": "\(size)", "type": type]
        var jsonData = dict.json()?.data(using: .utf8)

        jsonData?.append(GCDAsyncSocket.crlfData())
        jsonData?.append(data)

        socket?.write(jsonData, withTimeout: -1, tag: tag)

    }
}


extension SocketClient: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        self.socket?.readData(withTimeout: -1, tag: tag)
        addInfo?("did connect to host \(host) port \(port)")

    }

    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("error is \(err?.localizedDescription ?? "")")
        self.disConnect()
    }

    func socket(_ sock: GCDAsyncSocket, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        self.socket?.readData(withTimeout: -1, tag: tag)
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        if let message = String.init(data: data, encoding: .utf8) {
            self.didReceiveMessage?(message)
            addInfo?("did receive message is \(message)")
        } else {
            addInfo?("did receive message is Null")
        }
        sock.readData(withTimeout: -1, tag: 0)
    }


    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        addInfo?("消息发送成功 tag is \(tag)")
    }
}


extension NSDictionary {
    func json() -> String? {
        var result: Data
        do {
            try result = JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String.init(data: result, encoding: .utf8)
        } catch {
            print("error")
            return nil
        }
    }
}
