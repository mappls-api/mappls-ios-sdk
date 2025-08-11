//
//  DraggableAnnotationView.swift
//  MapplsSDKDemo
//
//  Created by rento on 21/01/25.
//

import UIKit
import MapplsMap

protocol DraggableAnnotationDelegate: Sendable, AnyObject {
    func draggingDidEnd<T: MGLAnnotationView>(annotation: T) async
}

class DraggableAnnotationView: MGLAnnotationView {
    
    var destImageView: UIImageView!
    weak var delegate: DraggableAnnotationDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    func commonInit() {
        backgroundColor = .clear
        
        isDraggable = true
        scalesWithViewingDistance = false
        
        frame = .init(x: 0, y: 0, width: 50, height: 50)
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        
        destImageView = UIImageView(frame: frame)
        destImageView.image = UIImage(named: "dest-pin")
        destImageView.contentMode = .scaleAspectFit
        addSubview(destImageView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func setDragState(_ dragState: MGLAnnotationViewDragState, animated: Bool) {
        super.setDragState(dragState, animated: animated)

        switch dragState {
        case .starting:
            startDragging()
        case .ending, .canceling:
            endDragging()
        case .none:
            break
        default:
            break
        }
    }
    
    func startDragging() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 0.8
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        }, completion: nil)
        
        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
        hapticFeedback.impactOccurred()
    }

    func endDragging() {
        Task {
            await delegate?.draggingDidEnd(annotation: self)
        }
        transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.layer.opacity = 1
            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        }, completion: nil)
        let hapticFeedback = UIImpactFeedbackGenerator(style: .light)
        hapticFeedback.impactOccurred()
    }
}
