//
//  Extensions.swift
//  edX
//
//  Created by Nathan Gurfinkel on 14/11/2020.
//  Copyright © 2020 edX. All rights reserved.
//

import Foundation

extension String {
    func isRTL() -> Bool {
        if !self.isEmpty {
            let tagschemes = NSArray(objects: NSLinguisticTagScheme.language)
            let tagger = NSLinguisticTagger(tagSchemes: tagschemes as! [NSLinguisticTagScheme], options: 0)
            tagger.string = self
            
            let language = tagger.tag(at: 0, scheme: NSLinguisticTagScheme.language, tokenRange: nil, sentenceRange: nil)
            if String(describing: language).range(of: "he") != nil || String(describing: language).range(of: "ar") != nil || String(describing: language).range(of: "fa") != nil {
                return true
            } else{
                return false
            }
        } else {
            return false
        }
    }
}
