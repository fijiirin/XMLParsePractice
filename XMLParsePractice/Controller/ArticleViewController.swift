//
//  ArticleViewController.swift
//  XMLParsePractice
//
//  Created by 藤井凜 on 2021/08/07.
//

import UIKit

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
  
  
  var tableView = UITableView()
  var parser = XMLParser()
  
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
    //http://canon-its.jp/eset/malware_info/rss/release.xml
    //https://news.yahoo.co.jp/pickup/rss.xml
    let url:URL = URL(string: "http://canon-its.jp/eset/malware_info/rss/release.xml")!
    parser = XMLParser(contentsOf: url)!
    parser.delegate = self
    parser.parse()
    print(parser.parse())
    
    tableView.reloadData()
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
    print(articleItems[indexPath.row])
    cell.configure(articleItem: articleItems[indexPath.row])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let webViewController = WebViewController()
    webViewController.modalTransitionStyle = .crossDissolve
    let articleItem = articleItems[indexPath.row]
    UserDefaults.standard.set(articleItem.url, forKey: "url")
    present(webViewController, animated: true, completion: nil)
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    
    currentElementName = nil
    
    if elementName == "item" {
      
      self.articleItems.append(ArticleItem())
    } else {
      
      currentElementName = elementName
    }
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    
    if self.articleItems.count > 0 {
      
      var lastItem = self.articleItems[self.articleItems.count - 1]
      
      switch self.currentElementName {
      case "title":
        lastItem.title = string
      case "link":
        lastItem.url = string
      case "pubDate":
        lastItem.date = string
      default:
        break
      }
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    
    self.currentElementName = nil //完成後消してみる
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    
    tableView.reloadData()

  }
  
  
  
}
