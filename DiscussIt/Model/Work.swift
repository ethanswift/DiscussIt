//
//  Work.swift
//  DiscussIt
//
//  Created by ehsan sat on 3/3/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import Foundation


class Work {
    
    var title: String = ""
    var doi: String = ""
    var type: String = ""
    var publisher: String = ""
    var author: String = ""
    var containerTitle: String = ""
    var page: String = ""
    var issued: String = ""
    var url: String = ""
    
    init(title: String, type: String, issued: String, containerTitle: String, page: String, publisher: String, author: String, doi: String, url: String ) {
        self.title = title
        self.type = type
        self.issued = issued
        self.containerTitle = containerTitle
        self.page = page
        self.publisher = publisher
        self.author = author
        self.doi = doi
        self.url = url
    }
    
    init () {
        self.title = ""
        self.type = ""
        self.issued = ""
        self.containerTitle = ""
        self.page = ""
        self.publisher = ""
        self.author = ""
        self.doi = ""
        self.url = ""
    }
    
}
