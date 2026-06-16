# What We Built — Café Brasilidades
### A beginner's guide to everything created in this session

---

## 🗂 What is this repository?

A **repository** (or "repo") is like a project folder that lives on GitHub and keeps track of every change ever made. Think of it as Google Docs for code — it saves every version automatically.

Your repository is at:
```
github.com/yoonsungj04/CafeBrasilidades
```

Everything we built is inside this folder, organised like this:

```
CafeBrasilidades/
│
├── index.html              ← The V60 timer app (was already there)
├── logobrasilidades.png    ← Your brand logo
│
├── journal/
│   └── index.html          ← Web journal, version 1
│
├── journal-v2/
│   ├── index.html          ← Web journal, version 2 (PWA — works like an app)
│   └── manifest.json       ← Tells iPhone "treat this as a real app"
│
└── CafeJournal-iOS/        ← Native iOS app source code (for Xcode)
    ├── Models.swift
    ├── CoffeeStore.swift
    ├── CafeBrasiliadesApp.swift
    ├── ContentView.swift
    ├── JournalView.swift
    ├── AddEntryView.swift
    └── InsightsView.swift
```

---

## 🌐 The Web Versions (journal/ and journal-v2/)

These are HTML files — the same language used to build every website. You open them in Safari, Chrome, or any browser.

### Version 1 — `journal/index.html`

A basic web journal with:
- A list of coffee entries shown as cards
- A **+** button to add a new entry
- Swipe left to see the **Insights** page
- Ratings (0–5) for Bitterness, Sweetness, Acidity, Body, and Overall
- Brew method chips (V60, Chemex, AeroPress, etc.)
- Technique chips (James Hoffman, 4:6 Kasuya, etc.)
- Coffee and water amounts
- Photo upload
- A calendar showing days you brewed

### Version 2 — `journal-v2/` (PWA)

This is a **PWA — Progressive Web App**. It is still a website but it behaves like a native app when you save it to your iPhone home screen. Improvements over v1:

- Animated glowing background (the brand deep greens)
- True frosted-glass "liquid glass" design (like iOS)
- Photos show full-width at the top of each card
- Automatically calculates and shows the coffee-to-water ratio (e.g. 1 : 16.7)
- Diamond radar chart in Insights to visualise your average flavour profile
- Sliders fill with colour as you drag them
- You can swipe the form sheet downward to close it
- A trash/delete button appears when editing an existing entry

### ⚠️ Important — where data is stored

Both web versions save data in **localStorage**. This means:
- Data is saved **only in the browser on that specific device**
- If you clear your browser history or switch phones, the data is gone
- It does NOT sync between devices

**This is fine for testing**, but for a real product you would need a cloud database (we will talk about this in Next Steps below).

---

## 📱 The Native iOS App — `CafeJournal-iOS/`

