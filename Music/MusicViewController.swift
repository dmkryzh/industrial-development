//
//  MusicViewController.swift
//  Navigation
//
//  Created by Dmitrii KRY on 15.04.2021.
//

import UIKit
import SnapKit
import AVFoundation

class MusicViewController: UIViewController {
    
    let playerDelegate = AudioPlayer()
    
    lazy var tableYouTube: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var songLabel: UILabel = {
        let song = UILabel()
        song.text = playerDelegate.songsList[0]
        song.font = UIFont.systemFont(ofSize: 25)
        song.textAlignment = .center
        return song
    }()
    
    lazy var playButton: UIImageView = {
        let image = UIImageView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(playButtonAction))
        image.image = UIImage(systemName: "play")
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var stopButton: UIImageView = {
        let image = UIImageView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(stopButtonAction))
        image.image = UIImage(systemName: "stop")
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var pauseButton: UIImageView = {
        let image = UIImageView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pauseButtonAction))
        image.image = UIImage(systemName: "pause")
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var backButton: UIImageView = {
        let image = UIImageView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backButtonAction))
        image.image = UIImage(systemName: "backward.frame")
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var forwardButton: UIImageView = {
        let image = UIImageView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(forwardButtonAction))
        image.image = UIImage(systemName: "forward.frame")
        image.addGestureRecognizer(gesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var stackViewPlayer: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [playButton, backButton, pauseButton, forwardButton, stopButton])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 20
        return stack
    }()
    
    func setupConstraints() {
        
        songLabel.snp.makeConstraints() { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).inset(30)
            make.height.equalTo(30)
            
        }
        
        stackViewPlayer.snp.makeConstraints() { make in
            make.top.equalTo(songLabel.snp.bottom).offset(10)
            make.height.equalTo(23)
            make.width.equalTo(view.snp.width).inset(30)
            make.centerX.equalToSuperview()
            
        }
        
        tableYouTube.snp.makeConstraints() { make in
            make.top.equalTo(stackViewPlayer.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(songLabel, stackViewPlayer, tableYouTube)
        setupConstraints()
        playerDelegate.prepareAudioPlayer()
    }
    
    @objc func playButtonAction() {
        playerDelegate.playButtonAction()
    }
    
    @objc func stopButtonAction() {
        playerDelegate.stopButtonAction()
    }
    
    @objc func pauseButtonAction() {
        playerDelegate.pauseButtonAction()
    }
    
    @objc func backButtonAction() {
        songLabel.text = playerDelegate.backButtonAction()
    }
    
    @objc func forwardButtonAction() {
        songLabel.text = playerDelegate.forwardButtonAction()
        
    }
}

extension MusicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoUrl = URL(string: playerDelegate.youTubeList[indexPath.row])!
        let web = WebViewController()
        web.someUrl = videoUrl
        navigationController?.pushViewController(web, animated: true)
    }
    
}

extension MusicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerDelegate.youTubeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableYouTube.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "YouTube видео № \(indexPath.item + 1)"
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
}


