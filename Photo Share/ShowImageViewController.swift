//
//  ShowImageViewController.swift
//  Photo Share
//
//  Created by maurice on 7/11/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import Photos
import Social

class ShowImageViewController: UIViewController, UIDocumentInteractionControllerDelegate {
	@IBOutlet weak var imageView: UIImageView!
	
	var asset:PHAsset?
	var image:UIImage?
	
	var docController =  UIDocumentInteractionController()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// customizing navigation
//		navigationItem.title = "MJ"
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))

		
		
        // Do any additional setup after loading the view.
		if let myAsset  = asset {
			PHImageManager.default().requestImage(for: myAsset, targetSize: CGSize(width:self.view.frame.width, height: self.view.frame.width * 0.5625), contentMode: .aspectFill, options: nil, resultHandler:{ (result, info) in
			if let image = result {
				self.imageView.image = image
			}
				})
		}else if (image != nil){
			self.imageView.image = image
		}else {
			self.dismiss(animated: true, completion: nil)
		}
		
    }
	
	@objc func handleShare() {
		print("General sharing image button clicked!")
		
		guard let image = imageView.image else {
			return
		}
		
		let activityViewCont = UIActivityViewController(activityItems: [image, "Sharing this great Image to you!"], applicationActivities: nil)
		activityViewCont.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		
		present(activityViewCont, animated: true, completion: nil)
		
	}
	
	
	@IBAction func shareImageButtonClicked( _sender: UIButton){
		switch _sender.tag {
		case 0:
			if let myVc = SLComposeViewController(forServiceType: SLServiceTypeFacebook){
				shareFbTw(vc:myVc);
			}
		case 1:
			shareOnInstagram()
		case 2:
			if let myVc = SLComposeViewController(forServiceType: SLServiceTypeTwitter){
				shareFbTw(vc:myVc);
			}
		case 3:
			print("Whatsap")
		case 4:
			print("Pin")
		default:
			print("Nothing clicked")
		}
	}
	
	func shareOnInstagram() {
		let instagramUrl = URL(string: "instagram://app")
		
		if (UIApplication.shared.canOpenURL(instagramUrl!)) {
			let  imageData = imageView.image!.jpegData(compressionQuality:85)
			let captionString = "Default Text"
			
			let writePath = (NSTemporaryDirectory() as NSString).appending("instagram.igo")
			
			do{
				try imageData?.write(to: URL(fileURLWithPath: writePath), options: [.atomicWrite])
				let fileUrl = URL(fileURLWithPath: writePath)
				self.docController = UIDocumentInteractionController(url: fileUrl)
				
				self.docController.delegate = self
				self.docController.uti = "com.instagram.exclusivegram"
				self.docController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
				self.docController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
				
			}catch _ {
				print("Unable to to open instagram")
			}
			
		}
	}
	
	func shareFbTw(vc: SLComposeViewController) {
		vc.setInitialText("Look at this damn picture")
		vc.add(imageView.image)
		vc.add(URL(string:"https://www.learnappdevelopment.com"))
		present(vc, animated: true, completion: nil)
	}
	

}
