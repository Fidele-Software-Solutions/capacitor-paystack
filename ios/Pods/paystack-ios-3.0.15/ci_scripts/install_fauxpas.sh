if [[ $CI && "$TRAVIS_SECURE_ENV_VARS" != "true" ]]; then
  echo "Skipping Faux Pas installation."
  exit 0
fi

brew install caskroom/cask/brew-cask
brew cask install fauxpas
$HOME/Applications/FauxPas.app/Contents/Resources/install-cli-tools
fauxpas updatelicense "organization-seat" "Paystack, Inc" $FAUX_PAS_LICENSE
# Enable beta xcode 7 support
defaults write org.hasseg.fauxpas experimentalXcode7SupportEnabled -bool yes
