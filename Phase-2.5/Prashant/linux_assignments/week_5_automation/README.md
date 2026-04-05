# Week 5 - Automation Basics with C Build Script

## Why This Matters
Manual build steps are error-prone. Automation ensures repeatable output.

Hinglish analogy:
- Manual build is like roz handwritten recipe follow karna.
- Scripted build is like fixed recipe card: same steps, same result.

## Files in This Week
- `src/hello.c`: simple C Hello World program.
- `build.sh`: compiles and moves binary into `bin/`.

## Best Practices Used
- `set -e`: stops script on first failed command.
- `set -o pipefail`: pipeline errors are not silently ignored.

## Run Build
```bash
chmod +x build.sh
./build.sh
./bin/hello
```

## Why in Simple Terms
A build script saves time, avoids mistakes, and makes onboarding easier for new developers.
One command and everything is ready.
