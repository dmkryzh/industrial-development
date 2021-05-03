//
//  PhotosViewModel.swift
//  Navigation
//
//  Created by Dmitrii KRY on 02.05.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModelViewDelegate {
    func updateView()
    
}

protocol ViewModelInputDelegate {
    func onTap()
}

class PhotosViewModel: NSObject {
    
    class TestResult {
        var property: String
        init(property: String) {
            self.property = property
        }
    }
    
    var date = Date()
    
    var timer: Timer?
    
    var currentTime: String?
    
    var photos: [Photo]
    
    var numberOfSections: Int
    
    var numberOfItems: Int
    
    var collectionIdentifier: String
    
    func testResult(completion: (Result<TestResult, AppErrors>) -> Void) {
        if let _ = timer {
            completion(.success(TestResult(property: "Result OK")))
        } else {
            completion(.failure(AppErrors.internalError))
        }
    }
 
    func timerString(propagateTo: inout String?) {
        
        let time = Date().timeIntervalSince(date)
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        var times: [String] = []
        if hours > 0 {
            times.append("\(hours)h")
        }
        if minutes > 0 {
            times.append("\(minutes)m")
        }
        times.append("\(seconds)s")
        
        propagateTo = times.joined(separator: " ")
        
    }
    
    func toUpdatekWithTimeInterval ( timeInterval: TimeInterval, closure: @escaping ()->Void ) {
        
        testResult() { result in
              switch result {
              case .success(let test):
                  print(test.property)
              case .failure(let error):
                  print(error.rawValue)
              }
          }
        
        if timer == nil {
            date = Date()
            timer = Timer(timeInterval: timeInterval, repeats: true) {  _ in
                closure()
            }
            RunLoop.current.add(timer!, forMode: .common)
            
        } else {
            timer!.invalidate()
            timer = nil
        }

    }
    
    init(numberOfSections: Int, collectionIdentifier: String, photoSet: [Photo]) {
        photos = photoSet
        self.numberOfSections = numberOfSections
        self.numberOfItems = photos.count
        self.collectionIdentifier = collectionIdentifier
    }
    
}

extension PhotosViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       self.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = photos[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.collectionIdentifier, for: indexPath) as! PhotosCollectionViewCell
        cell.imageItem = photo
        return cell
    }
    
}

extension PhotosViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 8 * 4) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
}

