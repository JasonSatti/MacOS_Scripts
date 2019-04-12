#!/usr/bin/env python3
# Jason Satti
import argparse
import sys

import requests

import config


class SlackApi(object):
    """Connect to a Slack workspace and deprovision a user."""

    def __init__(self, token):
        self.url = 'https://api.slack.com/scim/v1/Users'
        self.token = token
        self.payload = ''
        self.headers = {
            'Accept': 'application/json',
            'Authorization': F'Bearer {token}',
            'cache-control': 'no-cache',
        }

    def total_slack_users(self):
        """Get total number of user accounts in the Slack workspace.

        :return: (Int)
        """
        r = requests.get(self.url, data=self.payload, headers=self.headers)
        total_users = r.json()['totalResults']

        return total_users

    def find_user_by_email(self, user_email, active_only=True):
        """Find the Slack user ID associated with an email.

        :param user_email: email address of the target user
        :param active_only: only find active slack users
        :return: (String) User ID or None if email not found
        :exception: AssertionError - If email is associated with multiple IDs
        """
        total_users = self.total_slack_users()
        url = F'{self.url}?count={total_users}'
        r = requests.get(url, data=self.payload, headers=self.headers)
        user_list = r.json()['Resources']
        matches = set()  # ID of every user who shares email address
        for user in user_list:
            for email in user['emails']:
                if user_email == email['value']:
                    if not active_only or user['active']:
                        matches.add(user['id'])
        msg = F'Multiple Slack accounts share this email:{user_email}! '
        msg += 'This is outside the scope of this script. '
        msg += 'Please verify Slack account manually.'
        if len(matches) == 0:
            return None

        assert len(matches) == 1, msg
        return matches.pop()

    def delete_user(self, user_email, dryrun=True):
        """Deprovision user from Slack workspace associated with given email.

        :param user_email: Email of user to be deleted
        :param dryrun: Find user but do not delete user
        :return: (Bool) True if user was actually deleted
        """
        user_id = self.find_user_by_email(user_email)
        url = F'{self.url}/{user_id}'
        if user_id is None:
            msg = F'{user_email} is not an active user.'
            print(msg, file=sys.stderr)
            return False
        if dryrun:
            msg = F'Would have deleted user {user_email}: {url}'
            print(msg)
            return False

        r = requests.delete(url, data=self.payload, headers=self.headers)
        r.raise_for_status()
        msg = F'{user_email} deprovisioned successfully'
        print(msg)
        return True


def main():
    """Get user email address from CLI input and deprovision from Slack

    :email: Required CLI Input
    :token: Optional CLI Input default is imported from config file
    """
    parser = argparse.ArgumentParser(description='Deprovision Slack account.')
    parser.add_argument('-e', '--email', required=True, type=str,
                        help='Email address of user to be deprovisioned.')
    parser.add_argument('-t', '--token', required=False, default=config.token,
                        type=str, help='Slack API Token.')
    args = parser.parse_args()

    slack = SlackApi(args.token)
    slack.delete_user(args.email)


if __name__ == '__main__':
    main()
