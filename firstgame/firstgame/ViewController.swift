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
    
    var right: UIImage?
    var left: UIImage?
    var front: UIImage?
    var up: UIImage?
    var down: UIImage?
    var transform: UIImage?
    var normal: UIImage?
    var punch: UIImage?
    var punch2: UIImage?
    var punch3: UIImage?
    var superpunch: UIImage?
    var supergokufront: UIImage?
    
    let punchImages = [UIImage(named: "strike1"), UIImage(named: "strike2"), UIImage(named: "strike3")]
    let superPunchImages = [UIImage(named: "superstrike1"), UIImage(named: "superstrike2"), UIImage(named: "superstrike3")]
    
    var positionX: CGFloat = 0.0
    var positionY: CGFloat = 0.0
    var isTransformed = false
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backGroundImage = UIImage(named: "backgrounddbz")
        backGroundImageView.image = backGroundImage
        backGroundImageView.contentMode = .scaleAspectFill
        
        right = UIImage(named: "gokuwalk1")
        left = UIImage(named: "gokuwalk2")
        front = UIImage(named: "gokufront")
        up = UIImage(named: "gokuup")
        down = UIImage(named: "gokudown")
        transform = UIImage(named: "transform1")
        normal = UIImage(named: "reverttransform")
        punch = UIImage(named: "strike1")
        punch2 = UIImage(named: "strike2")
        punch3 = UIImage(named: "strike3")
        superpunch = UIImage(named: "superstrike1")
        supergokufront = UIImage(named: "supergokufront")
    
        
        
        
        let characterImage = UIImage(named: "gokufront")
        characterImageView.image = characterImage
        positionX = characterImageView.frame.origin.x
        positionY = characterImageView.frame.origin.y
        
        playBackgroundMusic()
    }
    
    
    @IBAction func punchButtonPressed(_ sender: UIButton) {
        soundPunchPressed()
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
        soundSuperPunchPressed()
        if isTransformed == true {
        superPunchChanges()
        }
    }
    
    @IBAction func normalButtonPressed(_ sender: UIButton) {
        characterImageView.image = normal
        isTransformed = false
        backToNormal()
        playReturnTransformation()
        
    }
    
    @IBAction func transform1ButtonPressed(_ sender: UIButton) {
        isTransformed = true
        transformSsj()
        characterImageView.image = transform
        playTransformationSound()
        
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        soundLeftWalk()
        characterImageView.image = left
        perform(#selector(changeImage), with: nil, afterDelay: 0.2)
        positionX -= 50
        moveCharacter()
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        soundRightWalk()
        characterImageView.image = right
        perform(#selector(changeImage), with: nil, afterDelay: 0.2)
        positionX += 50
        moveCharacter()
    }
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        characterImageView.image = up
        perform(#selector(changeImage), with: nil, afterDelay: 0.2)
        positionY -= 50
        moveCharacter()
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        characterImageView.image = down
        perform(#selector(changeImage), with: nil, afterDelay: 0.2)
        positionY += 50
        moveCharacter()
    }
    
    @objc func changeImage() {
        characterImageView.image = front
    }
    
    @objc func changeImageSuperMode() {
        characterImageView.image = supergokufront
    }
    
    @objc func changeImageInPunchSuperMode() {
        characterImageView.image = superpunch
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
    
    func transformSsj() {
        front = UIImage(named: "supergokufront")
        right = UIImage(named: "supergokuwalk1")
        left = UIImage(named: "supergokuwalk2")
        up = UIImage(named: "supergokuup")
        down = UIImage(named: "supergokudown")
    }
    
    func backToNormal() {
        right = UIImage(named: "gokuwalk1")
        left = UIImage(named: "gokuwalk2")
        front = UIImage(named: "gokufront")
        up = UIImage(named: "gokuup")
        down = UIImage(named: "gokudown")
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
    
    func playTransformationSound() {
        guard let soundURL = Bundle.main.url(forResource: "somssj", withExtension: "wav" ) else {
            print("Arquivo de som da transformação não encontrado.")
            return
        }
        
        do {
            transformationAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            transformationAudioPlayer?.play()
        } catch {
            print("Erro ao reproduzir o som da transformação: \(error.localizedDescription)")
        }
    }
    
    func playReturnTransformation() {
        guard let soundURL = Bundle.main.url(forResource: "reverttransform", withExtension: "wav" ) else {
            print("Arquivo de som da transformação não encontrado.")
            return
        }
        
        do {
            transformationAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            transformationAudioPlayer?.play()
        } catch {
            print("Erro ao reproduzir o som da transformação: \(error.localizedDescription)")
        }
    }
    func soundPunchPressed() {
        guard let soundURL = Bundle.main.url(forResource: "strike", withExtension: "wav" ) else {
            print("Arquivo de som da transformação não encontrado.")
            return
        }
        
        do {
            transformationAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            transformationAudioPlayer?.play()
        } catch {
            print("Erro ao reproduzir o som da transformação: \(error.localizedDescription)")
        }
    }
    func soundSuperPunchPressed() {
        guard let soundURL = Bundle.main.url(forResource: "superstrike", withExtension: "wav" ) else {
            print("Arquivo de som da transformação não encontrado.")
            return
        }
        
        do {
            transformationAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            transformationAudioPlayer?.play()
        } catch {
            print("Erro ao reproduzir o som da transformação: \(error.localizedDescription)")
        }
    }
    func soundRightWalk() {
        guard let soundURL = Bundle.main.url(forResource: "rightwalk", withExtension: "wav" ) else {
            print("Arquivo de som da transformação não encontrado.")
            return
        }
        
        do {
            transformationAudioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            transformationAudioPlayer?.play()
        } catch {
            print("Erro ao reproduzir o som da transformação: \(error.localizedDescription)")
        }
    }
    func soundLeftWalk() {
        guard let soundURL = Bundle.main.url(forResource: "leftwalk", withExtension: "wav" ) else {
            print("Arquivo de som da transformação não encontrado.")
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








