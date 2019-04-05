#!/usr/bin/env python
# Jason Satti
import json
import os
import requests

import config


class JamfSync(object):
    """Connect to Jamf Instance and sync all scripts to a local folder."""

    def __init__(self, script_api_url, script_dir, api_user, api_pw):
        self.script_api_url = script_api_url
        self.script_dir = script_dir
        self.api_user = api_user
        self.api_pw = api_pw
        self.script_catalog = None

    def get_script_catalog(self, url):
        """Get entire script catalog from JAMF including script name and ID.

        :param url: This is a url from with the resource and script_api url
        :return: (dict)
        """
        headers = {'Accept': 'application/json'}
        req = requests.get(
            url,
            auth=(self.api_user, self.api_pw),
            headers=headers)

        self.script_catalog = json.loads(req.text)['scripts']

    def get_script_info(self, script_url):
        """Get Name and Content information about a script from Jamf.

        :param script_url: This is a url formed with the individual script ID
        :return:  (string, string)
        """
        headers = {'Accept': 'application/json'}
        req = requests.get(
            script_url,
            auth=(self.api_user, self.api_pw),
            headers=headers)
        script_info = json.loads(req.text)
        script_name = script_info['script']['name']
        script_content = script_info['script']['script_contents']

        return script_name, script_content

    def write_file(self, script_name, script_content):
        """Create script file in the script_dir folder and fill the content

        :param script_name: This is a string returned by script_content()
        :param script_content: This is a string returned by script_content()
        """
        if not os.path.exists(config.script_dir):
            os.makedirs(config.script_dir)
        first_line = script_content.split('\n', 1)[0]
        if 'bash' in first_line:
            script_name = script_name + '.sh'
        elif 'python' in first_line:
            script_name = script_name + '.py'
        print('Syncing ' + script_name)
        f = open(self.script_dir + script_name, 'w+')
        f.write(script_content)


def main():
    """Write all scripts from Jamf to script_dir folder."""
    jss_sync = JamfSync(config.script_api_url, config.script_dir,
                        config.api_user, config.api_pw)

    jss_sync.get_script_catalog(config.resource_url + 'scripts')
    for script in jss_sync.script_catalog:
        id = str(script['id'])
        script_url = config.url + id
        script_name, script_content = jss_sync.get_script_info(script_url)
        jss_sync.write_file(script_name, script_content)


if __name__ == '__main__':
    main()
