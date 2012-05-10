#!/usr/bin/env python
"""
Turn a /etc/postfix/aliases file into Google App for Domain account, groups and nicknames
"""

import sys
import getpass

import gdata.apps.groups.service
from gdata.apps.service import AppsForYourDomainException


def parsefile(filename):
    """Parse an aliases file."""

    aliases = {}

    f = open(filename, "r")

    for line in f.readlines():
        line = line.replace("\n", '')
        if "#" in line : # Skip comments
            continue 
        elif 'rt3' in line: # skip request tracker
            continue
        elif ':' not in line: # skip empty lines 
            continue
        elem = line.split(':')
        alias = elem[0].replace(' ', '')
        names = elem[1].replace(' ', '')

        # Special case: Benoit user name changed from 'bbeausej' to 'b'
        names = names.replace('bbeausej', 'b')

        if not alias in aliases:
            aliases[alias] = {}
        if ',' in names:
            # this is a list
            aliases[alias]['is_a_group'] = True
            aliases[alias]['members'] = names.split(',')
        else:
            if 'root' in names:
                # root list special case
                aliases[alias]['is_a_group'] = True
                aliases[alias]['is_sys'] = True 
                aliases[alias]['members'] = ['sys@turbulent.ca']
            else:
                aliases[alias]['is_a_group'] = False
                aliases[alias]['members'] = [names]

    return aliases


def usethisuser(existing, user):
    if user in existing or '@' in user:
        return True
    return False

if __name__ == '__main__':

    # FIXME: confirm we have a file


    # parse aliases
    aliases = parsefile(sys.argv[1])

    # Connect to Google
    # Log into Gapp
    #service = gdata.apps.groups.service.GroupsService(email=email, domain=domain, password=password)
    passw = getpass.getpass('Google password for bcaron@turbulent.ca? ')
    print "Login into Apps Service..."
    service = gdata.apps.service.AppsService(email='bcaron@turbulent.ca', domain='turbulent.ca', password=passw)
    service.ProgrammaticLogin()
    print "Login into Group Service..."
    groupservice = gdata.apps.groups.service.GroupsService(email='bcaron@turbulent.ca', domain='turbulent.ca', password=passw)
    groupservice.ProgrammaticLogin()


    # Retreive full list of known users
    all = service.RetrieveAllUsers()
    existing = []
    for x in all.entry:
        existing.append(x.login.user_name)
   
    print "All users existing in Google: %s" % existing

    for alias in aliases.keys():
        try:
            if aliases[alias]['is_a_group']:
                print "creating group %s with members %s" % (alias, aliases[alias]['members'])
                # First, create group if it does not exist
                try:
                    print "testing if group %s exist" % alias
                    print groupservice.RetrieveGroup(alias)
                except AppsForYourDomainException:
                    print "creating group %s" % alias
                    groupservice.CreateGroup(alias,alias, 'Liste - import Polysix - %s' % alias, 'Anyone')
                # then add members (check if they exist) usethisuser(existing, member)
                for m in aliases[alias]['members']:
                    if usethisuser(existing, m):
                        print "adding %s to %s" % ( m, alias )
                        groupservice.AddMemberToGroup(m, alias)
            else:
                # this is a nickname... probably
                print "creating nickname %s for user %s " % (alias, aliases[alias]['members'][0])
                # Check if we should use this member usethisuser(existing, member)
                member = aliases[alias]['members'][0]
                if member in existing: 
                    # if yes, create the nickname
                    print "User %s exist, creating...." % member
                    service.CreateNickname( member, alias)
                    print "nickname info: "
                    print service.RetrieveNickname( alias)
                    print "member info: "
                    print service.RetrieveNicknames( member )
                else:
                    print "user %s does not exist, assume it's a mailing list, creating a group" % member 
                    groupservice.CreateGroup(alias,alias, 'Liste - Alias - Polysix - %s' % alias, 'Anyone')
                    groupservice.AddMemberToGroup(member, alias)
        except gdata.apps.service.AppsForYourDomainException, e:
            print "Argh, got a booboo: %s" % e
            continue
            


