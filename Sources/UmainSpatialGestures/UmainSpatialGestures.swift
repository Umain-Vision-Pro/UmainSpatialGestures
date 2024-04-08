// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI
import RealityKit

extension View {
    // Add a method to apply the custom drag gesture
    public func useDragAndRotateGesture(constrainedToAxis: RotationAxis3D?) -> some View {
        self.gesture(CustomGestures.createDragAndRotateGesture(constrainedToAxis))
    }
    
    public func useDragGesture() -> some View {
        self.gesture(CustomGestures.createDragGesture())
    }
    
    public func useRotateGesture(constrainedToAxis: RotationAxis3D?) -> some View {
        self.gesture(CustomGestures.createRotateGesture(constrainedToAxis))
    }
    
    public func useMagnifyGesture() -> some View {
        self.gesture(CustomGestures.createMagnifyGesture())
    }
    
    public func useDragAndMagnifyGesture() -> some View {
        self.gesture(CustomGestures.createDragAndMagnifyGesture())
    }
    
    public func useFullGesture(constrainedToAxis: RotationAxis3D?) -> some View {
        self.gesture(CustomGestures.createFullGesture(constrainedToAxis))
    }
}

struct CustomGestures {
    
    static func createFullGesture(_ constrainedToAxis: RotationAxis3D?) -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .simultaneously(with: MagnifyGesture())
            .simultaneously(with: RotateGesture3D(constrainedToAxis: constrainedToAxis))
            .targetedToAnyEntity()
            .onChanged { value in
                
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                
                if let rotation = value.second?.rotation {
                    let rotationTransform = Transform(AffineTransform3D(rotation: rotation))
                    value.entity.transform.rotation = sourceTransform!.rotation * rotationTransform.rotation
                } else if let translation = value.first?.first?.translation3D {
                    let convertedTranslation = value.convert(translation, from: .local, to: value.entity.parent!)
                    value.entity.transform.translation = sourceTransform!.translation + convertedTranslation
                } else if let magnification = value.first?.second?.magnification {
                    let scaleTransform = Transform(AffineTransform3D(
                        scale: Size3D(width: magnification, height: magnification, depth: magnification)
                    ))
                    value.entity.transform.scale = sourceTransform!.scale * scaleTransform.scale
                }
            }
            .onEnded { _ in
                sourceTransform = nil
            }
        
    }
    
    static func createDragAndMagnifyGesture() -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .simultaneously(with: MagnifyGesture())
            .targetedToAnyEntity()
            .onChanged { value in
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                if let magnification = value.second?.magnification {
                    let scaleTransform = Transform(AffineTransform3D(
                        scale: Size3D(width: magnification, height: magnification, depth: magnification)
                    ))
                    print(sourceTransform!.scale * scaleTransform.scale)
                    value.entity.transform.scale = sourceTransform!.scale * scaleTransform.scale
                } else if let translation = value.first?.translation3D {
                    let convertedTranslation = value.convert(translation, from: .local, to: value.entity.parent!)
                    value.entity.transform.translation = sourceTransform!.translation + convertedTranslation
                }
            }
            .onEnded { _ in
                sourceTransform = nil
            }
    }
    
    static func createMagnifyGesture() -> some Gesture {
        var sourceTransform: Transform?
        
        return MagnifyGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                
                let scaleTransform = Transform(AffineTransform3D(
                    scale: Size3D(width: value.magnification, height: value.magnification, depth: value.magnification)
                ))
                value.entity.transform.scale = sourceTransform!.scale * scaleTransform.scale
            }
            .onEnded { _ in
                sourceTransform = nil
            }
    }
    
    static func createRotateGesture(_ constrainedToAxis: RotationAxis3D?) -> some Gesture {
        var sourceTransform: Transform?
        
        return RotateGesture3D(constrainedToAxis: constrainedToAxis)
            .targetedToAnyEntity()
            .onChanged { value in
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                let rotationTransform = Transform(AffineTransform3D(rotation: value.rotation))
                value.entity.transform.rotation = sourceTransform!.rotation * rotationTransform.rotation
            }
            .onEnded { _ in
                sourceTransform = nil
            }
    }
    
    static func createDragGesture() -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                let convertedTranslation = value.convert(value.translation3D, from: .local, to: value.entity.parent!)
                value.entity.transform.translation = sourceTransform!.translation + convertedTranslation
            }
            .onEnded { _ in
                sourceTransform = nil
            }
    }
    
    static func createDragAndRotateGesture(_ constrainedToAxis: RotationAxis3D?) -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .simultaneously(with: RotateGesture3D(constrainedToAxis: constrainedToAxis))
            .targetedToAnyEntity()
            .onChanged { value in
                if sourceTransform == nil {
                    sourceTransform = value.entity.transform
                }
                if let rotation = value.second?.rotation {
                    let rotationTransform = Transform(AffineTransform3D(rotation: rotation))
                    value.entity.transform.rotation = sourceTransform!.rotation * rotationTransform.rotation
                } else if let translation = value.first?.translation3D {
                    let convertedTranslation = value.convert(translation, from: .local, to: value.entity.parent!)
                    value.entity.transform.translation = sourceTransform!.translation + convertedTranslation
                }
            }
            .onEnded { _ in
                sourceTransform = nil
            }
    }
    
}
