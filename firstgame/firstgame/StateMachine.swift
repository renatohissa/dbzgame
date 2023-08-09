import UIKit

enum Saiyajin {
    case normal
    case ssj1
    
    var moveImages: [UIImage?] {
        switch self {
        case .normal:
            return [UIImage(named: "gokufront"), UIImage(named: "gokuwalk1"), UIImage(named: "gokuwalk2"), UIImage(named: "gokuup"), UIImage(named: "gokudown")]
        case .ssj1:
            return [UIImage(named: "supergokufront"), UIImage(named: "supergokuwalk1"), UIImage(named: "supergokuwalk2"), UIImage(named: "supergokuup"), UIImage(named: "supergokudown")]
        }
    }
    
    var punchImages: [UIImage?] {
        switch self {
        case .normal:
            return [UIImage(named: "strike1"), UIImage(named: "strike2"), UIImage(named: "strike3")]
        case .ssj1:
            return [UIImage(named: "superstrike1"), UIImage(named: "superstrike2"), UIImage(named: "superstrike3")]
        }
    }
    
    var transformImages: UIImage? {
        switch self {
        case .normal:
            return UIImage(named: "transform1")
        case .ssj1:
            return UIImage(named: "reverttransform")
        }
    }
}
