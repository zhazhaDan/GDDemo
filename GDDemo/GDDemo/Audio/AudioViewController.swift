//
//  AudioViewController.swift
//  GDDemo
//
//  Created by GDD on 2020-06-13.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: BaseViewController {

    var recordPath = ""
    var recorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bindView() {
        let startBtn = UIButton.init(frame: CGRect.init(x: 100, y: 200, width: 100, height: 100))
        startBtn.layer.cornerRadius = 50
        startBtn.layer.masksToBounds = true
        startBtn.backgroundColor = UIColor.red
        view.addSubview(startBtn)
        startBtn.setTitle("录制", for: .normal)
        startBtn.setTitle("停止录制", for: .selected)
        startBtn.addTarget(self, action: #selector(startRecord(_:)), for: .touchUpInside)
//        startBtn.addTarget(self, action: #selector(stopRecord), for: .touchCancel)
        startBtn.centerX = self.view.centerX
        
        let playBtn = UIButton.init(frame: CGRect.init(x: 150, y: 350, width: 50, height: 50))
        playBtn.layer.cornerRadius = 25
        playBtn.layer.masksToBounds = true
        playBtn.backgroundColor = UIColor.brown
        view.addSubview(playBtn)
        playBtn.setTitle("播放", for: .normal)
        playBtn.setTitle("暂停", for: .selected)
        playBtn.addTarget(self, action: #selector(playRecord(_:)), for: .touchUpInside)
        playBtn.centerX = self.view.centerX
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChange(_:)) , name:Notification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification") , object: nil)

    }
    
    
    @objc func startRecord(_ sender: UIButton) {
        if sender.isSelected  {
            stopRecord(sender)
            return
        }
        sender.isSelected = true
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)

        } catch {
            print("audioSession fail" + error.localizedDescription)
        }

        let fileName = "/test_voice.caf"
        recordPath =  NSHomeDirectory() + "/Documents" + fileName
        print(recordPath)
        let recordFile = NSURL(fileURLWithPath: recordPath)
        do {
            try recorder = AVAudioRecorder.init(url: recordFile as URL, settings: self.audioSetting() as! [String : Any])
        } catch {
            print("recorder fail" + error.localizedDescription)
        }
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        recorder.record(forDuration: 0)
    }
    
    @objc func stopRecord(_ sender: UIButton) {
        sender.isSelected = false
        recorder.stop()
        if audioPlayer != nil {
            audioPlayer.stop()
        }
    }
    
    
    @objc func playRecord(_ sender: UIButton) {
        if sender.isSelected {
            stopRecord(sender)
            return
        }
        sender.isSelected = true
        do {
            let audioData = try Data.init(contentsOf: URL.init(fileURLWithPath: self.recordPath))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            audioPlayer = try AVAudioPlayer.init(data: audioData)
        } catch {}

        UIDevice.current.isProximityMonitoringEnabled = true
        audioPlayer.volume = 1
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @objc func volumeChange(_ notif: NotificationCenter) {
        
    }
    
    
    private func audioSetting() -> NSDictionary {
        return [AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 8000,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16
        ]
    }
    

    
}

extension AudioViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
    
}
