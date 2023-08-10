
import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var miniBall: UIImageView!
    @IBOutlet weak var vilainCharacterImageView: UIImageView!
    @IBOutlet weak var characterLifeBar: UIProgressView!
    @IBOutlet weak var dragonFirst: UIImageView!
    
    var backgroundAudioPlayer: AVAudioPlayer?
    var transformationAudioPlayer: AVAudioPlayer?
    
    var moveImages = [UIImage(named: "gokufront"), UIImage(named: "gokuwalk1"), UIImage(named: "gokuwalk2"), UIImage(named: "gokuup"), UIImage(named: "gokudown")]
    var punchImages = [UIImage(named: "strike1"), UIImage(named: "strike2"), UIImage(named: "strike3")]
    var superMoveImages = [UIImage(named: "supergokufront"), UIImage(named: "supergokuwalk1"), UIImage(named: "supergokuwalk2"), UIImage(named: "supergokuup"), UIImage(named: "supergokudown")]
    var superMoveSsj3Images = [UIImage(named: "goku3front"), UIImage(named: "goku3walk1"), UIImage(named: "goku3walk2"), UIImage(named: "goku3up"), UIImage(named: "goku3down")]
    var superPunchImages = [UIImage(named: "superstrike1"), UIImage(named: "superstrike2"), UIImage(named: "superstrike3")]
    var superPunchSsj3Images = [UIImage(named: "goku3strike1"), UIImage(named: "goku3strike2"), UIImage(named: "goku3strike3")]
    var transformImages = [UIImage(named: "transform1"), UIImage(named: "transform2"), UIImage(named: "transform3"), UIImage(named: "transform4"), UIImage(named: "transform5"), UIImage(named: "reverttransform")]
    var super3TranformImages = [UIImage(named: "goku3transform1"), UIImage(named: "goku3transform2"), UIImage(named: "goku3transform3")]
    var skillsImages = [UIImage(named: "bola"), UIImage(named: "grandebola"), UIImage(named: "ballcoming"), UIImage(named: "teleport1"), UIImage(named: "teleport2"), UIImage(named: "gokuminiballatk"), UIImage(named: "miniballatk"), UIImage(named: "supergokuminiballatk"), UIImage(named: "dragonfirst"), UIImage(named: "goku3miniatk"), UIImage(named: "goku3miniatk2")]
    var collisionsImages = [UIImage(named: "buucollision2"), UIImage(named: "buucollision3"), UIImage(named: "buucollision")]
    var villainImages = [UIImage(named: "buufront"), UIImage(named: "buuwalk1"), UIImage(named: "buuwalk2")]
    var recoveryVilain = [UIImage(named: "buugordorec")]
    
    var positionX: CGFloat = 0.0
    var positionY: CGFloat = 0.0
    var isTransformed = false
    var isButtonActionInProgress = false
    var currentIndex = 0
    var isPressed = 0
    var villainHealth: Int = 50
    var isVillainInRecovery: Bool = false
    var isMode3 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backGroundImage = UIImage(named: "backgrounddbz")
        backGroundImageView.image = backGroundImage
        backGroundImageView.contentMode = .scaleAspectFill
        
        let characterImage = UIImage(named: "gokufront")
        characterImageView.image = characterImage
        positionX = characterImageView.frame.origin.x
        positionY = characterImageView.frame.origin.y
        
        let vilainImage = UIImage(named: "buufront")
        vilainCharacterImageView.image = vilainImage
        positionX = vilainCharacterImageView.frame.origin.x
        positionY = vilainCharacterImageView.frame.origin.y
        
        
        characterImageView.layer.zPosition = vilainCharacterImageView.layer.zPosition + 1
        
        characterLifeBar.progress = 1.0
        characterLifeBar.progressTintColor = .green
        
        playBackgroundMusic()
        
    }
    
    @IBAction func dragonFirstPressed(_ sender: UIButton) {
        sender.isEnabled = false
        playActionSound(soundFileName: "grandebola")
        if isTransformed == false && isMode3 == false {
            characterImageView.image = skillsImages[5]
            perform(#selector(changeImage), with: nil, afterDelay: 0.6)
            isPressed += 1
        }
        if isTransformed == true {
            characterImageView.image = skillsImages[7]
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.6)
            isPressed += 1
        }
        if isMode3 == true {
            characterImageView.image = skillsImages[10]
            perform(#selector(changeImageSsj3Mode), with: nil, afterDelay: 0.6)
            isPressed += 1
        }
        
        if isPressed >= 1 {
            let dragonFirstX = characterImageView.frame.maxX + 10
            let dragonFirstY = characterImageView.frame.midY - dragonFirst.bounds.height / 2
            dragonFirst.frame.origin = CGPoint(x: dragonFirstX, y: dragonFirstY)
            if isTransformed == false && isMode3 == false {
                dragonFirst.image = skillsImages[8]
                dragonFirst.contentMode = .scaleToFill
            } else {
                dragonFirst.image = skillsImages[8]
            }
            let destinationXPosition = vilainCharacterImageView.frame.origin.x - dragonFirst.bounds.width
            var currentXPosition = dragonFirstX
            
            Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [self] timer in
                currentXPosition += 5  // Ajuste a velocidade da miniBall conforme necessário
                self.dragonFirst.frame.origin.x = currentXPosition
                if currentXPosition >= destinationXPosition {
                    checkDragonFirstCollision()
                    orangeChange()
                    timer.invalidate()
                    self.dragonFirst.image = nil
                    self.dragonFirst.frame.origin = CGPoint(x: 0, y: 0)
                    if self.isPressed >= 1 {
                        self.vilainCharacterImageView.image = self.collisionsImages[self.currentIndex]
                        self.currentIndex += 1
                        vilainCharacterImageView.contentMode = .scaleToFill
                        
                        perform(#selector(changeColisionVilainImage), with: nil, afterDelay: 0.3)
                    }
                    if currentIndex >= collisionsImages.count {
                        currentIndex = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        sender.isEnabled = true
                    }
                    self.isPressed = 0
                }
            }
        }
    }
    
    
    func DashFrontMove() {
        if isPressed == 1 {
            positionX = characterImageView.frame.origin.x
            positionY = characterImageView.frame.origin.y
            positionX += 200
        }
    }
    func DashBackMove() {
        if isPressed == 1 {
            positionX = characterImageView.frame.origin.x
            positionY = characterImageView.frame.origin.y
            positionX -= 200
        }
    }
    
    @IBAction func teleportButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        if isTransformed == true {
            isPressed += 1
            playActionSound(soundFileName: "teleport")
            characterImageView.image = skillsImages[3]
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.5)
            DashFrontMove()
            moveCharacter()
        }
        if isMode3 == true {
            isPressed += 1
            playActionSound(soundFileName: "teleport")
            characterImageView.image = skillsImages[3]
            perform(#selector(changeImageSsj3Mode), with: nil, afterDelay: 0.5)
            DashFrontMove()
            moveCharacter()
        }
        if isTransformed == false && isMode3 == false {
            isPressed += 1
            playActionSound(soundFileName: "teleport")
            characterImageView.image = skillsImages[3]
            perform(#selector(changeImage), with: nil, afterDelay: 0.5)
            DashFrontMove()
            moveCharacter()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sender.isEnabled = true
        }
        isPressed = 0
    }
    
    @IBAction func dashTeleportPressed(_ sender: UIButton) {
        sender.isEnabled = false
        if isTransformed == true {
            isPressed += 1
            playActionSound(soundFileName: "teleport")
            characterImageView.image = skillsImages[3]
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.5)
            DashBackMove()
            moveCharacter()
        }
        if isMode3 == true {
            isPressed += 1
            playActionSound(soundFileName: "teleport")
            characterImageView.image = skillsImages[3]
            perform(#selector(changeImageSsj3Mode), with: nil, afterDelay: 0.5)
            DashBackMove()
            moveCharacter()
        }
        if isTransformed == false && isMode3 == false {
            isPressed += 1
            playActionSound(soundFileName: "teleport")
            characterImageView.image = skillsImages[3]
            perform(#selector(changeImage), with: nil, afterDelay: 0.5)
            DashBackMove()
            moveCharacter()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sender.isEnabled = true
        }
        isPressed = 0
    }
    
    @IBAction func powerButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        playActionSound(soundFileName: "grandebola")
        if isTransformed == false && isMode3 == false {
            characterImageView.image = skillsImages[5]
            perform(#selector(changeImage), with: nil, afterDelay: 0.6)
            isPressed += 1
            
        }
        if isTransformed == true {
            characterImageView.image = skillsImages[7]
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.6)
            isPressed += 1
        }
        if isMode3 == true {
            characterImageView.image = skillsImages[10]
            perform(#selector(changeImageSsj3Mode), with: nil, afterDelay: 0.6)
            isPressed += 1
        }
        
        if isPressed >= 1 {
            let miniBallX = characterImageView.frame.maxX + 10
            let miniBallY = characterImageView.frame.midY - miniBall.bounds.height / 2
            miniBall.frame.origin = CGPoint(x: miniBallX, y: miniBallY)
            if isTransformed == false && isMode3 == false {
                miniBall.image = skillsImages[6]
                miniBall.contentMode = .scaleAspectFill
            } else {
                miniBall.image = skillsImages[2]
            }
            let destinationXPosition = vilainCharacterImageView.frame.origin.x - miniBall.bounds.width
            var currentXPosition = miniBallX
            
            Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { [self] timer in
                currentXPosition += 20  // Ajuste a velocidade da miniBall conforme necessário
                self.miniBall.frame.origin.x = currentXPosition
                if currentXPosition >= destinationXPosition {
                    checkSkillsCollision()
                    timer.invalidate()
                    self.miniBall.image = nil
                    self.miniBall.frame.origin = CGPoint(x: 0, y: 0)
                    if self.isPressed >= 1 {
                        self.vilainCharacterImageView.image = self.collisionsImages[self.currentIndex]
                        self.currentIndex += 1
                        vilainCharacterImageView.contentMode = .scaleToFill
                        
                        perform(#selector(changeColisionVilainImage), with: nil, afterDelay: 0.3)
                    }
                    if currentIndex >= collisionsImages.count {
                        currentIndex = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        sender.isEnabled = true
                    }
                    self.isPressed = 0
                }
            }
        }
    }
    
    @IBAction func punchButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        if isTransformed == false && isMode3 == false {
            playActionSound(soundFileName: "strike")
            characterImageView.image = punchImages[currentIndex]
            currentIndex += 1
            perform(#selector(changeImage), with: nil, afterDelay: 0.3)
        }
        if currentIndex >= punchImages.count {
            currentIndex = 0
        }
        if isMode3 == true {
            playActionSound(soundFileName: "strike")
            characterImageView.image = superPunchSsj3Images[currentIndex]
            currentIndex += 1
            perform(#selector(changeImageSsj3Mode), with: nil, afterDelay: 0.3)
        }
        if currentIndex >= superPunchSsj3Images.count {
            currentIndex = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.isEnabled = true
        }
        checkCollisions()
    }
    
    @IBAction func punchButtonPressedInSuperMode(_ sender: UIButton) {
        if isTransformed == true {
            playActionSound(soundFileName: "strike")
            characterImageView.image = superPunchImages[currentIndex]
            currentIndex += 1
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.3)
            if currentIndex >= superPunchImages.count {
                currentIndex = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func normalButtonPressed(_ sender: UIButton) {
        if isButtonActionInProgress {
            return
        }
        isButtonActionInProgress = true
        sender.isEnabled = false
        if isTransformed == true || isMode3 == true {
            isTransformed = false
            isMode3 = false
            playActionSound(soundFileName: "reverttransform")
            characterImageView.image = transformImages[5]
            perform(#selector(changeImage), with: nil, afterDelay: 2.0)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isButtonActionInProgress = false
            sender.isEnabled = true
        }
    }
    
    @IBAction func transform1ButtonPressed(_ sender: UIButton) {
        if isButtonActionInProgress {
            return
        }
        isButtonActionInProgress = true
        sender.isEnabled = false
        isTransformed = true
        isMode3 = false
        if isTransformed == true {
            playActionSound(soundFileName: "somssj")
            characterImageView.image = transformImages[0]
            yellowChange()
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 1.5)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isButtonActionInProgress = false
            sender.isEnabled = true
        }
    }
    
    
    @IBAction func ssj3TranformButton(_ sender: UIButton) {
        if isButtonActionInProgress {
            return
        }
        if isTransformed == true {
            playActionSound(soundFileName: "ssj3")
            isMode3 = true
            isTransformed = false
            isButtonActionInProgress = true
            sender.isEnabled = false
            currentIndex = 0 // Reinicia o índice para a primeira imagem
            
            if isMode3 == true {
                // Inicia a primeira transformação
                performTransformation()
                
            }
            isButtonActionInProgress = false
            sender.isEnabled = true
        } else {
            print("you need transform sayaiajin first")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isButtonActionInProgress = false
            sender.isEnabled = true
        }
    }
    
    func performTransformation() {
        if currentIndex < super3TranformImages.count {
            characterImageView.image = super3TranformImages[currentIndex]
            currentIndex += 1
            goldenChange()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.performTransformation()
                // Chama a próxima transformação após o atraso
            }
        }
        perform(#selector(changeImageSsj3Mode), with: nil, afterDelay: 2.5)
    }
    
    func checkCoordAndMoveRight() {
        if isPressed == 0 {
            positionX = characterImageView.frame.origin.x
            positionY = characterImageView.frame.origin.y
            positionX += 35
        } else {
            isPressed -= 1
            positionX = characterImageView.frame.origin.x
            positionY = characterImageView.frame.origin.y
            positionX += 70
        }
    }
    
    func checkCoordAndMoveLeft() {
        if isPressed == 0 {
            positionX = characterImageView.frame.origin.x
            positionY = characterImageView.frame.origin.y
            positionX -= 35
        } else {
            isPressed -= 1
            positionX = characterImageView.frame.origin.x
            positionY = characterImageView.frame.origin.y
            positionX -= 70
        }
    }
    
    func checkCoordAndMoveUp() {
        if isPressed == 0 {
            positionX = characterImageView.frame.origin.x
            positionY = characterImageView.frame.origin.y
            positionY -= 35
        } else {
            isPressed -= 1
            positionX = characterImageView.frame.origin.x
            positionY = characterImageView.frame.origin.y
            positionY -= 70
        }
    }
    
    func checkCoordAndMoveDown() {
        if isPressed == 0 {
            positionX = characterImageView.frame.origin.x
            positionY = characterImageView.frame.origin.y
            positionY += 35
        } else {
            isPressed -= 1
            positionX = characterImageView.frame.origin.x
            positionY = characterImageView.frame.origin.y
            positionY += 70
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        playActionSound(soundFileName: "leftwalk")
        if isTransformed == true {
            isPressed += 1
            characterImageView.image = superMoveImages[2]
            checkCoordAndMoveLeft()
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        if isMode3 == true {
            isPressed += 1
            characterImageView.image = superMoveSsj3Images[2]
            checkCoordAndMoveLeft()
            perform(#selector(changeImageSsj3Mode), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        if isTransformed == false && isMode3 == false {
            isPressed = 0
            characterImageView.image = moveImages[2]
            checkCoordAndMoveLeft()
            perform(#selector(changeImage), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.isEnabled = true
        }
    }
    
    @IBAction func rightButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        playActionSound(soundFileName: "rightwalk")
        if isTransformed == true {
            isPressed += 1
            characterImageView.image = superMoveImages[1]
            checkCoordAndMoveRight()
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        if isMode3 == true {
            isPressed += 1
            characterImageView.image = superMoveSsj3Images[1]
            checkCoordAndMoveRight()
            perform(#selector(changeImageSsj3Mode), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        if isTransformed == false && isMode3 == false {
            isPressed = 0
            characterImageView.image = moveImages[1]
            checkCoordAndMoveRight()
            perform(#selector(changeImage), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.isEnabled = true
        }
    }
    
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        playActionSound(soundFileName: "rightwalk")
        if isTransformed == true {
            isPressed += 1
            characterImageView.image = superMoveImages[3]
            checkCoordAndMoveUp()
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        if isMode3 == true {
            isPressed += 1
            characterImageView.image = superMoveSsj3Images[3]
            checkCoordAndMoveUp()
            perform(#selector(changeImageSsj3Mode), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        if isTransformed == false && isMode3 == false {
            isPressed = 0
            characterImageView.image = moveImages[3]
            checkCoordAndMoveUp()
            perform(#selector(changeImage), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.isEnabled = true
        }
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        playActionSound(soundFileName: "leftwalk")
        if isTransformed == true {
            isPressed += 1
            characterImageView.image = superMoveImages[4]
            checkCoordAndMoveDown()
            perform(#selector(changeImageSuperMode), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        if isMode3 == true {
            isPressed += 1
            characterImageView.image = superMoveSsj3Images[4]
            checkCoordAndMoveDown()
            perform(#selector(changeImageSsj3Mode), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        if isTransformed == false && isMode3 == false {
            isPressed = 0
            characterImageView.image = moveImages[4]
            checkCoordAndMoveDown()
            perform(#selector(changeImage), with: nil, afterDelay: 0.2)
            moveCharacter()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.isEnabled = true
        }
    }
    
    @objc func changeImage() {
        characterImageView.image = moveImages[0]
    }
    
    @objc func changeImageSuperMode() {
        characterImageView.image = superMoveImages[0]
    }
    @objc func changeImageSsj3Mode() {
        characterImageView.image = superMoveSsj3Images[0]
    }
    
    @objc func changeImageInPunchSuperMode() {
        characterImageView.image = superPunchImages[0]
    }
    @objc func changeColisionVilainImage() {
        vilainCharacterImageView.image = villainImages[0]
    }
    
    func moveCharacter() {
        let maxXPosition = view.bounds.width - characterImageView.bounds.width
        let maxYPosition = view.bounds.height - characterImageView.bounds.height
        
        positionX = max(0, min(positionX, maxXPosition))
        positionY = max(0, min(positionY, maxYPosition))
        
        UIView.animate(withDuration: 0.3) {
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
    
    func checkCollisions() {
        if isVillainInRecovery {
            return
        }
        
        let characterHitbox = CGRect(x: characterImageView.frame.origin.x, y: characterImageView.frame.origin.y, width: characterImageView.frame.width, height: characterImageView.frame.height)
        let buuFrontHitbox = CGRect(x: vilainCharacterImageView.frame.origin.x, y: vilainCharacterImageView.frame.origin.y, width: vilainCharacterImageView.frame.width, height: vilainCharacterImageView.frame.height)
        
        if characterHitbox.intersects(buuFrontHitbox) {
            villainHealth -= 5
            characterLifeBar.progress = Float(villainHealth) / 50.0
            if villainHealth <= 0 {
                villainHealth = 50
                isVillainInRecovery = true
                vilainCharacterImageView.image = recoveryVilain[0]
                vilainCharacterImageView.contentMode = .scaleAspectFill
                characterLifeBar.setProgress(1.0, animated: true)
                pinkChange()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isVillainInRecovery = false
                    self.vilainCharacterImageView.image = self.villainImages[0]
                    self.playActionSound(soundFileName: "afterbackgroundchange")
                }
            } else {
                if currentIndex < collisionsImages.count {
                    vilainCharacterImageView.image = collisionsImages[currentIndex]
                    currentIndex += 1
                    vilainCharacterImageView.contentMode = .scaleToFill
                    perform(#selector(changeColisionVilainImage), with: nil, afterDelay: 0.3)
                }
            }
            
            if currentIndex >= collisionsImages.count {
                currentIndex = 0 // Reiniciar o índice
            }
        } else {
            vilainCharacterImageView.image = villainImages[0]
            currentIndex = 0
        }
    }
    
    func checkSkillsCollision() {
        
        let miniballHitbox = CGRect(x: miniBall.frame.origin.x, y: miniBall.frame.origin.y, width: miniBall.frame.width, height: miniBall.frame.height)
        let buuFrontHitbox = CGRect(x: vilainCharacterImageView.frame.origin.x, y: vilainCharacterImageView.frame.origin.y, width: vilainCharacterImageView.frame.width, height: vilainCharacterImageView.frame.height)
        if buuFrontHitbox.intersects(miniballHitbox) {
            villainHealth -= 10
            characterLifeBar.progress = Float(villainHealth) / 50.0
            if villainHealth <= 0 {
                villainHealth = 50
                isVillainInRecovery = true
                vilainCharacterImageView.image = recoveryVilain[0]
                vilainCharacterImageView.contentMode = .scaleAspectFill
                characterLifeBar.setProgress(1.0, animated: true)
                pinkChange()
                playActionSound(soundFileName: "afterbackgroundchange")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isVillainInRecovery = false
                    self.vilainCharacterImageView.image = self.villainImages[0]
                }
            } else {
                if currentIndex < collisionsImages.count {
                    vilainCharacterImageView.image = collisionsImages[currentIndex]
                    currentIndex += 1
                    vilainCharacterImageView.contentMode = .scaleToFill
                    perform(#selector(changeColisionVilainImage), with: nil, afterDelay: 0.3)
                }
            }
            
            if currentIndex >= collisionsImages.count {
                currentIndex = 0
            }
        } else {
            vilainCharacterImageView.image = villainImages[0]
            currentIndex = 0
        }
    }
    
    func checkDragonFirstCollision() {
        
        let dragonFirstHitbox = CGRect(x: dragonFirst.frame.origin.x, y: dragonFirst.frame.origin.y, width: dragonFirst.frame.width, height: dragonFirst.frame.height)
        let buuFrontHitbox = CGRect(x: vilainCharacterImageView.frame.origin.x, y: vilainCharacterImageView.frame.origin.y, width: vilainCharacterImageView.frame.width, height: vilainCharacterImageView.frame.height)
        if buuFrontHitbox.intersects(dragonFirstHitbox) {
            villainHealth -= 10
            characterLifeBar.progress = Float(villainHealth) / 50.0
            if villainHealth <= 0 {
                villainHealth = 50
                isVillainInRecovery = true
                vilainCharacterImageView.image = recoveryVilain[0]
                vilainCharacterImageView.contentMode = .scaleAspectFill
                characterLifeBar.setProgress(1.0, animated: true) // Definir barra de vida para 100%
                pinkChange()
                playActionSound(soundFileName: "afterbackgroundchange")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.isVillainInRecovery = false
                    self.vilainCharacterImageView.image = self.villainImages[0]
                }
            } else {
                if currentIndex < collisionsImages.count {
                    vilainCharacterImageView.image = collisionsImages[currentIndex]
                    currentIndex += 1
                    vilainCharacterImageView.contentMode = .scaleToFill
                    perform(#selector(changeColisionVilainImage), with: nil, afterDelay: 0.3)
                }
            }
            
            if currentIndex >= collisionsImages.count {
                currentIndex = 0 // Reiniciar o índice
            }
        } else {
            vilainCharacterImageView.image = villainImages[0] // Imagem padrão do vilão
            currentIndex = 0
        }
    }
    
    func pinkChange() {
        
        let pinkView = UIView(frame: backGroundImageView.bounds)
        pinkView.backgroundColor = UIColor.systemPink.withAlphaComponent(0.5)
        pinkView.alpha = 0.0
        backGroundImageView.addSubview(pinkView)
        
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount = 10
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: backGroundImageView.center.x - 10, y: backGroundImageView.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: backGroundImageView.center.x + 10, y: backGroundImageView.center.y))
        backGroundImageView.layer.add(shakeAnimation, forKey: "shake")
        
        UIView.animate(withDuration: 0.5, animations: {
            pinkView.alpha = 1.0
        }) { _ in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                UIView.animate(withDuration: 0.5, animations: {
                    pinkView.alpha = 0.0
                }) { _ in
                    
                    pinkView.removeFromSuperview()}}}
    }
    
    func yellowChange() {
        
        let yellowView = UIView(frame: backGroundImageView.bounds)
        yellowView.backgroundColor = UIColor.yellow.withAlphaComponent(0.6)
        yellowView.alpha = 0.0
        backGroundImageView.addSubview(yellowView)
        
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount = 10
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: backGroundImageView.center.x - 10, y: backGroundImageView.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: backGroundImageView.center.x + 10, y: backGroundImageView.center.y))
        backGroundImageView.layer.add(shakeAnimation, forKey: "shake")
        
        UIView.animate(withDuration: 0.5, animations: {
            yellowView.alpha = 1.0
        }) { _ in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                UIView.animate(withDuration: 0.5, animations: {
                    yellowView.alpha = 0.0
                }) { _ in
                    
                    yellowView.removeFromSuperview()}}}
    }
    
    func orangeChange() {
        
        let orangeView = UIView(frame: backGroundImageView.bounds)
        orangeView.backgroundColor = UIColor.orange.withAlphaComponent(0.3)
        orangeView.alpha = 0.0
        backGroundImageView.addSubview(orangeView)
        
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount = 5
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: backGroundImageView.center.x - 5, y: backGroundImageView.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: backGroundImageView.center.x + 5, y: backGroundImageView.center.y))
        backGroundImageView.layer.add(shakeAnimation, forKey: "shake")
        
        UIView.animate(withDuration: 0.5, animations: {
            orangeView.alpha = 1.0
        }) { _ in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                UIView.animate(withDuration: 0.5, animations: {
                    orangeView.alpha = 0.0
                }) { _ in
                    orangeView.removeFromSuperview()}}}
    }
    func goldenChange() {
        
        let yellowView = UIView(frame: backGroundImageView.bounds)
        yellowView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.6)
        yellowView.alpha = 0.0
        backGroundImageView.addSubview(yellowView)
        
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.1
        shakeAnimation.repeatCount = 10
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: backGroundImageView.center.x - 20, y: backGroundImageView.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: backGroundImageView.center.x + 20, y: backGroundImageView.center.y))
        backGroundImageView.layer.add(shakeAnimation, forKey: "shake")
        
        UIView.animate(withDuration: 0.5, animations: {
            yellowView.alpha = 1.0
        }) { _ in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                UIView.animate(withDuration: 0.5, animations: {
                    yellowView.alpha = 0.0
                }) { _ in
                    
                    yellowView.removeFromSuperview()}}}
    }
}
