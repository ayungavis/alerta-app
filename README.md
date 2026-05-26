# AlertaApp

AlertaApp is an iPhone-first SwiftUI project. The repository is organized so features can grow without turning views, services, or shared helpers into catch-all files.

## Requirements

- Xcode 26.5 or newer
- iOS 17.0 or newer
- Swift 5 language mode

## Setup

Resolve the project-managed developer tools:

```bash
scripts/bootstrap.sh
```

Run the full local check before opening a pull request:

```bash
scripts/check.sh
```

## Continuous Integration

GitHub Actions runs the same check used locally:

```bash
scripts/check.sh
```

The CI workflow resolves the project-managed Swift tools, runs SwiftFormat in lint mode, runs SwiftLint, and builds the iPhone app without code signing.

## Project Structure

`AlertaApp/App/` contains the application entry point and root composition. Keep this folder small. It should wire the app together, not contain feature logic.

`AlertaApp/Features/` contains product features. Each feature owns its views, view models, and feature-specific helpers. If code is only used by one feature, keep it inside that feature.

`AlertaApp/Features/<FeatureName>/Components/` contains small SwiftUI views used only by that feature. Components should accept typed input, emit user actions through closures when needed, and avoid owning business logic or calling services directly.

If a component becomes useful across multiple features, move it to `AlertaApp/DesignSystem/`.

`AlertaApp/Core/Domain/` contains shared app concepts represented as pure Swift structs and enums. These types should not call services, mutate global state, or depend on SwiftUI.

`AlertaApp/Core/Services/` contains interfaces and implementations for external systems such as networking, persistence, audio capture, SoundAnalysis, haptics, and system permissions. Prefer protocols for dependencies injected into view models.

`AlertaApp/Core/Extensions/` contains small Swift or SwiftUI extensions that are useful across multiple features. Feature-specific extensions should stay inside the feature folder.

`AlertaApp/Core/Utilities/` contains pure helper functions and typed utility objects such as formatters. Avoid global mutable state and avoid turning this folder into a catch-all.

`AlertaApp/Core/Errors/` contains shared error types with clear, actionable messages.

`AlertaApp/DesignSystem/` contains reusable styling primitives such as spacing, colors, typography, and shared SwiftUI components.

Empty folders use `.gitkeep` so the intended structure is visible before the first implementation lands. Remove `.gitkeep` once real source files exist in that folder.

## Where Should New Code Go?

Example: adding microphone permission support.

- `AlertaApp/Core/Services/Audio/MicrophonePermissionProviding.swift`
  Defines a protocol that describes permission behavior.
- `AlertaApp/Core/Services/Audio/SystemMicrophonePermissionProvider.swift`
  Implements the protocol by talking to Apple system APIs.
- `AlertaApp/Features/Awareness/AwarenessViewModel.swift`
  Injects `MicrophonePermissionProviding` and reacts to permission state.

Do not put microphone permission logic directly in a SwiftUI view. Views should render state and send user actions to the view model.

Example: splitting a large feature view.

- `AlertaApp/Features/Awareness/AwarenessView.swift`
  Owns feature layout and connects state to child views.
- `AlertaApp/Features/Awareness/Components/AwarenessStatusHeader.swift`
  Renders the status header for the awareness feature only.
- `AlertaApp/Features/Awareness/Components/AwarenessEmptyStateView.swift`
  Renders the empty state for the awareness feature only.

Do not create a new view model for every small component. Start with typed input properties and closures for user actions.

Example: promoting a component to the design system.

- Keep `AwarenessStatusHeader` in `Features/Awareness/Components/` while only the awareness feature uses it.
- Move a reusable button, badge, color, spacing value, or typography style to `AlertaApp/DesignSystem/` when multiple features need it.

## Dependency Direction

Features may depend on `Core` and `DesignSystem`.

`Core/Domain` should not depend on SwiftUI, services, or features.

Good:

```text
AwarenessView -> AwarenessViewModel -> MicrophonePermissionProviding
```

Avoid:

```text
AwarenessView -> AVAudioSession
```

## Development Commands

Format Swift files:

```bash
scripts/format.sh
```

Lint Swift files:

```bash
scripts/lint.sh
```

Build without code signing:

```bash
xcodebuild build -project AlertaApp.xcodeproj -scheme AlertaApp -configuration Debug -destination generic/platform=iOS CODE_SIGNING_ALLOWED=NO
```
