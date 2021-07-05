#!/usr/bin/env ruby

puts "Checking that version is set correctly..."
git_version = `git describe`.strip.split("-").first # this is the most recent tag
file_version = File.open('VERSION').first.strip
search_result = `grep #{file_version} ./Paystack/PublicHeaders/PSTCKAPIClient.h`

if search_result.length == 0
  abort("VERSION does not match PSTCKSDKVersion in PSTCKAPIClient.h")
end

if ENV["TRAVIS_BRANCH"] == "master"

  if git_version > "v#{file_version}"
    abort("Current git tag is greater than VERSION, did you forget to increment it?")
  end

end

puts "Done!"
