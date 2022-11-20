//
//  ViewController.swift
//  BikeReco
//
//  Created by Dawid Więcław on 2022.11.20..
//  Copyright © 2022. Dawid Więcław. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var imagePicker: ImagePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imagePickerButton: UIButton!
    
    var videoPicker: VideoPicker!
//    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var videoPickerButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        self.videoView.contentMode = .scaleAspectFill
//        self.videoView.player?.isMuted = true
//        self.videoView.repeat = .loop
    }

    @IBAction func imagePickerButtonTouched(_ sender: UIButton) {
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func videoPickerButtonTouched(_ sender: UIButton) {
        guard let url = URL(string: "http://127.0.0.1:8000/recognizer/") else {
            return
        }
                    
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var dateStringResponse: String!
        
        let semaphore = DispatchSemaphore(value: 0)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            let dataString = String(data: data, encoding: .utf8)
            print(dataString!)
            dateStringResponse = dataString!
            print(dateStringResponse!)
            semaphore.signal()
        }
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        let alertController = UIAlertController(title: "sent", message: dateStringResponse, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
          // do something
        }
        alertController.addAction(cancelAction)

        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
          // do something
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
}

extension ViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        guard let image = image else {
            return
        }
        self.imageView.image = image
    }
}


extension ViewController: VideoPickerDelegate {

    func didSelect(url: URL?) {
        guard let url = url else {
            return
        }
//        self.videoView.url = url
//        self.videoView.player?.play()
    }
}

