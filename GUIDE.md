# Café Brasilidades — iOS App Guide

Welcome! This document explains what was built for you, how it works, and exactly what you need to do next to run it on your phone.

---

## What Was Built

You now have a **native iOS app** called **Café Brasilidades**. Think of it as a personal photo cloud for your coffee moments — every time you visit a café, you can photograph your drink, give it the café's name, and it gets added to a living, floating canvas of cards you can drag around.

### The idea in one sentence
> You take a photo → you name the place → the photo becomes a floating card on a warm beige canvas — and all your cards slowly drift around like they are floating in water.

---

## What Files Were Created

Everything lives inside the repository folder `CafeBrasilidades/`. Here is what was added:

```
CafeBrasilidades/                     ← your repository
│
├── CafeBrasilidades.xcodeproj/       ← the Xcode project file (open this!)
│   └── project.pbxproj               ← tells Xcode where all files are
│
└── CafeBrasilidades/                 ← the actual app source code
    ├── CafeBrasilidesApp.swift       ← app entry point (the "front door")
    ├── ContentView.swift             ← main screen layout
    ├── DesignSystem.swift            ← all colors used in the app
    │
    ├── Models/
    │   └── CoffeeEntry.swift         ← data model + saving/loading logic
    │
    ├── Views/
    │   ├── PhotoCloudView.swift      ← the floating photo canvas
    │   ├── PhotoCardView.swift       ← each individual photo card
    │   └── AddCoffeeView.swift       ← the "add a new moment" sheet
    │
    └── Assets.xcassets/              ← app icon and accent color
```

---

## How Each Part Works (Plain English)

### `CoffeeEntry.swift` — Your Data
Every coffee moment is stored as a `CoffeeEntry`. It holds:
- The **café name** you typed
- The **path to the photo** on your phone
- The **date** it was added
- The **position** of the card on screen (so it stays where you left it)
- A **random rotation** angle so each card tilts slightly differently
- Random **float numbers** that control how the card drifts

All entries are saved automatically to your phone's storage, so they survive closing the app.

---

### `PhotoCloudView.swift` — The Canvas
This is the beige background you see when the app opens. It:
- Draws a warm layered gradient (two soft radial glows, one from the top-left corner, one from the bottom-right)
- Lays out all your photo cards on it
- Shows a friendly empty message when you have no photos yet

---

### `PhotoCardView.swift` — Each Floating Card
This is the heart of the visual experience. Each card:

**Shape:** 152 × 203 points, with rounded corners (radius 22). This gives the 3:4 portrait format you wanted.

**Floating animation — the "water" effect:**
The card floats using two separate animations running at different speeds. The horizontal drift and the vertical drift are slightly out of sync (e.g., 3.2 seconds left-right, 4.1 seconds up-down). Because they don't match, the card traces a slow oval path — never repeating exactly. This is called a Lissajous pattern. It looks like something suspended in liquid.

Each card also gently "breathes" — scaling up and down by about 2% at its own pace.

**Dragging:**
- Grab a card → it lifts up (bigger, stronger shadow)
- The card tilts slightly in the direction you drag, like a physical object
- When you let go, it bounces into its new position with a spring — a bit of overshoot before settling (this is what makes it feel like water)
- A fast flick carries it further with momentum before it stops

**Long-press:** Hold a card for a moment → a menu appears with a "Remove" option.

---

### `AddCoffeeView.swift` — Adding a New Moment
Tap the `+` button at the bottom of the screen. A sheet slides up with:
1. A 3:4 photo area — tap it to choose a photo
2. A dialog: **Take Photo** (opens camera) or **Choose from Library**
3. A minimalist text field for the café name
4. An "add to cloud" button — only activates once you've typed a name

When you save, the photo is stored in the app's private folder on your phone and the card appears on the canvas.

---

### `DesignSystem.swift` — The Colors
Three colors define the whole app look:
| Name | Hex (approx) | Used for |
|---|---|---|
| `cafeBg` | `#F5F0EB` | Background, navigation bar |
| `cafeText` | `#47342A` | All text and icons |
| `cafeAccent` | `#B88560` | Accent tint (buttons, etc.) |

