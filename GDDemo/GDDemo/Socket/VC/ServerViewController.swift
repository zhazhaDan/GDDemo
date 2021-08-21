//
//  ServerViewController.swift
//  GDDemo
//
//  Created by GDD on 2021/8/15.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class ServerViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        [portTF, msgTF, infoTV, sendBtn, listenBtn, imageV].forEach({ view.addSubview($0) })
        portTF.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(100)
            make.height.equalTo(44)
        }

        listenBtn.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.width.equalTo(70)
            make.left.equalTo(portTF.snp.right).offset(10)
            make.height.centerY.equalTo(portTF)
        }

        msgTF.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(portTF.snp.bottom).offset(10)
            make.height.equalTo(44)
        }

        sendBtn.snp.makeConstraints { make in
            make.right.width.equalTo(listenBtn)
            make.left.equalTo(msgTF.snp.right).offset(10)
            make.height.centerY.equalTo(msgTF)
        }

        infoTV.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(listenBtn)
            make.top.equalTo(msgTF.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }

        imageV.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(infoTV)
            make.height.equalTo(200)
        }

        SocketServer.shared.addInfo = {
            [weak self] info in
            guard let self = self else { return }
            self.addInfo(info: info)
        }

        SocketServer.shared.receiveImage = {
            [weak self] info in
            guard let self = self else { return }
            self.imageV.image = info
            self.imageV.isHidden = false
        }
    }
    


    func addInfo(info: String) {
        infoTV.text = infoTV.text.appending("\(info)\n")
    }


    @objc func listenAction() {
        if let text = portTF.text {
            SocketServer.shared.startServer(port: text)
            addInfo(info: "local ip: " + self.getAddress())
        }
    }

    @objc func sendAction() {
        if let text = msgTF.text {
            SocketServer.shared.send(message: text)
        }
    }


    private func getAddress() -> String {
        var addresses = [String]()
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first ?? "0.0.0.0"
    }

    private lazy var sendBtn: UIButton = {
        let v = UIButton()
        v.backgroundColor = .blue
        v.setTitle("发送", for: .normal)
        v.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        return v
    }()


    private lazy var portTF: UITextField = {
        let v = UITextField()
        v.borderStyle = .bezel
        v.backgroundColor = .lightGray
        return v
    }()
    private lazy var listenBtn: UIButton = {
        let v = UIButton()
        v.backgroundColor = .blue
        v.setTitle("监听", for: .normal)
        v.addTarget(self, action: #selector(listenAction), for: .touchUpInside)
        return v
    }()


    private lazy var msgTF: UITextField = {
        let v = UITextField()
        v.borderStyle = .bezel
        v.backgroundColor = .lightGray
        return v
    }()

    private lazy var infoTV: UITextView = {
        let v = UITextView()
        v.backgroundColor = .lightGray
        return v
    }()

    private lazy var imageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.isHidden = true
        return v
    }()
}
