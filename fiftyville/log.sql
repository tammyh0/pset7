-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Get more information about the crime scene: "295 | Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse. 
-- Interviews were conducted today with three witnesses who were present at the time — each of their interview transcripts mentions 
-- the courthouse."
SELECT id, description FROM crime_scene_reports WHERE street LIKE "Chamberlin%" AND month = 7 AND day = 28 AND year = 2020;

-- Get information about the interviews with the three witnesses:
-- 161 | Ruth | Sometime within ten minutes of the theft, I saw the thief get into a car in the courthouse parking lot and drive away. 
-- If you have security footage from the courthouse parking lot, you might want to look for cars that left the parking lot in that time 
-- frame.
-- 162 | Eugene | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at the courthouse, 
-- I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.
-- 163 | Raymond | As the thief was leaving the courthouse, they called someone who talked to them for less than a minute. In the call, 
-- I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. 
-- The thief then asked the person on the other end of the phone to purchase the flight ticket.
SELECT id, name, transcript FROM interviews WHERE year = 2020 AND month = 7 AND day = 28 AND transcript LIKE "%thief%";

-- Check security footage within ten minutes (10:05-10:25am) of the theft for cars leaving the courthouse parking lot:
-- Possible license plates include (plate, minute):
-- 5P2BI95 | 16
-- 94KL13X | 18 
-- 6P58WS2 | 18
-- 4328GD8 | 19 
-- G412CB7 | 20
-- L93JTIZ | 21 
-- 322W7JE | 23 
-- 0NTHK55 | 23
SELECT license_plate, minute FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit";

-- Check atm transactions on Fifer Street for withdrawals:
-- Possible results include (account number, amount):
-- 28500762 | 48
-- 28296815 | 20
-- 76054385 | 60
-- 49610011 | 50
-- 16153065 | 80
-- 25506511 | 20
-- 81061156 | 30
-- 26013199 | 35
SELECT account_number, amount FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location = "Fifer Street" AND transaction_type = "withdraw";

-- Check for phone calls between accomplice and thief:
-- Possible numbers (caller aka thief, receiver) aka accomplice:
-- (130) 555-0289 | (996) 555-8899
-- (499) 555-9472 | (892) 555-8872
-- (367) 555-5533 | (375) 555-8161
-- (499) 555-9472 | (717) 555-1342
-- (286) 555-6063 | (676) 555-6554
-- (770) 555-1861 | (725) 555-3243
-- (031) 555-6622 | (910) 555-3251
-- (826) 555-1652 | (066) 555-9701
-- (338) 555-6650 | (704) 555-2131
SELECT caller, receiver FROM phone_calls WHERE year = 2020 AND month = 7 AND day = 28 AND duration < 60;

-- Find more information about the earliest flight out of Fiftyville on 7/29/2020
-- origin airport id, destination airport id, hour, minute
-- earliest flight out of fiftyville had destination airport id of 4
-- 36 | 8 | 4 | 8 | 20 *
-- 8 | 1 | 9 | 30
-- 8 | 11 | 12 | 15
-- 8 | 9 | 15 | 20
-- 8 | 6 | 16 | 0
SELECT id, origin_airport_id, destination_airport_id, hour, minute FROM flights WHERE year = 2020 AND month = 7 AND day = 29 ORDER BY hour;

-- Confirm information about the departing airport:
-- CSF | Fiftyville Regional Airport | Fiftyville
SELECT abbreviation, full_name, city FROM airports WHERE id = 8;

-- Determine the destination airport:
-- LHR | Heathrow Airport | London
SELECT abbreviation, full_name, city FROM airports WHERE id = 4;

-- Get more information about the passengers:
-- 7214083635 | 2A
-- 1695452385 | 3B
-- 5773159633 | 4A
-- 1540955065 | 5C
-- 8294398571 | 6C
-- 1988161715 | 6D
-- 9878712108 | 7A
-- 8496433585 | 7B
SELECT passport_number, seat FROM passengers WHERE flight_id = 36;

-- Get more info about possible bank accounts:
-- 686048 | 2010
-- 514354 | 2012
-- 458378 | 2012
-- 395717 | 2014
-- 396669 | 2014
-- 467400 | 2014
-- 449774 | 2015
-- 438727 | 2018
SELECT person_id, creation_year FROM bank_accounts WHERE account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location = "Fifer Street" AND transaction_type = "withdraw");

-- Narrow down people based on person id's from possible bank accounts:
-- Bobby | (826) 555-1652 | 9878712108 | 30G67EN
-- Elizabeth | (829) 555-5269 | 7049073643 | L93JTIZ
-- Victoria | (338) 555-6650 | 9586786673 | 8X428L0
-- Madison | (286) 555-6063 | 1988161715 | 1106N58
-- Roy | (122) 555-4581 | 4408372428 | QX4YZN3
-- Danielle | (389) 555-5198 | 8496433585 | 4328GD8
-- Russell | (770) 555-1861 | 3592750733 | 322W7JE
-- Ernest | (367) 555-5533 | 5773159633 | 94KL13X
SELECT id, name, phone_number, passport_number, license_plate FROM people WHERE id IN (SELECT person_id FROM bank_accounts WHERE account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location = "Fifer Street" AND transaction_type = "withdraw"));

-- Narrow down people based on license plate, passport number, phone number:
SELECT id, name, phone_number, passport_number, license_plate FROM people WHERE id IN (SELECT person_id FROM bank_accounts WHERE account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location = "Fifer Street" AND transaction_type = "withdraw"))
INTERSECT
SELECT id, name, phone_number, passport_number, license_plate FROM people WHERE license_plate IN (SELECT license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour = 10 AND activity = "exit")
INTERSECT 
SELECT id, name, phone_number, passport_number, license_plate FROM people WHERE passport_number IN (SELECT passport_number FROM passengers WHERE flight_id = 36)
INTERSECT
SELECT id, name, phone_number, passport_number, license_plate FROM people WHERE phone_number IN (SELECT caller FROM phone_calls WHERE year = 2020 AND month = 7 AND day = 28 AND duration < 60);

-- Identify accomplice
SELECT name FROM people WHERE phone_number = "(375) 555-8161";