# Building Bridges, not walls

## Ending Python2 compatibility in a user friendly manner

This is a written version of the talks that M. Bussonnier and M. Pacer gave at
PyCon 2016 [video] , this served as a guide to prepare the talk

See also blob posts on blog.jupyter.org.  

Hello everyone, thanks for being here today, and thanks to the organize for this
beautiful PyCon  and of course Portland to host this conference today !

Just quickly to Present Myself, I'm Matthias I've been working for the past 5
year or so mostly on the IPython and Jupyter project. I'm currently as BIDS
(Berkeley Institute for Data Science). 

One of the nice benefits of working there is that I have the liberty to explore
many ways to make science better by developing IPython. I have a great liberty
to work on related project as long as it related to the development of IPython
and Jupyter. 

Why this talk ?

Well most people like to avoid conflictual subjects. We decided to balance
things out by discussing:

    - Python 2 vs Python 3
    - Packaging

Not covered:
    - Tab vs Space
    - Vim vs Emacs
    - Conda vs Pip

For a couple of years have been really enjoying Python 3 and most of my side
project are Python 3 only. This is (or was) not something we could afford for
the Main IPython codebase mostly because our users are still often on Python 2,
and if we are doing open-source it's mostly for our users. In the other hand we
came to this codebase because it is fun to work on it – and having to write code
that is both compatible Python 2 and 3 is not always fun. It also prevent you to
use lots of the newer features of Python 3 that are enjoyable to play with.

About a year ago we decided that with the End Of Life looming on the horizon,
the now wide adoption of Python 3 on the scientific ecosystem if was probably
time to think about a Python 3 only codebase. We looked online for projects
having do the migration from Python 2 to Python 3 and realized that at the time
no large project had done something similar, and decided to bite the bullet.

Many project are contemplating migrating to Python 3 only but are afraid to test
the transition, so we decided to be one of the first wildebeast to cross the
crocodile infested waters. 

To this end we create the Python 3 statement. The Python 3 statement is **not**
to tell you which version of Python you should use – you and only you can decide
that – the Python 3 statement is here to tell you which already existing
libraries are planning to become Python 3 only and provide both libraries author
and user clear informations about timeline and checklist to insure the
transition is as smooth as possible. As the Python 2.7 official EOL is 2020 we
focus (for now) on [scientific] libraries that have pledge to stop Python 2
support by that same date.


Here is our journey, we'll start back in summer 2016 Packaging landscape have
changed a bit since then, but thanks to many involved actors (Huge kudos to the
folks behind PyPA) things are way better now so think of this section as things
that might have been and that you don't have to go through. 

## So you want to stop Python 2 support. 

Let's start by stating the problem: We've decided to make IPython Python 3 only,
– we're not going to care for now for people running from git master – This
means that the next version of IPython will be invalid Python 2 ; likely invalid
syntax early during startup process. We want the right balance between amount of
work and simplicity for users.

Sidenote – We believe that one of the key tension in the Python 3 vs Python 2
holly war is that you can _install_ an incompatible version. There not much more
frustrating than installing a software (potentially pulling out dependencies)
and get greeted by a Stack Trace at startup. The best experience we can have for
our users is to `pip install ipython [--upgrade]` without having to bother to
pin dependencies, and get the right version. 

From a developer perspective we want to have the least amount of changes to make
and the minimal amount of manual steps to do for each release. We also want our
documentation changes to be minimal and the chances of the users being in a
buggy situation as low as possible.

Let's examine the various solution at our disposal.


### Do Nothing

Do nothing. Just release your new package that uses some Python 3 only
features. It's super easy. You just need to release.

This approach is not without drawbacks: some users and dependees'
maintainers will chase you to the end of the world with a chainsaw because you
broke their systems. You likely don't want that.

We know of a limited number of packages that have done that, like Nikola.

This solution seem like it is not the best. If the number of maintainers/users
ratio is high then it might be a solution. You may also want to consider the
fact that your users are all advanced python gods and can figure things out. 

Still it requires time which still tend to annoy people. It also comfort user
that Python 3 people are not nice and don't care about the Python 2 crowd, but
we do right ? 

### Change your package name

Instead of releasing a new version, you can release a "new" package with a new
name, that just happens to contain the same functionality as your
once-python-2-compatible package.

In this case, it's obvious for users which packages are to be used with which
Python systems.

The downside to this is that, all users need to be made aware of the new name,
and explicitly migrate to it everywhere. In this action, you invalidate many
users' habits, their code, and much of the documentation that already exists
online. Also you won't be able to copy past from stackoverflow.

There is also likely a conflict between the package name and the import name. 
We've all `pip install jinja` instead of jinja2 right ? 

### Wheel only

 - Releasing a package only as a wheel can allow you to avoid pip `<9.0`'s
   Python 3 only problem with `tar.gz`s.

   For pure python packages, this is relatively easy to do.

There are downsides. Many systems and downstream distributors do rely on (or
prefer) source-distributions.

