//
//  ParseDataModel.swift
//  XMLParsePractice
//
//  Created by 藤井凜 on 2021/08/08.
//

import Foundation


class LoadParseDataModel {
  
  var parser = XMLParser()
  
  func xmlLoadData(urlString:String) {
    
    let url:URL = URL(string: urlString)!
    parser = XMLParser(contentsOf: url)!
    
    
    parser.parse()
  }
}
