//
//  Extensions.swift
//  Rumpel
//
//  Created by Harel Avikasis on 02/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImageView
{
    static let transition = UIImageView.ImageTransition.crossDissolve(0.20)

    class func setImage(imageView: UIImageView, url: URL,  placeholder: UIImage?){
        imageView.af_setImage(withURL: url, placeholderImage: placeholder, filter: nil, progress: { (progress) in
            
        }, progressQueue: DispatchQueue.main, imageTransition: transition, runImageTransitionIfCached: false) { (image) in
            
        }
    }
}

extension String {
    func language() -> String? {
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagSchemeLanguage], options: 0)
        tagger.string = self
        return tagger.tag(at: 0, scheme: NSLinguisticTagSchemeLanguage, tokenRange: nil, sentenceRange: nil)
    }
}
