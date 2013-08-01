# SpeedPwn

SpeedPwn is a Ruby application that can generate a list of possible passwords
for SpeedTouch/Thomson routers. BT Home hubs are not supported because they're
not used here in The Netherlands.

Originally I wrote a Python script (which can be found in
`nostalgia/speedpwn.py`) back in early 2009 to do this and I've used it over
the years. After using it for almost 4 years I decided it was time I'd rewrite
it in a decent way.

The algorithm used itself is nothing new and has been around since 2008. More
information about this can be found on the following web pages:

* <http://www.gnucitizen.org/blog/default-key-algorithm-in-thomson-and-bt-home-hub-routers/>
* <http://www.mentalpitstop.com/touchspeedcalc/calculate_speedtouch_default_wep_wpa_wpa2_password_by_ssid.html>

In plain English the algorithm for the default passwords can be described as
"Very dumb".

## Requirements

* Ruby 1.9.3 or newer
* OpenSSL

## Installation

Install it from RubyGems:

    gem install speedpwn

Unlike other projects this one is not signed in any way. I consider it more of
a quick hobby/joke project and thus don't really want to bother with signing,
checksums, etc. Install at your own risk.

## Usage

Once installed, run it and pass the last 6 characters of the SSID:

    speedpwn C28B9B

Generating the list of passwords can take a few minutes so go make some
tea/coffee while you wait for it to complete.

## License

All source code in this repository is licensed under the MIT license unless
specified otherwise. A copy of this license can be found in the file "LICENSE"
in the root directory of this repository.
