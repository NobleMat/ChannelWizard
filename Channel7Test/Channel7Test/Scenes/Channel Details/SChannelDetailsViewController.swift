//
//  SChannelDetailsViewController.swift
//  Channel7Test
//
//  Created by Noble Mathew on 30/6/17.
//  Copyright (c) 2017 NTech. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol SChannelDetailsViewControllerInput {
  func updateCollectionView(_ channelDetails: [ChannelDetails])
}

protocol SChannelDetailsViewControllerOutput {
  func fetchData(_ channelID: Int)
}

class SChannelDetailsViewController: UIViewController, SChannelDetailsViewControllerInput {
  var output: SChannelDetailsViewControllerOutput!
  var router: SChannelDetailsRouter!
  
  @IBOutlet weak var collectionView: UICollectionView!
  var programList = [ChannelDetails]()
  var channelDetails: Channel?
  var channelDeatilsCellIdentifier = "channelDeatilsCellIdentifier"
  // MARK: - Object lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    SChannelDetailsConfigurator.sharedInstance.configure(viewController: self)
    self.title = channelDetails?.channelName
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let channel = channelDetails, let id = channel.channedID {
      ActivityIndicator.showActivityIndicator(self.view)
      self.output.fetchData(id)
    }
  }
  
  // MARK: - Event handling
  func updateCollectionView(_ channelDetails: [ChannelDetails]) {
    programList = channelDetails.sorted {
      $0.programStartTime! < $1.programStartTime!
    }
    DispatchQueue.main.async {
      ActivityIndicator.hideActivityIndicator(self.view)
      self.collectionView.reloadData()
    }
  }
}

extension SChannelDetailsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return programList.count
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: channelDeatilsCellIdentifier, for: indexPath) as! SChannelDeatilsCollectionViewCell
    
    let program = programList[indexPath.item]
    cell.programNameLabel.text = program.programTitle
    cell.programSynopsisLabel.text = program.programSynopsis
    cell.programImageView.getImage(program.programImageURL!) { (success) in
      if !success! {
        cell.programImageView.backgroundColor = UIColor.black
      }
    }
    cell.programTimeLabel.text = "\(program.programStartTime!.convertToTime()) - \(program.programEndTime!.convertToTime())"
    
    return cell
  }
}
