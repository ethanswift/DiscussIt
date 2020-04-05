//
//  SearchViewController.swift
//  DiscussIt
//
//  Created by ehsan sat on 3/1/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    var urlEnd = ""
    
    var workArray: [Work] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        self.tabBarController?.tabBar.shadowImage = UIImage()
        self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 0.9262443185, green: 0.9611316323, blue: 0.9974778295, alpha: 1)
//        self.tabBarController?.
//        UITabBarItem.appearance().setTitleTextAttributes([:], for: .normal)
//        self.tabBarController?.tabBar.
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9365637898, green: 0.9386104941, blue: 0.956056416, alpha: 1)
        self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        let barHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.size.height ?? 0.0)
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.white
        searchLabel.frame = CGRect(x: 0 , y: barHeight, width: self.view.bounds.width, height: self.view.bounds.height / 2 - (barHeight + 28))
        searchLabel.clipsToBounds = true
        searchLabel.layer.cornerRadius = 20
        searchLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        // Do any additional setup after loading the view.
    }
    
    // MARK: - search bar delegate methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search bar text: \(searchBar.text ?? "no value")")
        DispatchQueue.main.async {
            self.searchAPI(text: searchBar.text!)
        }
    }
    
    // MARK: - retrieve data from api
    
    func searchAPI (text: String) {
  
        let url = produceURL(text: text)
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil || data == nil {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Internet Connection Failed", message: "Your Internet Connection Was Failed, Please Try Again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                print("Client error" , error?.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server Error!")
                return
            }
            
            do {
                guard let json = try? JSON(data: data!) else {return}
                let items = json["message"]["items"].arrayValue
                for item in items {
                    let title = item["title"][0].string
                    let type = item["type"].string
                    let issued = item["issued"]["date-parts"][0].arrayValue
                    let issuedDate = issued.map{$0.stringValue}.joined(separator: " ")
                    let containerTitle = item["container-title"][0].string
                    let page = item["page"].string
                    let publisher = item["publisher"].string
                    let authors = item["author"].arrayValue
                    var authorRes: [String] = []
                    for author in authors {
                    let newAuthor = author["given"].stringValue + " " + author["family"].stringValue
                    authorRes.append(newAuthor)
                    }
                    let authorsFin = authorRes.joined(separator: " ")
                    let doi = item["DOI"].string
                    let url = item["URL"].string
                    let newWork = Work(title: title ?? "----------", type: type ?? "----------", issued: issuedDate , containerTitle: containerTitle ?? "----------", page: page ?? "----------", publisher: publisher ?? "----------", author: authorsFin , doi: doi ?? "----------", url: url ?? "----------")
                    self.workArray.append(newWork)
                    }
                    DispatchQueue.main.async {
                        if error == nil && data != nil {
                            self.performSegue(withIdentifier: "goToResults", sender: self)
                        }
                    }
            } catch {
                print("error: ", error)
            }
        }
        task.resume()
    }
    
    func produceURL (text: String) -> String {
        
        let components = text.components(separatedBy: .whitespacesAndNewlines)
        if components.count > 1 {
            for str in components {
                urlEnd += "\(str)+"
            }
            if urlEnd.last == "+" {
                urlEnd.removeLast()
            }
            print(urlEnd)
            return "https://api.crossref.org/works?query=\(urlEnd)&select=DOI,title,type,author,page,URL,ISBN,issued,publisher,container-title&rows=1000"
            } else {
            return "https://api.crossref.org/works?query=\(components[0])&select=DOI,title,type,author,page,URL,ISBN,issued,publisher,container-title&rows=1000"
            }
    }

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let vc = segue.destination as? ResultsTableViewController
            vc?.resultsArray = workArray
        }
     } 
}