This is a real Swift/SwiftUI application — the same language Apple uses for every iPhone app. It needs **Xcode** (Apple's free development tool for Mac) to compile and run.

### What each file does

| File | What it does |
|------|-------------|
| `Models.swift` | Defines the data shapes — what a "coffee entry" looks like, the brand colours, the list of brew methods and techniques |
| `CoffeeStore.swift` | Manages saving and loading entries. Works like a small database stored on the phone |
| `CafeBrasiliadesApp.swift` | The entry point — the first thing that runs when the app opens. Sets the dark glass style for the tab bar and navigation bar |
| `ContentView.swift` | The main screen — a tab bar with two tabs: Diário and Insights |
| `JournalView.swift` | The **Diário** tab — shows the list of entry cards and the yellow + button |
| `AddEntryView.swift` | The form that slides up when you tap + (or tap an existing card to edit it) |
| `InsightsView.swift` | The **Insights** tab — radar chart, average bars, best/worst cards, calendar |

### What the app includes

**Diário (Journal) tab:**
- Cards with full-width photo, brew method, overall score, and dot ratings
- Best cup gets a green glow and "★ Melhor" badge
- Worst cup gets a red glow and "▾ Pior" badge
- Yellow FAB (+) button to add a new entry

**Add/Edit form:**
- Photo picker (camera or library)
- Date and time (auto-filled to right now, but editable)
- Brew method chips: V60, Chemex, AeroPress, French Press, Moka, Espresso, Cold Brew, Livre
- Technique chips: James Hoffman, 4:6 Kasuya, Scott Rao, Osmotic Flow, Livre
- Coffee (g) and Water (g) with live ratio calculation
- Brew time field
- Five sliders 0–5: Amargor, Doçura, Acidez, Corpo, Nota Geral
- Notes text field
- Delete button (when editing an existing entry)

**Insights tab:**
- Average overall score + total cup count
- Radar chart (diamond shape) showing your average flavour profile
- Bar chart with average per flavour dimension
- Highlight card for best cup (green)
- Highlight card for worst cup (red)
- Monthly calendar with dots on days you brewed

---

## ✅ Next Steps — What You Need To Do

### Step 1 — See the web app on your iPhone (right now, today)

1. Go to `github.com/yoonsungj04/CafeBrasilidades` in Safari **on your computer**
2. Click **Settings** → scroll down to **Pages** (in the left sidebar)
3. Under "Branch", select `main` and `/ (root)`, then click **Save**
4. Wait about 60 seconds, then your apps will be live at:

```
https://yoonsungj04.github.io/CafeBrasilidades/journal-v2/
```

5. Open that URL in **Safari on your iPhone**
6. Tap the **Share button** (the box with an arrow) → **"Add to Home Screen"**
7. It now opens full-screen like a native app — no browser bar visible

---

### Step 2 — Open the Swift app in Xcode

> You need a Mac with Xcode installed. Download Xcode free from the Mac App Store.

**Step-by-step:**

1. Open Xcode → **File → New → Project**
2. Choose **App** (under iOS) → click Next
3. Set the name to `CafeBrasilidades` and make sure:
   - Interface: **SwiftUI**
   - Language: **Swift**
4. Save the project somewhere on your Mac
5. In the left panel (Project Navigator), **delete** the two files Xcode created:
   - `ContentView.swift`
   - `CafeBrasiliadesApp.swift`
   - (Right-click → Move to Trash)
6. Go to your GitHub repo, download the `CafeJournal-iOS/` folder (or clone the repo)
7. **Drag all 7 Swift files** from that folder into Xcode's left panel
   - When asked, check ✅ "Copy items if needed"
8. Add photo permissions to `Info.plist`:
   - Click your project name at the top of the left panel
   - Go to the **Info** tab
   - Click **+** to add a new row and add:
     - `Privacy - Photo Library Usage Description` → `Para adicionar fotos às suas entradas de café`
     - `Privacy - Camera Usage Description` → `Para fotografar seu café`
9. Plug in your iPhone (or use the simulator)
10. Press the **▶ Play button** — the app will build and launch

---

### Step 3 — Add a real database (when you're ready to go further)

Right now the web versions save data only on the device (localStorage). For a proper product, you want data to:
- Sync across devices
- Never be lost
- Support multiple users

The easiest free solution is **Supabase** (supabase.com):
- Free to start
- Gives you a real PostgreSQL database in the cloud
- Provides login (email or Google/Apple)
- Works by replacing a few lines of code in the HTML files

When you are ready for this step, come back and ask — it is a straightforward upgrade.

---

### Step 4 — Publish the iOS app to the App Store (future goal)

To put the app on the App Store you will need:
- An **Apple Developer Account** ($99/year at developer.apple.com)
- A few extra configuration steps in Xcode (app icon, bundle ID)
- Submit through **Xcode → Product → Archive → Distribute**

This is a longer process but very doable once the app is working the way you want.

---

## 💡 Ideas We Discussed for Future Features

From the brainstorming at the start of the session:

| Idea | Complexity |
|------|------------|
| Connect journal to the V60 timer (auto-fill brew time) | Medium |
| Bean freshness countdown (days since roast) | Easy |
| Water chemistry calculator | Medium |
| Roast profile tracker for home roasters | Hard |
| Share a cup entry as a beautiful image card | Medium |
| Real cloud database (Supabase) | Medium |
| App Store submission | Medium |

---

## 🎨 Brand Identity Used

Everything follows the Café Brasilidades brand:

| Element | Value |
|---------|-------|
| Primary green | `#1a6b3a` |
| Deep green | `#0d3b21` |
| Yellow | `#f5c800` |
| Cream | `#f7f2e8` |
| Dark | `#0d1f14` |
| Headline font | Archivo Black |
| Body font | Space Grotesk |
| Language | Portuguese (pt-BR) |
| Tagline | *O Café Ousado e Alegre* |

---

*Generated with Claude Code — Café Brasilidades session, June 2026*
