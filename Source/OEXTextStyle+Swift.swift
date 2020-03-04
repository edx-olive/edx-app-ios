//
//  OEXTextStyle+Swift.swift
//  edX
//
//  Created by Michael Katz on 5/17/16.
//  Copyright © 2016 edX. All rights reserved.
//

import Foundation

class OEXTextStyleWithShadow: OEXTextStyle {
    var shadow: ShadowStyle?

    override var attributes: [NSAttributedString.Key : Any] {
        var attr = super.attributes
        if let shadowStyle = shadow {
            attr[NSAttributedStringKey.shadow] = shadowStyle.shadow
        }
        return attr as [NSAttributedString.Key : AnyObject]
    }
    
}
