# Umain Spatial Gestures

# Custom Gestures Library for SwiftUI and RealityKit

This Swift package introduces a set of custom gesture extensions for SwiftUI and RealityKit, making it easier to implement complex gestures such as drag, rotate, magnify, or combinations of these within your SwiftUI applications.
## Installation
- Add this library to your Xcode project by including it in your package dependencies.

## Features

- **Drag Gesture**: Allows entities to be dragged across the screen.
- **Rotate Gesture**: Enables rotation of entities, with optional axis constraints.
- **Magnify Gesture**: Facilitates the scaling of entities through pinch gestures.
- **Combined Gestures**:
  - **Drag and Rotate**: Combines drag and rotate gestures for a seamless interaction.
  - **Drag and Magnify**: Allows entities to be dragged and scaled simultaneously.
  - **Full Gesture**: A comprehensive gesture combining drag, rotate, and magnify functionalities, with optional rotation axis constraints.

## Usage

### Importing the Library

Ensure you have imported SwiftUI and RealityKit in your Swift file:

```swift
import SwiftUI
import RealityKit
import UmainSpatialGestures
```

### Applying Gestures to Views
You can apply any of the custom gestures to your views using the provided extension methods. Here's how you can use each gesture:
```
YourView()
    .useDragGesture()
```
```
YourView()
    .useRotateGesture(constrainedToAxis: .someAxis) // Optionally specify an axis
```
```
YourView()
    .useMagnifyGesture()
```
```
YourView()
    .useDragAndRotateGesture(constrainedToAxis: .someAxis) // Optionally specify an axis
```
```
YourView()
    .useDragAndMagnifyGesture()
```
```
YourView()
    .useFullGesture(constrainedToAxis: .someAxis) // Optionally specify an axis
```
### Note: 
If you are using ModelEntity/Entity it has to contain 
- model.components.set(InputTargetComponent())
- model.generateCollisionShapes(recursive: false/true)

### Customization
- The gestures can be constrained to specific axes (for rotate gestures) by passing a RotationAxis3D value (xAxis, yAxis, zAxis, or nil for no constraint) to the constrainedToAxis parameter.

### Requirements
- iOS 13.0 or later
- Swift 5.0 or later
- Xcode 11.0 or later

### Contributing
Contributions are welcome! Please fork the repository and submit pull requests with your enhancements.

### Contact
[Robin Ellingsen](https://www.linkedin.com/in/swiftuirobin/)
[Alfred Skedebäck]([https://www.linkedin.com/in/swiftuirobin/](https://www.linkedin.com/in/alfred-skedeb%C3%A4ck-09650970/))
### License
This library is released under the MIT license.

