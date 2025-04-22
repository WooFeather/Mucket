//
//  CrashTestViewController.swift
//  Mucket
//
//  Created by 조우현 on 4/22/25.
//

import UIKit

class CrashTestViewController: UIViewController {

    override func viewDidLoad() {
      super.viewDidLoad()

      let button = UIButton(type: .roundedRect)
      button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
      button.setTitle("Test Crash", for: [])
      button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
      view.addSubview(button)
  }

  @IBAction func crashButtonTapped(_ sender: AnyObject) {
      fatalError()
  }
}
