//
//  SocketServer.swift
//  GDDemo
//
//  Created by GDD on 2021/8/15.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

let SocketTag = 0
class SocketServer: NSObject {
    static let shared = SocketServer()
    private lazy var socket: GCDAsyncSocket? = {
        let v = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
        v.autoDisconnectOnClosedReadStream = true
        return v
    }()
    private var client: GCDAsyncSocket?

    private var head: NSDictionary?
    var addInfo: ((String) -> Void)?

    var receiveImage: ((UIImage) -> Void)?

    func startServer(port: String) {
        do {
            try self.socket?.accept(onPort: UInt16(port)!)
            addInfo?("server listen success")

        } catch {
            addInfo?("server error \(error.localizedDescription)")
        }
    }

    func disConnectServer() {
        self.socket?.disconnect()
        self.socket = nil
    }

    func send(message: String) {
        if let data = message.data(using: .utf8) {
            client?.write(data, withTimeout: -1, tag: SocketTag)
        }
    }
}


extension SocketServer: GCDAsyncSocketDelegate {

    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        addInfo?("收到的新的客户端连接")
        addInfo?("连接地址 \(newSocket.connectedHost ?? "") 连接端口 \(newSocket.connectedPort)")
        client = newSocket
        self.head = nil
        newSocket.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: SocketTag)
    }

    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        addInfo?(err?.localizedDescription ?? "断开链接")
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {

        if let head = self.head {
            if let type = head["type"] as? String {
                if type == "text", let message = String.init(data: data, encoding: .utf8) {
                    addInfo?(message)
                } else if type == "image", let message = UIImage.init(data: data) {
                    receiveImage?(message)
                }
            }
            self.head = nil
            sock.readData(to: GCDAsyncSocket.crlfData(), withTimeout: -1, tag: SocketTag)
        } else if let dict = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary {
            self.head = dict
            if let lenght = dict["size"] as? String, let count = UInt(lenght) {
                sock.readData(toLength: count, withTimeout: -1, tag: SocketTag)
            }
        }

    }
}