It is not possible to release wheels for all packages, particularly those that
are not pure python packages – despite `manylinuxN`. Wheels make a strict,
coarse Python 2 vs Python 3 dichotomy; this stops you from expressing
dependencies on minor python revisions.

### Metapackage

It is possible to release a meta-package that has _virtually_ no code and rely
on conditional dependencies that install its actual core code on users' system.
For example, Frob-6.0 could be a meta-package which depends on Frob-real-py2 on
Python <3.0, and Frob-real-py3 on Python >= 3.4. While this approach is
_doable_ this can make for confusing imports/Error messages.

Using a metapackage has many advantages, for example, you don't change the
package name, though it requires a second package on PyPI, potentially leading
name confusion. For example : Frob-6.0 (metapackage) with FrobForPy3-60
(dependency). 

It is annoying for developers who then have to maintain 2 separate but
dependent packages. From a user's perspective, errors might come from
FrobFromPy3 but appear to come from Frob-6.0. Upgrading your package becomes
more complicated, as you need the user to explicitly upgrade dependencies, or
tie releases by pinning dependencies, or `pip install -U frob` would only
upgrade the meta-package.

Example: None to our knowledge, but we considered it for IPython.


### Release multiple Sdist

One little known feature of pip is that if your sdist name ends in `py-X.y`,
then this sdist will only be installed on Python X.y. 

This allows targeting only a subset of Python minor versions by publishing
multiple sdist. 

On the other hand, you _have_ to publish N identical source-dist for you package. And,
this includes potential future version of Python which requires making tough,
unknowable decisions. Is the version of Python post 3.9 be 3.10 or 4 ?

Also ... since then ... , PyPI does not allow you to upload multiple sdist. So this solution won't
work if you want to be in the cheeseshop anyway! Still you can find packages
using this.


## The new way : Python-Requires

When you use setuptools > 24.2, you can set the `python_requires` metadata in
your `setup.py`. Recent changes to PyPI/warehouse return a `python_requires`
metadata in response to API calls. Pip 9.0+ knows how to make and interpret
those API calls. This means that if you use setuptools 24.2+,  set
`python_requires` metadata,  then pip 9.0+ will only install versions of your
software compatible with the currently running version of
Python, even if your _newest_ release is Python 3 only.

    setup(..., 
        python_requires='>=3.4'
    )

and 

    pip install . 

This avoids most of the downsides of other solutions: No need to change package
names, create a new package or release wheels only. Most importantly, easier to
support your Python 2 users, and no need to jump through hoops to do so. It can
be as simple as a single line change to your source.

There are still a few downsides. For example, installing the last compatible
version won't work for your users with pip < 9.0. Installation may fail as well
if setuptools < 24.2 is used, as newer versions of setuptools understand more
arguments for `setup()`.

This is why it is all the more important to encourage Python 2 users (in
particular) to upgrade their pip version to 9.0+.

Do **not** invoke `setup.py <whatever>` directly as it will not respect metadata

### In details

In particular we will details the modes of failures

#### Use python_requires metadata

See `python_requires` metadata. We discoverd (See pep 345, 2005), you can use a
version specifier that targets a specific python version.

If you do not pip (or anything else) will happily install a non-compatible
version of your package.

Whether it's at install time or run time it leaves user with their system in a
broken state. 


#### Requires setuptools > 24.3

Only setuptools 24.2 and above understand `python_requires` keyword argument. 

Obviously when you build and upload your package as a **developper** you need a
recent enough version. If you do publish wheels, setuptools will be run on a
user machine at install time. If they have an old enough setuptools, it will
just fail at install with `got an unexpected keyword argument
'python_requires'`


#### Recommend pip > 9.0

Pip < 9 does not understand the `reauires_python` metadata and will download
and install incompatible version of the package. **more later**


### Failures modes

What was above was the minimum necessary for transition to be smooth. In
__most__ case, user simply can't upgrade and may not even realize there is a
new version. There are still possible failures:

#### keep setup.py python 2 compatible

(And raise a useful error message)

If ever `setup.py` is ran on Python 2 you want to raise a clear error message,
and __not__ a syntax error. Of course say that your package is Python 3 only,
but the most likely cause is user have an old version of pip. 

Warn and ask user to update **pip** and retry (you may also want to check pip
version).

#### Fails **before** setup()

(And raise a useful error message)

If ever `setup.py` is ran on Python 2 you want to raise a clear error message,
and __not__ a syntax error. Of course say that your package is Python 3 only,
but the most likely cause is user have an old version of pip. 

Warn and ask user to update pip and retry (you may also want to check pip
version).


#### keep `___init__.py` python 2 syntax compatible.

Same as above, some users will manage to install your package, for example just
"Pull" from master after a dev install. 

You want to fail early with an appropriate error message. 

#### Do not use `setup.py <...>` directly

Update your documentation to use `pip install [-e] .` when possible (and your scripts). 
Invoking `setup.py` directly will not respect the `reauires_python`


#### Use multiline error message.

Just a reminder that you can use multiline error messages.  

   http://www.python3statement.org/practicalities/

