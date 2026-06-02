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

Two GitHub Actions workflows:

| Workflow | Trigger | What it does |
|---|---|---|
| `ci.yml` | Push/PR to `main` | Lint + build without code signing |
| `release.yml` | GitHub Release published or manual dispatch | Lint + archive + export + upload to TestFlight |

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

- `AlertaApp/Core/Services/AudioAwareness/MicrophonePermissionProviding.swift`
  Defines a protocol that describes permission behavior.
- `AlertaApp/Core/Services/AudioAwareness/SystemMicrophonePermissionProvider.swift`
  Implements the protocol by talking to Apple system APIs.
- `AlertaApp/Features/Awareness/AwarenessViewModel.swift`
  Injects `MicrophonePermissionProviding` and reacts to permission state.

Do not put microphone permission logic directly in a SwiftUI view. Views should render state and send user actions to the view model.

Example: splitting a large feature view.

- `AlertaApp/Features/Awareness/AwarenessView.swift`
  Owns feature layout and connects state to child views.
- `AlertaApp/Features/Awareness/Components/DirectionIndicatorView.swift`
  Renders directional compass for spatial awareness.
- `AlertaApp/Features/Awareness/Components/FrequencyBarsView.swift`
  Renders live frequency band visualization.

Do not create a new view model for every small component. Start with typed input properties and closures for user actions.

Example: promoting a component to the design system.

- Keep `DirectionIndicatorView` in `Features/Awareness/Components/` while only the awareness feature uses it.
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

## Release to TestFlight

Releases are built and uploaded via GitHub Actions CI. You trigger a release by creating a GitHub Release.

### Prerequisites

An App Store Connect API Key is required for the CI workflow (one-time setup):

1. Go to [App Store Connect → Users and Access → Integrations → App Store Connect API](https://appstoreconnect.apple.com/access/integrations/api)
2. Create a key with **Developer** role
3. Download the `.p8` file
4. Add three GitHub Secrets:

| Secret | Value |
|---|---|
| `APPSTORE_KEY_ID` | Key ID from App Store Connect |
| `APPSTORE_ISSUER_ID` | Issuer ID from App Store Connect |
| `APPSTORE_API_KEY_BASE64` | `base64 -i AuthKey_XXXXXXXXXX.p8` |

Go to **GitHub → Settings → Secrets and variables → Actions** and add them.

### How to release

1. Run the pre-flight check locally:
   ```bash
   scripts/release.sh
   ```
   This verifies clean git, `main` branch, synced with remote, and lint + build pass.

2. Create a GitHub Release:
   - Go to **GitHub → Releases → Draft a new release**
   - Tag: `vX.Y.Z` (e.g., `v1.0.0`)
   - Write release notes
   - Click **Publish release**

3. CI runs automatically:
   - Checks out the tagged commit
   - Increments the build number
   - Archives the app (Release configuration)
   - Exports an `.ipa`
   - Uploads to App Store Connect (TestFlight)

4. The build appears in TestFlight within minutes. It enters Apple's beta review before external distribution.

### Manual trigger

To upload without creating a release:

- Go to **GitHub → Actions → Release to TestFlight → Run workflow**
- Toggle "Increment build number" as needed
- Click **Run workflow**
