//
//  Artist.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

struct Artist {
  let name: String
  let artistId: String
  let instruments: [String]
    let tags: [String]
  let city: String
}
extension Artist {
  init(_ dictionary: [String: Any]) {
    self.name = dictionary["name"] as? String ?? "No Artist"
    self.artistId = dictionary["artistId"] as? String ?? UUID().uuidString
    self.instruments = dictionary["instrument"] as? [String] ?? ["no instrument"]
    self.tags = dictionary["tags"] as? [String] ?? ["no tags"]
    self.city = dictionary["city"] as? String ?? "No City selected"
  }
}