Should have all the necessary informations, and examples of how to do each of
these in a good way.

#### TL:DR; 

Do you best to leave the user install unchanged if something goes wrong and
fail explicitly, if possible early with a good error message. Try to have an
error message that pinpoint the root cause of the error, not just the lack of
compatibility with Python.

TIP: Provide a URL to an issue, or a documentation page, where you can update
your users with more informations if necessary.

### Communication

Don't forget about communication, warn your users, and other developers about
your plan early, and communicate to your users that attempting to upgrade will
(hopefully) not break. 

So you **can** make a release of a library that will 


# Under the hood

## The old pep

Pep 345 [specifies](https://www.python.org/dev/peps/pep-0345/#requires-python)

    Requires-Python
    ===============

    This field specifies the Python version(s) that the distribution is
    guaranteed to be compatible with.

    Version numbers must be in the format specified in Version Specifiers .

    Examples:

    Requires-Python: 2.5
    Requires-Python: >2.1
    Requires-Python: >=2.3.4
    Requires-Python: >=2.5,<2.7


Ok ! That's great can we use it ? And how to use it ?

## PyPI

Pretty easy, we want pip to have access to that **before** downloading the
sdist, because we don't want to download all the sourcedist just to discover
they are not compatible right ? 

Pip does that via `/simple/` repository url:


    view-source:https://pypi.python.org/simple/pip/

List files and now have `data-python-requires` which list a version
specifications for the release corresponding to the corresponding release

This was done by amending pep 503. If you are running (or maintain) a PyPI
proxy please make sure it does understand the new `data-python-require`.

## Pip

Now that PyPI exposes the information indication with which versions of Python
the package is available pip should be made aware of it. 

https://github.com/pypa/pip/pull/3877/files

In the same place that pip process the filenames of files (to get version of
`-py2` , `-py3` wheel prefix to filter the available packages sources.

That's the main reason you want final users to upgrade to pip 9+ if you are not
on pip 9+, pip will consider incompatible packages, download them and ... fail
at some point. 

Please share that around you, it is the main cause of incorrect download of
Python 3 only version of IPython:

First Week :
  - IPython 6.0 - Pip 9 - Python 3 : 45.566 
  - IPython 6.0 - Pip 8 - Python 2 : 88.642 -- Not Ok

Second Week :
  - IPtyhon 6.0 - Pip 9 - Python 3 : 40.996 
  - IPython 6.0 - Pip 8 - Python 2 :  9.973 -- Not Ok, but better:

Run the query yourself on BigQuerry

  SELECT COUNT(details.python) as download_count, REGEXP_EXTRACT(details.python, r'^(\d+)') as details_python, 
   file.version,
   details.installer.version,
   details.installer.name
  FROM (TABLE_DATE_RANGE([the-psf:pypi.downloads], 
                  TIMESTAMP('2017-04-27'), 
                  TIMESTAMP('2017-05-04'))) 
  WHERE file.project IN ('ipython' )
  AND file.version == '6.0.0'
  GROUP BY details_python, file.version, details.installer.version, details.installer.name
  ORDER BY download_count DESC

Woo ! So far either users of Python to have given up on install IPython 6.0 on
Python 2, or the error message and the  `requires_python` works (almost)
seamlessly. 

Number of Complaints : 2
  - 1 during RC phase `python setup.py install` did pull the --pre on Google
    Fire CI. 
  - 1 request to clarify a message.
  - I don't count twitter / reddit/ HN but haters were few.


## Belly of the beast PyPI+Warehouse patches

You might all know PyPI, that's usually where most of you may download your
packages from. Pip does interrogate PyPI to install packages. PyPI is old. PyPI
testing is sparse (understand non existant), and documentation is... ~~non
existant~~ not alway accurate, so not that easy to run locally.

The PyPA have stated developing Warehouse (the new PyPI), which is well
documented, 100% test coverage and provided with a one liner to run it locally
using Docker. 

In production PyPI and warehouse are connected to the same Postgres database.
So any update need to be coordinated. 

Seem pretty easy, when you requires `/simple/<package>` webpage the sql query
should simply:

    SELECT * from release_files where package_name=package

And build a list of href. Seem like a solved Problem right ? Except reading the
actual pep teh requires-python are per **release** not per file (ie you can't
have a wheel which is python 3.3+ and a sdist 3.2+)

Release is a different table, so we could "simply" use a JOIN. Except with the
number of available packages the join is too slow. We can't really refactor
the all database format because PyPI is not really tested.

We ended up using a postgress trigger with UPSERT (that simplify some logic a
lot) that update the `release_files` table as soon as it (or `release`) get
updated.  

We've improved the documentation of warehouse, and PyPI, so now you should be
able to contribute back more easily. Despite not being well tested there is a
number of low hanging fruit ! Either cleaning up the codebase, or bringing
features from PyPI to Warehouse.


# Conclusion

- You can now drop an older Python version without horrible user experience 
- use `requires_python`
- encourage pip 9
- Coomunicate ! (feedback to python3 statemtnt)




















