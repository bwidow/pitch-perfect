//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Benedictus Widodo on 4/4/15.
//  Copyright (c) 2015 Benedictus Widodo. All rights reserved.
//

import Foundation

class RecordedAudio:NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String){
        self.filePathUrl = filePathUrl
        self.title = title
    }
}