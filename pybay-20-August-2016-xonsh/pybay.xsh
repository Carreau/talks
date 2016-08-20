$DEFAULT_PROMPT = $PROMPT
$PROMPT = $DEFAULT_PROMPT.replace('{user}@{hostname}','')
cd ~

#:section hello
print('Hello PyBay!')
# Is this big enough ? Can you read in the back ?
#:section python
# let's use a prompt that reflect the python prompt.
$PROMPT = $PREFIX+'>>> '

#:section
clear

for i in range(10):
    print(i , 'squared is', i**2)

#:section

import asyncio
loop = asyncio.get_event_loop()

async def timer(string, interval):
    for i in range(5):
        print(string)
        await asyncio.sleep(interval)

tasks = [loop.create_task(timer(a,b)) for (a,b) in
        (('Hello \U0001F40D',1),('PyBay \U0001f41A',0.7))]

loop.run_until_complete(asyncio.wait(tasks))

#:section shell

# Xonsh is also, a shell.

$PROMPT = $DEFAULT_PROMPT.replace('{user}@{hostname}','')

cd ~/dev/xonsh
#:sleep 1
ls -al *.py
#:sleep 1
pwd

echo "Welcome to PyBay it is now" $(date)

#:pause

which
which which
which --help 

#:section mixed

#:section

# You can set environment variable like python ones !
$HOME
$USER

# Dynamically generate the name with ${}

x = 'US'
${x+'er'.upper()}

echo "The home of " $USER "is" $HOME
print("The home of ", $USER, "is %s" % $HOME)

#:section

# Unlike most shells, environments variable are typed !
type($HOME)
type($AUTO_SUGGEST)
type($PATH)
#:sleep 1
$PATH
$PATH[3:7]

#:sleep 1
sorted($PATH[3:7])

# ${...} or __xonsh_env__ is a dict,
# you can manipulate as any other python variable.

#:pause
${...}
#:pause

# ouch a bit overwhelming... 

[ k for k in ${...} if k.startswith('XONSH')]

#:pause

clear

#:section aliases

# unlike other shell, aliases are stored 
# in the aliases dictionary called `aliases`
aliases
#:pause

# Assign a tuple
aliases['uuddlrlrba']  = ('echo','all your base are belong')
#:sleep 1
uuddlrlrba to us

# or a function, here a lambda
aliases['measure'] = lambda args,stdin=None : "Not sure how to measure {}. Here is a banana, for scale.\n".format(' '.join(args))
measure a duck

def _it_floats(args, stdin):
    if "wood" in args[0].lower():
        return "Burrrrrrn !!!\n"
    else:
        return "Nop, It's probably a King\n"


aliases['it-floats'] = _it_floats
it-floats 'wooden which'
it-floats 'Arthur'

# Foreign shells.
#:section Foreign

cd ~/dev/warehouse

# This is the New PIPY website. 
# it makes heavy use of docker
# we need to start docker machine

docker-machine start
#:section

docker-machine env

#:pause

env | grep DOCKER

result = $(docker-machine env)

print(result)

# and let's us source-bash that spawn a subshell, source a
# file, get the envs, and apply the patch to current
# __xonsh_env__

source-bash @(result)
#:section
env | grep DOCKER

#:section
[${...}.pop(key) for key in ${...} if 'DOCKER' in key]

env | grep DOCKER
#:section
from xonsh.proc import foreground
#:pause
aliases['undock'] = foreground(lambda args,stdin=None:[${...}.pop(key) for key in ${...} if 'DOCKER' in key])

#:section

# shorter way; 

source-bash $(docker-machine env)

env | grep DOCKER
undock
env | grep DOCKER

# Hooray !

#:section miscs

# can I use external libraries ? like requests
import requests
response = requests.get('https://raw.githubusercontent.com/python/peps/master/pep-0020.txt')
#:pause
response.status_code
echo @(response.content.decode()) | grep better

#:section
import json
curl https://api.github.com/orgs/xonsh/repos
#:pause
json.loads($(curl https://api.github.com/orgs/xonsh/repos))
#:pause
[repo['name'] for repo in json.loads($(curl https://api.github.com/orgs/xonsh/repos))]

#:section peps
cd ~/dev/peps
git stash
#:pause
ls -1 `pep-(\d{2})(\1).txt`
#pause
files = $(ls `pep-\d{4}.txt`).splitlines()
#:pause
for name in files:
    with open(name) as f:
        if 'Content-Type: text/x-rst' in f.read():
             git mv @(name) @(name.replace('txt','rst'))

#:section xonsh 

cd ~/dev/xonsh
#:pause
grep 'def ' **.py
#:pause
grep 'def ' **.py | cut -f 2 -d: 

#:section
aliases['strip'] = lambda args,stdin: '\n'.join([s.strip() for s in stdin.splitlines()])


#:pause
grep 'def ' **.py | cut -f 2 -d: | strip
#:pause
grep 'def ' **.py | cut -f 2 -d: | strip | @(lambda a,s: '\n'.join([f.split('(')[0] if '(' in f else f for f in s.splitlines()]))
#:pause
nums = $(grep 'def ' **.py | cut -f 2 -d: | strip | @(lambda a,s: '\n'.join([f.split('(')[0] if '(' in f else f for f in s.splitlines()])) | sort  | uniq -c | sort | cut -c1-5)
#:pause
print(nums.replace('\n', ' '))
#:pause
res = [int(x) for x in nums.splitlines()]

#:section xontrib

import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import numpy as np

x = np.arange(0, 10, 0.1)
y = np.sin(x)
z = np.sin(x)

fig, ax = plt.subplots()
ax.plot(x,y)
ax.plot(x,z)
fig.savefig('foo.png', transparent=True)
aliases['imcat'] = lambda args,stdin : print('\033]1337;File=inline=1;height=80%%:%s\a\n' % stdin)
cat foo.png | base64 | imcat
#:pause
mpl

#:section

cat ~/Desktop/xonsh_2016.jpg | base64 | imcat

# The end
$PROMPT = $DEFAULT_PROMPT
