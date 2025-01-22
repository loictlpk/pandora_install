#!/bin/bash

# RUN THIS SCRIPT AS SUDO

apt install -y authbind
touch /etc/authbind/byport/80

# as root
chown $USER /etc/authbind/byport/80
chmod 500 /etc/authbind/byport/80



#######IMPORTANT#########
# Change port and website public url in pandora/config/generic.json to your favourite like this
#    "website_listen_port": 80,
#    "public_url": "http://0.0.0.0:80",

#Check pandora/bin/start_website and change a part of python like this
#        return Popen(['authbind', 'gunicorn', '-w', '10',
#                      '--graceful-timeout', '2', '--timeout', '300',
#                      '-b', f'{ip}:{port}',
#                      '--log-level', 'info',
#                      '--max-requests', '2000',
#                      '--max-requests-jitter', '100',
#                      '--name', 'website_pandora',
#                      'web:app'],
#                     cwd=website_dir)

