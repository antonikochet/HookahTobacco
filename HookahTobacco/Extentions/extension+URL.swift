//
//  extension+URL.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 20.09.2023.
//

import UIKit
import AVFoundation

extension URL {
    func receivePreviewImage() -> UIImage? {
        if let imageData = try? Data(contentsOf: self),
           let image = UIImage(data: imageData) {
            return image
        }
        let asset = AVURLAsset(url: self)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        if let cgImage = try? generator.copyCGImage(at: CMTime(seconds: 2, preferredTimescale: 60), actualTime: nil) {
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
}
