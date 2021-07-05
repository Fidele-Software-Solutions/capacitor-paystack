#!/bin/sh

if [[ $CI && "$TRAVIS_SECURE_ENV_VARS" != "true" ]]; then
  echo "Skipping Faux Pas linting."
  exit 0
fi

echo "Linting with Faux Pas..."
fauxpas check Paystack.xcodeproj/ --target "PaystackiOSStatic" --configFile "./ci_scripts/FauxPasConfig/main.fauxpas.json" --minErrorStatusSeverity Concern && fauxpas check Paystack.xcodeproj/ --target "PaystackOSX" --configFile "./ci_scripts/FauxPasConfig/main.fauxpas.json" --minErrorStatusSeverity Concern
