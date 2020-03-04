//
//  SAMLConfig.swift
//  edX
//
//  Created by andrey.canon on 10/10/18.
//  Copyright © 2018 edX. All rights reserved.
//

fileprivate enum SamlKeys: String, RawStringExtractable {
    case Enabled = "ENABLED"
    case SamlIdpSlug = "SAML_IDP_SLUG"
    case SamlName = "NAME"
}
@objc class SamlProviderConfig: NSObject {
    @objc var enabled: Bool = false
    @objc var samlIdpSlug: String = ""
    @objc var samlName = ""
    @objc init(dictionary: [String: AnyObject]) {
        enabled = dictionary[SamlKeys.Enabled] as? Bool ?? false
        samlIdpSlug = dictionary[SamlKeys.SamlIdpSlug] as? String ?? ""
        samlName = dictionary[SamlKeys.SamlName] as? String ?? ""
    }
}
private let key = "SAML"
extension OEXConfig {
    @objc var samlProviderConfig: SamlProviderConfig {
        return SamlProviderConfig(dictionary: self[key] as? [String:AnyObject] ?? [:])
    }
}
