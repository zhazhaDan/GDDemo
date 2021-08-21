//
//  FileManager.swift
//  GDDemo
//
//  Created by GDD on 2020-07-04.
//  Copyright © 2020 GDD. All rights reserved.
//

import UIKit

class File: NSObject {
    var file: FileInfo?
    var localPath: String?
    var progress: FileDownloadProgressCallback?
    var complete: FileDownloadCompleteCallback?
    var token: FileDownloadToken?
}

struct FileInfo {
    var fileID: Int64?
    var url: String?
}

class FileDownloadManager: NSObject {
    private var downloader = FileDownloader()
    
    func loadFile(url: String, fileID: Int64) -> File {
        let info = FileInfo.init(fileID: fileID, url: url)
        let file = File()
        file.file = info
        file.token = downloader.download(url: URL.init(string: url), fileID: fileID, progress: { (write, total, url) in
            file.progress?(write, total, url)
        }) { (path, error, succ) in
            file.complete?(path, error, succ)
        }
        return file
    }
    
}
