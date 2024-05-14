//
//  ShareableImage.swift
//  AuthorizationApp
//
//  Created by Yuliya on 14/05/2024.
//

import LinkPresentation
import UIKit
import Social

class ShareableImage: NSObject, UIActivityItemSource {
    private let image: UIImage
    private let title: String
    
    init(image: UIImage, title: String) {
        self.image = image
        self.title = title
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .postToFacebook {
            return image.jpegData(compressionQuality: 0.8)
        } else if activityType == .postToTwitter {
            return image.pngData()
        } else {
            return image
        }
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, dataTypeIdentifierForActivityType activityType: UIActivity.ActivityType?) -> String {
        if activityType == .postToFacebook {
            return "public.jpeg"
        } else if activityType == .postToTwitter {
            return "public.png"
        } else {
            return "public.data"
        }
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        
        metadata.iconProvider = NSItemProvider(object: image)
        metadata.title = title
        
        return metadata
    }
}
