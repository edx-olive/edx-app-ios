//
//  OEXConfig+AppFeatures.swift
//  edX
//
//  Created by Akiva Leffert on 3/9/16.
//  Copyright © 2016 edX. All rights reserved.
//

import Foundation

extension OEXConfig {
    @objc var pushNotificationsEnabled : Bool {
        return bool(forKey: "PUSH_NOTIFICATIONS")
    }

    @objc var discussionsEnabled : Bool {
        return bool(forKey: "DISCUSSIONS_ENABLED")
    }
    
    @objc var courseDatesEnabled : Bool {
        return bool(forKey: "COURSE_DATES_ENABLED")
    }

    @objc var certificatesEnabled : Bool {
        return bool(forKey: "CERTIFICATES_ENABLED")
    }

    @objc var profilesEnabled : Bool {
        return bool(forKey: "USER_PROFILES_ENABLED")
    }

    @objc var courseSharingEnabled : Bool {
        return bool(forKey: "COURSE_SHARING_ENABLED")
    }

    @objc var badgesEnabled : Bool {
        return bool(forKey: "BADGES_ENABLED")
    }
    
    @objc var newLogistrationFlowEnabled: Bool {
        return bool(forKey: "NEW_LOGISTRATION_ENABLED")
    }
    
    @objc var discussionsEnabledProfilePictureParam: Bool {
        return bool(forKey: "DISCUSSIONS_ENABLE_PROFILE_PICTURE_PARAM")
    }
    
    @objc var isRegistrationEnabled: Bool {
        // By default registration is enabled
        return bool(forKey: "REGISTRATION_ENABLED", defaultValue: true)
    }
        
    @objc var isVideoTranscriptEnabled : Bool {
        return bool(forKey: "VIDEO_TRANSCRIPT_ENABLED")
    }
    
    @objc var isAppReviewsEnabled : Bool {
        return bool(forKey: "APP_REVIEWS_ENABLED")
    }
    
    @objc var isWhatsNewEnabled: Bool {
        return bool(forKey: "WHATS_NEW_ENABLED")
    }
    
    @objc var isCourseVideosEnabled: Bool {
        // By default course videos are enabled
        return bool(forKey: "COURSE_VIDEOS_ENABLED", defaultValue: true)
    }
    
    @objc var isUsingVideoPipeline: Bool {
        // By default using video pipeline is enabled
        return bool(forKey: "USING_VIDEO_PIPELINE", defaultValue: true)
    }
  
    @objc var isAnnouncementsEnabled: Bool {
        return bool(forKey: "ANNOUNCEMENTS_ENABLED")
    }
}
