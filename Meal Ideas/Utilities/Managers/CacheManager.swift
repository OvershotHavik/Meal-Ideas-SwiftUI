//
//  CacheManager.swift
//  Meal Ideas
//
//  Created by Steve Plavetzky on 2/5/22.
//

import SwiftUI

class CacheManager{
    //For core data images in user meals meal card
    static let shared = CacheManager()
    private init(){}// prevents the CacheManager from being duplicated
    private let cache : NSCache<NSData, UIImage> = {
        let cache = NSCache<NSData, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100 // about 100mb
        return cache
    }()
    
    func returnImageFromData(photoData: Data, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSData(data: photoData)
        
        if let image = cache.object(forKey: cacheKey){
            completion(image)
            print("image in cache")
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = UIImage(data: photoData){
                self.cache.setObject(image, forKey: photoData as NSData)
                completion(image)
            }
        }
    }
}
