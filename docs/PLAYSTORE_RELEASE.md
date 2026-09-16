# VivahBio — Play Store Release Checklist

App: **VivahBio** (biodata_maker)
Package: `com.biodatamaker.biodata_maker`
Current version: `1.0.0+1` (versionName 1.0.0, versionCode 1)

Yeh doc Play Store par app upload karne ke poore process ko cover karta hai — technical
pre-checks se lekar store listing content aur mandatory declarations tak.

---

## 1. Critical fixes — upload se PEHLE zaroor karein

- [ ] **AdMob App ID real karo.** `android/app/src/main/AndroidManifest.xml` mein abhi
      Google ka **sample/test** App ID hai:
      `ca-app-pub-3940256099942544~3347511713`
      Isse apne AdMob account ke real App ID se replace karo, warna production mein bhi
      sirf test ads chalenge (ya app AdMob policy violation mein fas sakta hai). Saath hi
      code mein jahan bhi ad unit IDs (banner/interstitial/rewarded) test IDs se hardcoded
      hain unhe bhi real unit IDs se replace karo.
- [ ] **Privacy Policy ko public URL par host karo.** Abhi app ke andar ek in-app
      `PrivacyPolicyScreen` hai (`lib/features/settings/presentation/screens/privacy_policy_screen.dart`),
      lekin Play Console ko ek **publicly accessible web page** (http/https link) chahiye
      Data Safety section mein daalne ke liye — sirf in-app screen kaafi nahi hai. Same
      content ko GitHub Pages / apni website par host karke ek URL banao.
- [ ] **Support email verify karo.** Privacy policy mein `support@biodatamaker.app` diya
      hai — confirm karo ki yeh ek real, monitored inbox hai (Play Console isko contact
      ke roop me maangta hai).
- [ ] **Keystore backup.** `android/key.properties` aur uska `.jks`/`.keystore` file
      (dono `.gitignore` me hain, git me commit nahi hain — yeh sahi hai) ka secure backup
      kahin aur (password manager / encrypted drive) rakho. Yeh kho gaya to future updates
      Play Store par publish nahi kar paoge — Google isko recover nahi karta.
- [ ] **google-services.json** — confirm karo ki Firebase project production ke liye hi
      hai (test/dev project nahi).

---

## 2. Build ke pehle technical checklist

- [ ] Version bump: har naye upload ke liye `pubspec.yaml` me `version:` badhao
      (e.g. `1.0.0+1` → `1.0.1+2`). `versionCode` (naya `+2`) hamesha purane se bada hona
      chahiye.
- [ ] `flutter analyze` aur `flutter test` clean run ho.
- [ ] Permissions check — Manifest me sirf yeh hain, dono justified hain:
      - `INTERNET` (ads, Google Sign-In, IAP)
      - `WRITE_EXTERNAL_STORAGE` (maxSdk 29, sirf Android 10 aur neeche gallery save ke liye)
      Extra/unused permission mat rakho — Play Console permission declaration flag karta hai.
- [ ] Target SDK current Play requirement match kare (Flutter apne aap latest stable
      `compileSdk`/`targetSdk` use karta hai — `flutter upgrade` aur `flutter doctor`
      recent rakho taaki naya "target API level" policy fail na ho).
- [ ] Release build banao aur real device par internal testing track se test karo
      (sirf debug build test karke upload mat karo).

### Release AAB build karne ka command

```powershell
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab` — yahi file Play Console par
upload hogi (APK nahi, **AAB** mandatory hai).

---

## 3. Play Console — App setup

1. [Play Console](https://play.google.com/console) par naya app create karo (agar pehli
   baar hai).
2. App details: Naam **VivahBio**, default language **Hindi** (ya English — jo primary
   audience ke hisaab se sahi ho), App/Game → App, Free/Paid → Free (with in-app purchases).
3. Declarations: Developer Program Policies + US export laws accept karo.

### Store Listing content (draft)

**App name:** VivahBio – Marriage Biodata Maker

**Short description** (80 chars max):
> Shaadi ke liye sundar biodata banayein — free templates, instant PDF export.

**Full description** (draft — polish/localize as needed):
> VivahBio ke saath apna marriage biodata kuch hi minutes mein banayein — bina kisi
> design skill ke.
>
> ✅ Premium, ready-made Hindi & English templates
> ✅ Photo add karke professional biodata PDF banayein
> ✅ Offline kaam karta hai — data aapke phone par hi surakshit rehta hai
> ✅ Instant PDF export aur WhatsApp/Email par direct share
> ✅ Simple step-by-step form — Personal, Family, Contact details
>
> Shaadi.com, matrimony sites ya rishtedaron ko bhejne ke liye perfect biodata format,
> chutki bhar mein.

