## Looks for internal disks that are available for encryption.

## If no disks are available out put will be:
## No internal volumes available for encryption.

## If disks are available, they will be listed as(in this example there are two):
## Volume Name not encrypted; Volume Name not encrypted.

#!/usr/bin/python
import subprocess

process = subprocess.Popen(['df','-l'], stdout=subprocess.PIPE, shell=False)
out,err = process.communicate()
df_out=[]
out = out.splitlines()[1:]
for disk in out:
    disk.split()
    df_out.append(disk.split('  ')) 

disk_names=[]
for disk in df_out:
    disk_names.append(disk[0])

diskinfo = {}
for disk in disk_names:
    disk_details = {}
    process = subprocess.Popen(['diskutil','info',disk], \
            stdout=subprocess.PIPE, shell=False)
    out,err = process.communicate()
    results=dict(item.split(':') for item in out.split('\n') if len(item) > 1)
    for key, value in results.iteritems():
        disk_details[key.lstrip(' ')] = value.lstrip(' ')
    diskinfo[disk] = disk_details

report = '<result>'
for vol, info in diskinfo.iteritems():
    if diskinfo[vol]['Device Location'] == 'Internal':
        if 'Encrypted' in diskinfo[vol]:
            if diskinfo[vol]['Encrypted'] == 'No':
                report += diskinfo[vol]['Volume Name']+' Not Encrypted; '
    else:
        report += ''
if report == '<result>':
    report += 'No internal volumes available for encryption</result>'
else:
    report += '</result>'
print report