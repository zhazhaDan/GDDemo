//
//  SocketViewController.swift
//  GDDemo
//
//  Created by GDD on 2021/8/15.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class SocketViewController: BaseViewController {

    enum SocketMode {
        case server, client
    }
    private var datas: [String] = []
    private var mode: SocketMode = .client
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.addSubview(inputV)
//        view.addSubview(send)
        view.addSubview(server)
        view.addSubview(client)
//        view.addSubview(table)
//        inputV.snp.makeConstraints { make in
//            make.top.equalTo(100)
//            make.height.equalTo(50)
//            make.width.equalTo(200)
//            make.left.equalTo(50)
//        }
//
//        send.snp.makeConstraints { make in
//            make.size.equalTo(CGSize.init(width: 60, height: 30))
//            make.centerY.equalTo(inputV)
//            make.left.equalTo(inputV.snp.right).offset(10)
//        }
        server.snp.makeConstraints { make in
            make.top.equalTo(200)
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        client.snp.makeConstraints { make in
            make.top.equalTo(server.snp.bottom).offset(50)
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }

//        table.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview()
//            make.top.equalTo(client.snp.bottom)
//        }

//        SocketClient.shared.didReceiveMessage = {
//            [weak self] message in
//            guard let self = self else { return }
//            self.datas.append(message)
//            self.table.reloadData()
//        }
    }


//    @objc func sentAction() {
//        if let text = inputV.text {
//            if self.mode == .client {
//                SocketClient.shared.send(message: text)
//            }
//        }
//    }

    @objc func openServer() {
        self.mode = .server
        let vc = ServerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func startClientSocket() {
        self.mode = .client
        let vc = ClientViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    private lazy var server: UIButton = {
        let v = UIButton()
        v.backgroundColor = .black
        v.setTitle("开启socket服务", for: .normal)
        v.addTarget(self, action: #selector(openServer), for: .touchUpInside)
        return v
    }()
    private lazy var client: UIButton = {
        let v = UIButton()
        v.backgroundColor = .gray
        v.setTitle("客户端开始连接", for: .normal)
        v.addTarget(self, action: #selector(startClientSocket), for: .touchUpInside)
        return v
    }()

//    private lazy var send: UIButton = {
//        let v = UIButton()
//        v.backgroundColor = .blue
//        v.setTitle("发送", for: .normal)
//        v.addTarget(self, action: #selector(sentAction), for: .touchUpInside)
//        return v
//    }()
//
//
//    private lazy var inputV: UITextField = {
//        let v = UITextField()
//        v.delegate = self
//        v.borderStyle = .bezel
//        v.backgroundColor = .lightGray
//        return v
//    }()

    private lazy var table: UITableView = {
        let v = UITableView()
        v.delegate = self
        v.dataSource = self
        v.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return v
    }()

}




extension SocketViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.datas[indexPath.row]
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


}
