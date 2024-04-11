// The Swift Programming Language
// https://docs.swift.org/swift-book
// urL: https://github.com/Umain-Vision-Pro/UmainSpatialGestures

import RealityKit
import SwiftUI

@available(visionOS 1.0, *)
public extension View {
    /// Applies both drag and rotate gestures to a SwiftUI view, with an optional constraint to a specific rotation axis.
    ///
    /// This method allows a view to respond to both drag and rotation gestures, making it interactive in a 3D environment.
    /// The gestures can be constrained to a specific axis, providing more control over the view's movement and orientation.
    ///
    /// - Parameter constrainedToAxis: An optional `RotationAxis3D` that limits the rotation to a specific axis. If `nil`, rotation is not constrained.
    /// - Returns: A view that responds to both drag and rotate gestures.
    ///
    /// Example usage:
    /// ```
    /// RealityView { model
    ///     model.components.set(InputTargetComponent())
    ///     model.generateCollisionShapes(recursive: false/true)
    ///  }
    ///     .useDragAndRotateGesture(constrainedToAxis: .y)
    /// ```
    func useDragAndRotateGesture(constrainedToAxis: RotationAxis3D? = .xyz, behavior: HandActivationBehavior? = .automatic) -> some View {
        return self.gesture(CustomGestures.createDragAndRotateGesture(constrainedToAxis!, behavior!))
    }
    
    /// Applies a drag gesture to a SwiftUI view, making it interactive with drag actions.
    ///
    /// This method enhances the interactivity of a view by enabling it to respond to drag gestures. It is useful for creating draggable components within your user interface, allowing users to move views around within their parent view or container.
    ///
    /// - Returns: A view that responds to drag gestures, allowing it to be moved by the user.
    ///
    /// Example usage:
    /// ```
    /// RealityView { model
    ///     model.components.set(InputTargetComponent())
    ///     model.generateCollisionShapes(recursive: false/true)
    ///  }
    ///     .useDragGesture()
    /// ```
    func useDragGesture(behavior: HandActivationBehavior? = .automatic) -> some View {
        return self.gesture(CustomGestures.createDragGesture(behavior!))
    }
    
    /// Applies a rotation gesture to a SwiftUI view, optionally constrained to a specific axis.
    ///
    /// This method enables a view to be rotated by the user through gesture interactions. The rotation can be constrained to a specific axis, providing a controlled rotation experience. It's particularly useful for 3D views where you might want to limit rotation to maintain a certain orientation or for 2D views where you want to add interactive rotation behavior.
    ///
    /// - Parameter constrainedToAxis: An optional `RotationAxis3D` to limit the rotation to a specific axis. If `nil`, the rotation is unconstrained and the view can be rotated freely.
    /// - Returns: A view that responds to rotation gestures, with optional axis constraint.
    ///
    /// Example usage:
    /// ```
    /// RealityView { model
    ///     model.components.set(InputTargetComponent())
    ///     model.generateCollisionShapes(recursive: false/true)
    ///  }
    ///     .useRotateGesture(constrainedToAxis: .y)
    /// ```
    func useRotateGesture(constrainedToAxis: RotationAxis3D? = .xyz) -> some View {
        self.gesture(CustomGestures.createRotateGesture(constrainedToAxis!))
    }
    
    /// Applies a magnification gesture to a SwiftUI view, allowing it to be scaled up or down.
    ///
    /// This method enables interactive scaling of a view through pinch gestures, commonly used to zoom in or out. It's especially useful for images, maps, or any content where users might benefit from examining details more closely or seeing the bigger picture by adjusting the view's scale.
    ///
    /// - Returns: A view that responds to magnification gestures, permitting dynamic scaling.
    ///
    /// Example usage:
    /// ```
    /// RealityView { model
    ///     model.components.set(InputTargetComponent())
    ///     model.generateCollisionShapes(recursive: false/true)
    ///  }
    ///     .useMagnifyGesture()
    /// ```
    internal func useMagnifyGesture() -> some View {
        self.gesture(CustomGestures.createMagnifyGesture())
    }
    
    /// Applies a combined drag and magnification gesture to a SwiftUI view.
    ///
    /// This method allows a view to respond to both drag and pinch (magnification) gestures simultaneously. It enables interactive movement and scaling of the view, making it useful for creating more dynamic and engaging UI components where the user can adjust both position and size.
    ///
    /// - Returns: A view that responds to both drag and magnification gestures, allowing it to be moved and scaled by the user.
    ///
    /// Example usage:
    /// ```
    /// RealityView { model
    ///     model.components.set(InputTargetComponent())
    ///     model.generateCollisionShapes(recursive: false/true)
    ///  }
    ///     .useDragAndMagnifyGesture()
    /// ```
    func useDragAndMagnifyGesture(behavior: HandActivationBehavior? = .automatic) -> some View {
        return self.gesture(CustomGestures.createDragAndMagnifyGesture(behavior!))
    }
    
    /// Applies a comprehensive set of gestures to a SwiftUI view, including drag, magnification, and rotation, with an optional constraint to a rotation axis.
    ///
    /// This method combines drag, magnify, and rotation gestures into a single, unified interaction model. It allows for complex manipulation of a view, including moving, scaling, and rotating, which can be particularly useful for interactive 3D content or detailed user interfaces. The rotation can be constrained to a specific axis, providing greater control over the view's orientation.
    ///
    /// - Parameter constrainedToAxis: An optional `RotationAxis3D` to limit the rotation to a specific axis. If `nil`, rotation is unconstrained and the view can be freely rotated.
    /// - Returns: A view that responds to a combination of drag, magnification, and rotation gestures, with an optional constraint on the rotation axis.
    ///
    /// Example usage:
    /// ```
    /// RealityView { model
    ///     model.components.set(InputTargetComponent())
    ///     model.generateCollisionShapes(recursive: false/true)
    ///  }
    ///     .useFullGesture(constrainedToAxis: .y)
    /// ```
    func useFullGesture(constrainedToAxis: RotationAxis3D? = .xyz, behavior: HandActivationBehavior? = .automatic) -> some View {
        return self.gesture(CustomGestures.createFullGesture(constrainedToAxis!, behavior!))
    }
}

struct CustomGestures {
    static func createFullGesture(_ constrainedToAxis: RotationAxis3D, _ behavior: HandActivationBehavior) -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .simultaneously(with: MagnifyGesture())
            .simultaneously(with: RotateGesture3D(constrainedToAxis: constrainedToAxis))
            .targetedToAnyEntity()
            .handActivationBehavior(behavior)
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
    
    static func createDragAndMagnifyGesture(_ behavior: HandActivationBehavior) -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .simultaneously(with: MagnifyGesture())
            .targetedToAnyEntity()
            .handActivationBehavior(behavior)
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
    
    static func createRotateGesture(_ constrainedToAxis: RotationAxis3D) -> some Gesture {
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
    
    static func createDragGesture(_ behavior: HandActivationBehavior) -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .targetedToAnyEntity()
            .handActivationBehavior(behavior)
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
    
    static func createDragAndRotateGesture(_ constrainedToAxis: RotationAxis3D, _ behavior: HandActivationBehavior) -> some Gesture {
        var sourceTransform: Transform?
        
        return DragGesture()
            .simultaneously(with: RotateGesture3D(constrainedToAxis: constrainedToAxis))
            .targetedToAnyEntity()
            .handActivationBehavior(behavior)
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
