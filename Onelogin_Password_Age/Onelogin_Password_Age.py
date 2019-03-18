#!/usr/bin/env python3
# Dakr=xv
import config
import json
from datetime import date, datetime
import requests


def calculate_date(password_date):
    """Return the number of days until the password will expire.

    Expiration time set to 6 months (182 days)

    Calculate current date - password set date then subtract from 182
    """
    password_date_split = password_date.split('T')[0].split('-')
    password_date_ints = map(int, password_date_split)
    d_then = date(*password_date_ints)
    d_now = date(datetime.now().year, datetime.now().month, datetime.now().day)
    days_set = d_now - d_then

    return (182 - days_set.days)


def main():
    """Return all users who's password will expire in 7 days.

    Use Onelogin API to gather user email and password set date info.

    Calculate password days remaining per user.
    """
    # API Credentials from Onelogin (READ ONLY)
    # Save the API Credentials in a config file to import
    client_id = config.client_id
    client_secret = config.client_secret

    # Request Token to make Onelogin API calls
    r = requests.post('https://api.us.onelogin.com/auth/oauth2/v2/token',
                      auth=(client_id, client_secret),
                      json={"grant_type": "client_credentials"}
                      )

    # Token, Header and URL info to pass in my request
    token = r.json()['access_token']
    header = {'Authorization': 'Bearer: {}'.format(token)}
    prime_url = 'https://api.us.onelogin.com/api/1/users'
    url = 'https://api.us.onelogin.com/api/1/users'

    # Initialize sets
    user_emails = set()
    no_logins = set()
    removal_list = ['user@company.com']

    # Request all Onelogin users
    # Add all users to user_emails set
    # Add all users who haven't logged in yet to no_logins set
    r = requests.get(url, headers=header)
    while True:
        for user in r.json()['data']:
            user_email = (user['email'])
            user_emails.add(user_email)
            if (user['last_login']) is None:
                no_logins.add(user_email)
        if 'next' in r.links:
            url = r.links['next']['url']
            r = requests.get(url, headers=header)
        else:
            break

    # Remove all users who haven't logged in yet from user_emails
    user_emails = user_emails.difference(no_logins)

    # Remove these users manually
    user_emails = user_emails.difference(removal_list)

    # Loop through email array to get password set date for each user
    # Calculate days until password expiration
    # Notify if password will expire within 7 days
    for user in user_emails:
        r = requests.get(prime_url, headers=header,
                         params={'email': str(user)})
        password_date = r.json()['data'][0]['password_changed_at']
        days_left = calculate_date(password_date)
        if (days_left <= 7):
            print '{} days till expiration for {}'.format(days_left, user)


if __name__ == "__main__":
    main()