---

## Next Steps — What You Need to Do

### Step 1 — Install Xcode (if you haven't)
Xcode is Apple's free tool for building iOS apps. You need a **Mac** to use it.

1. Open the **App Store** on your Mac
2. Search for **Xcode**
3. Download and install it (it's large — about 12 GB, takes a while)
4. Once installed, open Xcode at least once so it finishes setting up

> **Minimum version needed:** Xcode 15 (for iOS 17 features used in this app)

---

### Step 2 — Get the Code onto Your Mac
You need to download the repository from GitHub.

**Option A — Using Terminal (simple):**
1. Open the **Terminal** app on your Mac
2. Run this command (replace the URL with your actual GitHub repo URL):
```bash
git clone https://github.com/yoonsungj04/CafeBrasilidades.git
```
3. This creates a `CafeBrasilidades` folder on your Mac

**Option B — Using GitHub Desktop (easier for beginners):**
1. Download [GitHub Desktop](https://desktop.github.com)
2. Sign in with your GitHub account
3. Go to **File → Clone Repository**, find `CafeBrasilidades`, and clone it

---

### Step 3 — Open the Project in Xcode
1. Open **Finder** and navigate to the `CafeBrasilidades` folder you just downloaded
2. Find the file called `CafeBrasilidades.xcodeproj` (it has a blue Xcode icon)
3. Double-click it — Xcode opens your project

---

### Step 4 — Run on the Simulator
The simulator lets you test the app on a virtual iPhone on your Mac, no physical phone needed.

1. At the top of Xcode, you'll see a bar with a **play button ▶** and a device selector
2. Click the device selector and choose something like **iPhone 15 Pro**
3. Press the **▶ play button**
4. Xcode will build the app (takes 30–60 seconds the first time) and open the simulator
5. You should see the beige canvas with the `+` button at the bottom

> **Note:** The camera won't work in the simulator — use "Choose from Library" to pick photos from the simulator's built-in sample photos instead.

---

### Step 5 — Run on Your Real iPhone (Optional but Recommended)
To use the camera and feel the real animations:

1. Connect your iPhone to your Mac with a USB cable
2. On your iPhone, tap **Trust** when it asks if you trust this computer
3. In Xcode's device selector, choose your iPhone (it will appear in the list)
4. You need a free **Apple ID** to sign the app:
   - Go to **Xcode → Settings → Accounts**
   - Add your Apple ID
5. In Xcode, click your project name in the left panel, then under **Signing & Capabilities**, set **Team** to your personal Apple ID
6. Press **▶ Play** — Xcode installs the app on your phone
7. On your iPhone, go to **Settings → General → VPN & Device Management** and trust your developer certificate

The app will now be on your home screen.

---

## What the App Does NOT Have Yet (Future Ideas)

These are things that could be added in the next version:

| Feature | Description |
|---|---|
| **Scrollable canvas** | Right now all cards live within the screen. A larger infinite canvas you can pan around would let you have dozens of cards |
| **Card size variety** | Cards could vary in size based on how often you visit a café, like a real word cloud |
| **Search / filter** | Find a card by café name |
| **Share a card** | Export a single card as an image to send to friends |
| **Map view** | See all your cafés on a map |
| **App icon** | A custom icon for the home screen (currently blank) |
| **Tap to open** | Tapping a card could open a full-screen view of the photo |
| **iCloud sync** | Your cloud syncs across all your Apple devices |

---

## Summary

| What | Done? |
|---|---|
| iOS SwiftUI project created | ✅ |
| Pastel beige background with depth gradients | ✅ |
| 3:4 rounded photo cards | ✅ |
| Water-like floating animation (Lissajous drift) | ✅ |
| Spring drag physics with momentum | ✅ |
| Camera + photo library support | ✅ |
| Café name labelled on each card | ✅ |
| Data saved between sessions | ✅ |
| Pushed to GitHub branch `claude/coffee-photo-cloud-app-8v3czq` | ✅ |

---

*Built with SwiftUI · Requires iOS 17 · Minimum Xcode 15*
