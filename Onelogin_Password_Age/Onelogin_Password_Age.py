#!/usr/bin/env python3
# Jason Satti
from datetime import date, datetime
import requests

import config


class OneloginApi(object):
    """Connect to a Onelogin instance and retrieve user information."""

    def __init__(self, oauth_url, url, client_id, client_secret,
                 password_age_limit=182, removal_set=[]):
        self.oauth_url = oauth_url
        self.client_id = client_id
        self.client_secret = client_secret
        self.token = self.return_token()
        self.url = url
        self.removal_set = removal_set
        self.password_age_limit = password_age_limit

    def return_token(self):
        """Return API access token from Onelogin.

        :return: (dict)
        """
        r = requests.post(self.oauth_url,
                          auth=(self.client_id, self.client_secret),
                          json={"grant_type": "client_credentials"}
                          )

        return r.json()['access_token']

    def get_user_emails(self):
        """Return all active user emails from Onelogin unless they're in the
        removal set.

        :return: (list)
        """
        user_emails = set()
        headers = {'Authorization': F'Bearer: {self.token}'}
        next_url = self.url
        while next_url:
            r = requests.get(next_url, headers=headers)
            for user in r.json()['data']:
                # Ignore inactive users
                if not (user['last_login']) is None and (user['status']) is 1:
                    user_emails.add(user['email'])
            if 'next' in r.links:
                next_url = r.links['next']['url']
            else:
                next_url = None

        return user_emails.difference(self.removal_set)

    def get_password_date(self, email):
        """Return date of last password change for user.

        :param email: This is a an element returned by get_user_emails()
        :return: (String)
        """
        headers = {'Authorization': F'Bearer: {self.token}'}
        r = requests.get(self.url, headers=headers,
                         params={'email': str(email)})

        return r.json()['data'][0]['password_changed_at']

    def calculate_date(self, user_email, buffer_days=1):
        """Return the number of days until the password will expire.

        buffer_days - Warn password will expire this many days before actual
        password expiration date

        :param user_email: This is a an element returned by get_user_emails()
        :param buffer_days: This is an optional integer value with a default
        of 1 which can be set when calling calculate_date()
        :return: (Integer)
        """
        password_date = self.get_password_date(user_email)
        password_age_limit = self.password_age_limit - buffer_days
        password_date_split = password_date.split('T')[0].split('-')
        password_date_ints = map(int, password_date_split)
        d_then = date(*password_date_ints)
        d_now = date(datetime.now().year, datetime.now().month,
                     datetime.now().day)
        days_set = d_now - d_then

        return password_age_limit - days_set.days


def main():
    """Return all users who's password will expire in 7 days."""
    company_onelogin = OneloginApi(config.oauth_url,
                                   config.url, config.client_id,
                                   config.client_secret,
                                   removal_set=config.removal_set)
    for user in company_onelogin.get_user_emails():
        days_left = company_onelogin.calculate_date(user)
        if days_left <= 7:
            print(F'{days_left} days till expiration for {user}')


if __name__ == "__main__":
    main()
