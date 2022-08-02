//
//  PageData.swift
//  SWUIMCTwo
//
//  Created by Mohan Chaudhari on 02/08/22.
//

import Foundation


struct Page: Identifiable {
    let id: Int
    let imageName: String
}


let pagesData: [Page] = [
    Page(id: 1, imageName: "magazine-front-cover"),
    Page(id: 2, imageName: "magazine-back-cover")
]
