//
//  ViewController.swift
//  firstgame
//
//  Created by Renato Pinheiro Hissa on 31/07/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var characterImageView: UIImageView!
    
    var backgroundAudioPlayer: AVAudioPlayer?
    var transformationAudioPlayer: AVAudioPlayer?
    
    var moveImages = [UIImage(named: "gokufront"), UIImage(named: "gokuwalk1"), UIImage(named: "gokuwalk2"), UIImage(named: "gokuup"), UIImage(named: "gokudown")]
    var punchImages = [UIImage(named: "strike1"), UIImage(named: "strike2"), UIImage(named: "strike3")]
    var superMoveImages = [UIImage(named: "supergokufront"), UIImage(named: "supergokuwalk1"), UIImage(named: "supergokuwalk2"), UIImage(named: "supergokuup"), UIImage(named: "supergokudown")]
    var superPunchImages = [UIImage(named: "superstrike1"), UIImage(named: "superstrike2"), UIImage(named: "superstrike3")]
    var transformImagens = [UIImage(named: "transform1"), UIImage(named: "reverttransform")]
    
    var positionX: CGFloat = 0.0
    var positionY: CGFloat = 0.0
    var isTransformed = false
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backGroundImage = UIImage(named: "backgrounddbz")
        backGroundImageView.image = backGroundImage
        backGroundImageView.contentMode = .scaleAspectFill
        
        let characterImage = UIImage(named: "gokufront")
        characterImageView.image = characterImage
        positionX = characterImageView.frame.origin.x
        positionY = characterImageView.frame.origin.y
        
        playBackgroundMusic()
    }
    
    @IBAction func punchButtonPressed(_ sender: UIButton) {
        playActionSound(soundFileName: "superstrike")
        characterImageView.image = punchImages[currentIndex]
        currentIndex += 1
        if currentIndex >= punchImages.count {
            currentIndex = 0
        }
        if isTransformed == false {
            perform(#selector(changeImage), with: nil, afterDelay: 0.2)
        }
    }
    
    @IBAction func punchButtonPressedInSuperMode(_ sender: UIButton) {
        playActionSound(soundFileName: "strike")
        if isTransformed == true {
            superPunchChanges()
        }
    }
    
    @IBAction func normalButtonPressed(_ sender: UIButton) {
        if isTransformed {
            characterImageView.image = transformImagens[1]
            isTransformed = false
            playActionSound(soundFileName: "reverttransform")
        }
    }
    
    @IBAction func transform1ButtonPressed(_ sender: UIButton) {
        if isTransformed == false {
            characterImageView.image = transformImagens[0]
            isTransformed = true
            playActionSound(soundFileName: "somssj")
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        playActionSound(soundFileName: "leftwalk")
        if isTransformed == true {
            characterImageView.image = superMoveImages[2]
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.2)
            positionX -= 70
            moveCharacter()
        } else {
            characterImageView.image = moveImages[2]
            perform(#selector(changeImage), with: nil, afterDelay: 0.2)
            positionX -= 35
            moveCharacter()
        }
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        playActionSound(soundFileName: "rightwalk")
        if isTransformed == true {
            characterImageView.image = superMoveImages[1]
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.2)
            positionX += 70
            moveCharacter()
        } else {
            characterImageView.image = moveImages[1]
            perform(#selector(changeImage), with: nil, afterDelay: 0.2)
            positionX += 35
            moveCharacter()
        }
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        if isTransformed == true {
            characterImageView.image = superMoveImages[3]
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.2)
            positionY -= 70
            moveCharacter()
        } else {
            characterImageView.image = moveImages[3]
            perform(#selector(changeImage), with: nil, afterDelay: 0.2)
            positionY -= 35
            moveCharacter()
        }
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        if isTransformed == true {
            characterImageView.image = superMoveImages[4]
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.2)
            positionY += 70
            moveCharacter()
        } else {
            characterImageView.image = moveImages[4]
            perform(#selector(changeImage), with: nil, afterDelay: 0.2)
            positionY += 35
            moveCharacter()
        }
    }
    
    @objc func changeImage() {
        characterImageView.image = moveImages[0]
    }
    
    @objc func changeImageSuperMode() {
        characterImageView.image = superMoveImages[0]
    }
    
    @objc func changeImageInPunchSuperMode() {
        characterImageView.image = superPunchImages[0]
    }
    
    @objc func superPunchChanges() {
        characterImageView.image = superPunchImages[currentIndex]
        currentIndex += 1
        if currentIndex >= superPunchImages.count {
            currentIndex = 0
        }
        perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.2)
    }
    
    func moveCharacter() {
        let maxXPosition = view.bounds.width - characterImageView.bounds.width
        let maxYPosition = view.bounds.height - characterImageView.bounds.height
        
        positionX = max(0, min(positionX, maxXPosition))
        positionY = max(0, min(positionY, maxYPosition))
        
        UIView.animate(withDuration: 0.2) {
            self.characterImageView.frame.origin.x = self.positionX
            self.characterImageView.frame.origin.y = self.positionY
        }
    }
    
    func playBackgroundMusic() {
        guard let soundURL = Bundle.main.url(forResource: "backgroundmusic1", withExtension: "mp3" ) else {
            print("Arquivo de som de fundo não encontrado.")
            return
        }
        
        do {
            backgroundAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            backgroundAudioPlayer?.numberOfLoops = -1 // Repetir indefinidamente
            backgroundAudioPlayer?.prepareToPlay()
            backgroundAudioPlayer?.play()
        } catch {
            print("Erro ao reproduzir o som de fundo: \(error.localizedDescription)")
        }
    }
    
    func playActionSound(soundFileName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav") else {
            print("Arquivo de som não encontrado: \(soundFileName)")
            return
        }
        
        do {
            transformationAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            transformationAudioPlayer?.play()
        } catch {
            print("Erro ao reproduzir o som da transformação: \(error.localizedDescription)")
        
        }
    }
}





