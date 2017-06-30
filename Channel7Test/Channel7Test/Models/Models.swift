//
//  Models.swift
//  Channel7Test
//
//  Created by Noble Mathew on 30/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import Foundation


struct Channel {
  var channedID: Int?
  var channelName: String?
  var displayOrder: Int?
}

struct ChannelDetails {
  var programID: Int?
  var programTitle: String?
  var programSynopsis: String?
  var programStartTime: String?
  var programEndTime: String?
  var programImageURL: String?
}