- [ ] App icon — 512×512 PNG (32-bit, alpha channel ke saath), high-res version of
      `assets/icon.png`.
- [ ] Feature graphic — 1024×500 PNG/JPG (banner, no transparency).
- [ ] Screenshots — kam se kam 2, phone ke liye 16:9 ya 9:16, min side 320px, max 3840px
      (form screen, template gallery, PDF preview, share screen ke screenshots achhe rahenge).
- [ ] Category: **Lifestyle** ya **Productivity** (jo best fit lage).
- [ ] Contact details: email (support@biodatamaker.app — verify), phone (optional), website
      (optional).

---

## 4. App Content — mandatory declarations

Play Console → App content section me yeh sab fill karna zaroori hai, warna app publish
nahi hoga:

- [ ] **Privacy Policy** — hosted URL daalo (point 1 dekho).
- [ ] **Ads** — "Yes, my app contains ads" select karo (AdMob use ho raha hai).
- [ ] **App access** — agar app me koi login-gated feature nahi hai jo reviewer access na
      kar paaye, "All functionality is available without special access" select karo.
      Agar Google Sign-In mandatory hai kisi feature ke liye, test credentials provide
      karne padenge.
- [ ] **Content rating questionnaire** — IARC questionnaire fill karo. Yeh app violence/
      adult content free hai, so "Everyone" rating milna chahiye.
- [ ] **Target audience & content** — age groups select karo (13+ ya jo applicable ho).
      "Is your app designed for children" → No.
- [ ] **Data safety section** — data collection/sharing declare karna hoga. Is app ke
      structure ke hisaab se (Hive offline-first local storage):
      - **Photos** — Collected? User apni photo add karta hai biodata ke liye. Agar sirf
        local device par store hoti hai (share/export ke alawa kahin upload nahi hoti),
        to "Not shared, processed ephemerally / stored on device" declare karo. Agar
        Google Sign-In ya future cloud sync feature use hota hai, to accordingly update
        karo.
      - **Personal info** (Name, phone, email jo user biodata form me bharta hai) — same
        logic: agar sirf local device pe rehta hai to "collected but not shared", data
        deletion option app me hona chahiye (settings me "clear data" jaisa option).
      - **Google Sign-In** hai to "Email address", "User IDs" collection declare karo
        (Google ki OAuth policy ke through).
      - **In-app purchases (`in_app_purchase` package)** — "Purchase history" data type
        declare karo (Google/Apple billing ke through collect hota hai).
      - **Ads (AdMob)** — Advertising ID collection declare karo (`google_mobile_ads` ka
        standard behavior), aur "Data used for advertising or marketing" flag karo.
      - Security practices: "Data is encrypted in transit" (HTTPS calls), "Users can
        request data deletion" — agar sab data sirf local hai to yeh easy hai (uninstall
        se hi data delete ho jaata hai) — waise bhi declare karna hoga.
- [ ] **Financial features** — In-app purchases hai, so "Purchases" declare karo agar
      section available ho.
- [ ] **Government apps, COVID-19, News apps** — Not applicable, "No" select karo.

---

## 5. Testing track & rollout (naya developer account note)

Google ne 2023 se **naye personal developer accounts** ke liye requirement rakhi hai: production
access milne se pehle kam se kam **12 testers ko 14 din tak closed testing** track par app
use karana zaroori hai. Agar yeh pehla app hai is developer account se:

1. [ ] Pehle **Internal testing** track par AAB upload karo, khud test karo.
2. [ ] Fir **Closed testing** track banao, 12+ testers add karo (email list ya Google Group),
       kam se kam 14 din active testing chalao.
3. [ ] Uske baad hi **Production** track unlock hoga.

Agar yeh account already established hai (pehle se koi app live hai), to seedha production
release possible ho sakta hai.

---

## 6. Final pre-submit checklist

- [ ] Real AdMob App ID + ad unit IDs set
- [ ] Privacy policy publicly hosted, URL Play Console me daala
- [ ] Release AAB signed with production keystore, tested on real device
- [ ] Store listing (title, descriptions, icon, feature graphic, screenshots) ready
- [ ] Content rating questionnaire submitted
- [ ] Data safety form filled accurately
- [ ] In-app purchase products created & activated in Play Console (Monetize → Products)
      matching the product IDs used in code
- [ ] Version code/name bumped from last upload
- [ ] Keystore securely backed up outside the repo

---

## Reference commands

```powershell
# Bump version in pubspec.yaml first, then:
flutter clean
flutter pub get
flutter build appbundle --release
```

Upload hoga: `build/app/outputs/bundle/release/app-release.aab`
