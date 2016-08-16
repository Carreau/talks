print('Hello PyPay!')
# Is this big enough ? Can you read in the back ?

#:section
# let simplify our prompt
$DEFAULT_PROMPT = $PROMPT
$PROMPT = $PREFIX+'>>> '

#:section
clear

for i in range(10):
    print(i , 'squared is', i**2)

#:section

import asyncio
loop = asyncio.get_event_loop()

def timer(string, interval):
    for i in range(10):
        print(string)
        yield from asyncio.sleep(interval)

tasks = [loop.create_task(timer(a,b)) for (a,b) in (('Hello',1),('PyBay',0.7))]
loop.run_until_complete(asyncio.wait(tasks))

# Fact 1
# Xonsh is superset of Python 3.

#:section

# Xonsh is also, a shell.

$PROMPT = $DEFAULT_PROMPT.replace('{user}@{hostname}','')

#:section
$HOME
x = 'US'
${x+'ER'}
#:section
$PATH
sorted($PATH[3:7])

# ${...} or __xonsh_env__ and is a dict,
# you can manipulate as any other python variable.

${...}

clear
#:section

# Foreign shells.
#:section

cd ~/dev/warehouse

# This is the New PIPY website. 
# it makes heavy use of docker
# we need to start docker machine

docker-machine start
#:section

docker-machine env

# hum... I can't source it as the syntax is different
# let's capture the output and use `source-bash`

env | grep DOCKER

result = $(docker-machine env)

print(result)

# and let's us source-bash that spawn a subshell, source a file, get the envs, 
# and apply the patch to current __xonsh_env__

source-bash @(result)

#:section

env | grep DOCKER

#:section
[${...}.pop(key) for key in ${...} if 'DOCKER' in key]

from xonsh.proc import foreground
aliases['undock'] = foreground(lambda args,stdin=None:[${...}.pop(key) for key in ${...} if 'DOCKER' in key])

env | grep DOCKER

# shorter way; 

source-bash $(docker-machine env)

env | grep DOCKER
undock
env | grep DOCKER

#:section

# restore the old one...
$PROMPT = $DEFAULT_PROMPT
