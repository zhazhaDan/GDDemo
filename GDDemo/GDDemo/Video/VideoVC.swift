//
//  VideoVC.swift
//  GDDemo
//
//  Created by GDD on 2020/12/3.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AliyunPlayer

class VideoVC: BaseViewController {
//    var playerViewController = AVPlayerViewController()
//
//    var playerView = AVPlayer()



    override func viewDidLoad() {
        super.viewDidLoad()


        let btn = UIButton.init(frame: CGRect.init(x: 20, y: 100, width: 80, height: 35))
        btn.backgroundColor = .yellow
        btn.setTitle("播放", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        self.view.addSubview(btn)

        let sysbtn = UIButton.init(frame: CGRect.init(x: 170, y: 100, width: 110, height: 35))
        sysbtn.backgroundColor = .brown
        sysbtn.setTitle("系统播放器", for: .normal)
        sysbtn.setTitleColor(.white, for: .normal)
        sysbtn.addTarget(self, action: #selector(sysPlayVideo), for: .touchUpInside)
        self.view.addSubview(sysbtn)

        let volbtn = UIButton.init(frame: CGRect.init(x: self.view.width - 100, y: 100, width: 80, height: 44))
        volbtn.backgroundColor = .green
        volbtn.setTitle("音量", for: .normal)
        volbtn.setTitleColor(.white, for: .normal)
        volbtn.addTarget(self, action: #selector(volAction), for: .touchUpInside)
        self.view.addSubview(volbtn)


        playerView.frame = CGRect.init(x: 0, y: 200, width: self.view.width, height: self.view.height - 200)
        self.view.addSubview(playerView)
        let fileURL = NSURL(string: "https://vod01.artproglobal.com/sv/53bfa2b-175fee7aa31/53bfa2b-175fee7aa31.mp4")
        prepare(fileURL as URL?)
    }
    

    @objc private func volAction() {
        player.isMuted.toggle()
    }

    @objc private func sysPlayVideo() {
        let fileURL = NSURL(string: "https://vod01.artproglobal.com/sv/53bfa2b-175fee7aa31/53bfa2b-175fee7aa31.mp4")
        let playerView = AVPlayer(url: fileURL! as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = playerView
        playerViewController.player?.isMuted = true
        self.present(playerViewController, animated: true)
        playerViewController.player?.play()

    }

    @objc private func playVideo() {


        player.start()

    }


    func prepare(_ url: URL?) {
        guard let url = url else { return }
        let source = AVPUrlSource().url(with: url.absoluteString)
        player.setUrlSource(source)
        player.prepare()
    }

    lazy var player: AliPlayer = {
        let obj = AliPlayer()!
        obj.rate = 1
        obj.scalingMode = AVP_SCALINGMODE_SCALEASPECTFIT
        obj.playerView = playerView
        obj.isMuted = true
//        obj.volume = 0
        obj.isAutoPlay = true
        return obj
    }()

    lazy var playerView: UIView = {
        let obj = UIView()
        return obj
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
