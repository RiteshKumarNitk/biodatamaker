# Preview run doc — Biodata Maker (Flutter)

Flutter app with web support (`web/` exists). There is no Node/npm toolchain; the
dev server is Flutter's built-in web server (`flutter run -d web-server`), which
serves a debug-compiled version of the app over HTTP. Preview URL:
http://localhost:8080

## Reproduce uncommitted artifacts

There are no secret/env files to copy for this project. The only setup step a
fresh checkout needs is installing Dart/Flutter dependencies:

```
flutter pub get
```

(Compilation artifacts for `flutter run -d web-server` are produced
automatically under `build/` and `.dart_tool/` — no manual step.)

## Run the server

Start it detached so it outlives the conversation (Windows recipe):

```
powershell -NoProfile -Command "(Start-Process -FilePath 'flutter.bat' -ArgumentList 'run','-d','web-server','--web-port','8080','--web-hostname','localhost' -RedirectStandardOutput '<log>' -RedirectStandardError '<log>.err' -WindowStyle Hidden -PassThru).Id"
```

- stdout and stderr must go to different files (`<log>` and `<log>.err`).
- The executable name must be exact: `flutter.bat` (PowerShell's
  `Start-Process` does not resolve shell shims).
- Confirm it survived: `powershell -NoProfile -Command "Get-Process -Id <pid>"`.

Then wait for the server to answer before using the preview:

```
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080
```

First compile of a large app takes a few minutes; the page only becomes
interactive once `flutter run` finishes building `main.dart.js` (watch the log).

If port 8080 is taken, pick a free port and pass `--web-port <port>` instead.
