#!/usr/bin/env python3
# Daky-xv
import config
import json
from datetime import date, datetime
import requests


def calculate_date(password_date):
    """Return the number of days until the password will expire.

    Expiration time set to 6 months (182 days).

    Calculate current date - password set date then subtract from 182.
    """
    password_date_split = password_date.split('T')[0].split('-')
    password_date_ints = map(int, password_date_split)
    d_then = date(*password_date_ints)
    d_now = date(datetime.now().year, datetime.now().month, datetime.now().day)
    days_set = d_now - d_then

    return (182 - days_set.days)


def return_token(oauth_url, client_id, client_secret):
    """Return API access token from Onelogin."""
    r = requests.post(oauth_url,
                      auth=(client_id, client_secret),
                      json={"grant_type": "client_credentials"}
                      )

    return r.json()['access_token']


def get_user_emails(url, headers, removal_set):
    """Return all user emails from Onelogin who have logged in before.

    Removes all users added to the removal_set above before returning emails.

    Follows all pagination links for complete list.
    """
    user_emails = set()
    r = requests.get(url, headers=headers)
    while True:
        for user in r.json()['data']:
            if not (user['last_login']) is None:
                user_emails.add(user['email'])
        if 'next' in r.links:
            url = r.links['next']['url']
            r = requests.get(url, headers=headers)
        else:
            break

    return user_emails.difference(removal_set)


def get_password_date(prime_url, headers, email):
    """Return date of last password change for user."""
    r = requests.get(prime_url, headers=headers,
                     params={'email': str(email)})

    return r.json()['data'][0]['password_changed_at']


def main():
    """Return all users who's password will expire in 7 days.

    Use Onelogin API to gather user email and password set date info.

    Calculate password days remaining per user.
    """
    # Save the Onelogin Oath URL, URL and API creds in a config file to import
    token = return_token(
        config.oauth_url, config.client_id, config.client_secret)
    headers = {'Authorization': 'Bearer: {}'.format(token)}
    prime_url = config.url
    url = config.url
    removal_set = ['user@company.com']
    # Loop through email array to get password set date for each user
    # Calculate days until password expiration
    # Notify if password will expire within 7 days
    for user in get_user_emails(url, headers, removal_set):
        password_date = get_password_date(prime_url, headers, user)
        days_left = calculate_date(password_date)
        if (days_left <= 7):
            print '{} days till expiration for {}'.format(days_left, user)


if __name__ == "__main__":
    main()
