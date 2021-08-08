//
//  NewsViewController.swift
//  XMLParsePractice
//
//  Created by 藤井凜 on 2021/08/07.
//

import UIKit

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
  
  
  var tableView = UITableView()
  var parser = XMLParser()
  var loadParseDataModel = LoadParseDataModel()
  
  var currentElementName:String!
  
  var articleItems = [ArticleItem]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.frame = view.bounds
    tableView.backgroundColor = .clear
    tableView.register(ArticleCell.nib(), forCellReuseIdentifier: ArticleCell.identifier)
    view.addSubview(tableView)
    
    //XMLパース
    loadParseDataModel.xmlLoadData(urlString: "http://canon-its.jp/eset/malware_info/rss/release.xml")
    parser.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.isNavigationBarHidden = true
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articleItems.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier, for: indexPath) as! ArticleCell
    cell.configure(articleItem: articleItems[indexPath.row])
    
    return cell
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    
    currentElementName = nil
    
    if elementName == "" {
      
      self.articleItems.append(ArticleItem())
    } else {
      
      currentElementName = elementName
    }
  }
  
  
  
}
