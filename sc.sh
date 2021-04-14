echo 'Cleaning the build...'
flutter clean
echo 'Building apk now..'
flutter build apk --release
echo 'Build complete!'