//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        // Register the custom cell (if needed manually)
        // tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        
        // Set row height (optional if you're not using automatic)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        // Pull to refresh
        refreshControl.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        fetchPosts()
    }
    
    @objc func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data")
                return
            }
            
            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                DispatchQueue.main.async {
                    self.posts = blog.response.posts
                    self.tableView.reloadData()
                }
            } catch {
                print("❌ JSON decode error: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        
        cell.summaryLabel.text = post.summary
        
        if let photo = post.photos.first {
            let request = ImageRequest(url: photo.originalSize.url)
            ImagePipeline.shared.loadImage(with: request) { result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                            cell.postImageView.image = response.image
                        }
                    }
                case .failure(let error):
                    print("❌ Failed to load image: \(error)")
                    DispatchQueue.main.async {
                        cell.postImageView.image = nil
                    }
                }
            }
        } else {
            cell.postImageView.image = nil
        }
        
        return cell
    }
}

