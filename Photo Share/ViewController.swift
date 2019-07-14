//
//  ViewController.swift
//  Photo Share
//
//  Created by maurice on 7/11/19.
//  Copyright © 2019 maurice. All rights reserved.
//

import UIKit
import Photos


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	var assetCollection: PHAssetCollection?
	var photos: PHFetchResult<PHAsset>?
	
	
	@IBOutlet weak var tableView: UITableView!
	
	let reuseIdentifier = "tableViewCell"
	let numberOfRows = 10
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		tableView.dataSource = self
		tableView.delegate = self
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {

		let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
		if (collection.firstObject != nil) {
			self.assetCollection = collection.firstObject! as PHAssetCollection
			
			let options = PHFetchOptions()
			options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
			options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) 	]
			
			self.photos = PHAsset.fetchAssets(in: assetCollection!, options: options)
		}else {
			print("No image collection found, Sorry!")
		}
		
		// reloading the table view if new pics have been added
		tableView.reloadData()
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let id = segue.identifier {
			if (id == "showFullImageSegue"){
				let newVc = segue.destination as! ShowImageViewController
				
				var indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
				
				if let asset = self.photos?[(indexPath!.row)]{
					newVc.asset = asset
				}
			}
		}
		
	}
	
	var imagePicker:UIImagePickerController!
	
	@IBAction func cameraButtonClicked(_ sender: Any) {
		imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = .camera
		present(imagePicker, animated: true, completion: nil)
		
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		imagePicker.dismiss(animated: true, completion: nil)
		
		// grabing the new viewcontroller we want to go to
		let newVC = self.storyboard?.instantiateViewController(withIdentifier: "showPhotoVC") as! ShowImageViewController
		
		if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			
			//saving the image to the lacal images album before showing it
			UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
			
			newVC.image = image
			show(newVC, sender: self)
			
		}
		
		
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: MyTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MyTableViewCell
		
		if let asset = self.photos?[indexPath.row] {
			PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width:320, height: 240), contentMode: .aspectFill, options: nil, resultHandler: {(result, info)in
				
				if let image = result {
					cell.myImageView?.image = image
				}
			})
		}
		
		//		cell.myImageView.image = UIImage(named: "polaroid")
		return cell
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return numberOfRows
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

