//
//  ClientViewController.swift
//  GDDemo
//
//  Created by GDD on 2021/8/15.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class ClientViewController: BaseViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        [portTF, ipTF, msgTF, infoTV, sendBtn, listenBtn].forEach({ view.addSubview($0) })
        ipTF.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(100)
            make.height.equalTo(44)
        }
        portTF.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(ipTF.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        listenBtn.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.width.equalTo(120)
            make.left.equalTo(portTF.snp.right).offset(10)
            make.height.centerY.equalTo(portTF)
        }

        msgTF.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(portTF.snp.bottom).offset(10)
            make.height.equalTo(44)
        }

        sendBtn.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.width.equalTo(70)
            make.left.equalTo(msgTF.snp.right).offset(10)
            make.height.centerY.equalTo(msgTF)
        }

        infoTV.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(msgTF.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }


        client.addInfo = {
            [weak self] info in
            guard let self = self else { return }
            self.addInfo(info: info)
        }

    }


    func addInfo(info: String) {
        infoTV.text = infoTV.text.appending("\(info)\n")
    }


    @objc func listenAction() {
        listenBtn.isSelected.toggle()
        if listenBtn.isSelected {
            client.startConnect(host: ipTF.text ?? "", port: portTF.text ?? "")
        } else {
            client.disConnect()
        }
    }

    @objc func sendAction() {
        if let text = msgTF.text {
            client.send(message: text)
            client.send(message: "1")
            client.send(message: "2")
            client.send(message: "3")
            client.send(message: "4")
            client.send(message: "5")
            client.send(image: UIImage.init(named: "socket_image")!)
        }
    }


    private lazy var sendBtn: UIButton = {
        let v = UIButton()
        v.backgroundColor = .blue
        v.setTitle("发送", for: .normal)
        v.addTarget(self, action: #selector(sendAction), for: .touchUpInside)
        return v
    }()

    private lazy var ipTF: UITextField = {
        let v = UITextField()
        v.borderStyle = .bezel
        v.backgroundColor = .lightGray
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
        v.setTitle("建立连接", for: .normal)
        v.setTitle("断开连接", for: .selected)
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

    private var client = SocketClient()
}
