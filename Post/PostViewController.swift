//
//  PostViewController.swift
//  Navigation
//
//  Created by Artem Novichkov on 12.09.2020.
//

import UIKit

class PostViewController: UIViewController {
    
    var post: Post?  {
        didSet {
            title = post?.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
