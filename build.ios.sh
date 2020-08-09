set -xe


exit
(cd mobile && flutter build ios)
(cd mobile/ios && bundle update && bundle exec fastlane beta)
