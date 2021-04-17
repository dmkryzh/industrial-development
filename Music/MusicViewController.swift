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
    
    let songsList: Array<String> = ["Master", "Queen", "Electric", "Alpha", "Guano"]
    let youTubeList: [String] = ["https://www.youtube.com/watch?v=dQw4w9WgXcQ", "https://www.youtube.com/watch?v=HCfPhZQz2CE", "https://www.youtube.com/watch?v=L1Snj1Pt-Hs"]
    var currentSongIndex = 0
    
    var audioPlayer: AVAudioPlayer!
    
    lazy var tableYouTube: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var songLabel: UILabel = {
        let song = UILabel()
        song.text = songsList[currentSongIndex]
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
        let stack = UIStackView()
        stack.addArrangedSubview(playButton)
        stack.addArrangedSubview(backButton)
        stack.addArrangedSubview(pauseButton)
        stack.addArrangedSubview(forwardButton)
        stack.addArrangedSubview(stopButton)
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.spacing = 20
        return stack
    }()
    
    func prepareAudioPlayer() {
        let url = Bundle.main.url(forResource: songsList[currentSongIndex], withExtension: "mp3")!
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.prepareToPlay()
    }
    
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
        prepareAudioPlayer()
    }
    
    @objc func playButtonAction() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
        else {
            audioPlayer.play()
        }
    }
    
    @objc func stopButtonAction() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
    
    @objc func pauseButtonAction() {
        audioPlayer.pause()
    }
    
    @objc func backButtonAction() {
        if currentSongIndex == 0 {
            currentSongIndex = songsList.count - 1
        } else {
            currentSongIndex -= 1
        }
        let url = Bundle.main.url(forResource: songsList[currentSongIndex], withExtension: "mp3")!
        songLabel.text = songsList[currentSongIndex]
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
    
    @objc func forwardButtonAction() {
        if currentSongIndex == songsList.count - 1 {
            currentSongIndex = 0
        } else {
            currentSongIndex += 1 % songsList.count
        }
        let url = Bundle.main.url(forResource: songsList[currentSongIndex], withExtension: "mp3")!
        songLabel.text = songsList[currentSongIndex]
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
    }
}

extension MusicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoUrl = URL(string: youTubeList[indexPath.row])!
        let web = WebViewController()
        web.someUrl = videoUrl
        navigationController?.pushViewController(web, animated: true)
    }
    
}

extension MusicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youTubeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableYouTube.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "YouTube видео № \(indexPath.item + 1)"
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
}


