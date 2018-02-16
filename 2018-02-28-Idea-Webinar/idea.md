---
title: Jupyter in HPC
separator: \n---- ?\n
verticalSeparator: \n-- ?\n
theme: jupyter
highlightTheme : darcula
revealOptions:
    transition: 'slide'
    slideNumber: 'c/t'

---

# Jupyter in HPC


Matthias Bussonnier

Feb 28th, 2018
----

<!-- .slide: class="jupyter-light" -->

# About Me


Matthias Bussonnier – UC BIDS - @mbussonn/@carreau

- A Physicist
- Core developer of IPython/Jupyter since 2012
- Post doctoral Scholar on Jupyter


-- 

# 3 Parts

This webinar will be in 3 parts: 
 - Overview of what Jupyter is and typical use case
 - Two case studies

-- 

# Outline

- A bit of History (From IPython to Jupyter)
- What is Jupyter
- Why is Jupyter Popular
- What is Jupyter used for



---- 

# From IPython to Jupyter

<!-- to understand the reason behind Jupyter and how it cames to be we need to
roll back to 2001 when a grad student at the time decided to punt on his
dissertation to work on a small project: IPython
--> 

- 2001: Fernando Perez 
  - Can replace bunch of C/C++/Make/Perl script with Python
  - Python REPL is pretty basic for **Interactive** use. 
- Create IPython for Interactive Python.
  - prompt numbers. 
  - gnuplot integration... 

-- 

## Two Programing "modes"

- Software engineer way:
  - Know what to write
  - Run it for long period of time
  - "Human" time small compared to CPU time. 

- "Scientist" way: 
  - Try add-hoc solution in a loop. 
  - Update self-understanding of problem
  - repeat. 
  - Human time greater than CPU 

-- 

## How Software Engineers see Scientists

![](cat-computer.gif)

> I have no idea what I am doing

-- 

## Exploratory programming

IPython was **designed** for exploratory programming, as a **REPL** (Read Eval
Print Loop) and grew popular, especially among scientist who loved it to **explore**. 

> IPython have weaponized the tab key

>   – Fernando Pérez

-- 

# Birth of the notebook 

(Fast forward 2012)

Decision to refactor IPython to make it "network enabled".

- Mature web technologies made it _possible_ and _attractive_
<!-- At that time the web technologies were mature enough that the "Notebook"
frontend was a possibility (websocket, Javascript V8 JIT).  -->

<!-- Let's "Leverage" all of the web stack for display while keeping, the Python
backed for heavy lifting. -->

-- 

## Multi Language

The "Protocol" spoken over the network can be implemented by many languages not
just Python. 

2013 - In about week we got a prototype of **Julia** kernel. 

2014 - we renamed the Python-Agnostic part to Jupyter.

---- 

# What is Jupyter

Mainly known for **The Notebook**

![](notebook.png)

-- 

## The Notebook

(Highly overloaded term)

- Web server (often local), with a web application that load `.ipynb` documents
  (json), that con contain both code, narrative (includes Math rendering) _and_ results.
- Attached to a Kernel (often local) doing heavy computation.
- Results can be: 
   - Static (Image)
   - Interactive (Pure Javascript side scoll/pan/brush)
   - Dynamic (Call back into Python if necessary)
-- 

## JupyterLab

A couple of Days ago/ Soon should be release JupyterLab:

![](lab-header-preview.png)

Extends the notebook interface with text editor, shell, ...etc

(is it and IDE ? If by `I` you mean Interactive, then yes). 


-- 

## Protocols and Formats

Jupyter is also a set of **Protocols and Formats** that reduce the `N-frontends` x `M-backends` problem to a `M-Frontends` + `N-backends`,

- Open, Free and as simple as possible.
  - Json (almost) everywhere
- Thought for Science and Interactive use case. 
  - Results embedded in documents no "Copy past" mistake. 
  - Scale from Education to HPC jobs.

-- 

## Ecosytem

**Frontends**: Notebook, JupyterLab, CLI, _Vim, Emacs, Visual Studio Code, Atom, Nteract,
Juno_...

**Kernels**: Python, _Julia, R, Haskell, Perl, Fortran, Ruby, Javascript, C/C++,  Go, Scala, Elixir... 60+_

---- 

# Why the Popularity

-- 

## Interactivity 

Coding is _not_ the full time Job of most of our users. A simple, single tool,
with friendly interface helps.

Persisting kernel state allows to iterate only on _part_ of an analysis.

Notebook interface give the interactivity of the REPL with the editability and
linearity of a script with intermediate result. Aka "Literate Computing"

-- 


## Separation of state

Computation, and visualisation/narrative/result are in different processes.

 - Robust to crashes
 - Can "Share" and analysis / notebook without having to "rerun" the all code.
   And more trustworthy (No copy-past issues).

Cons:

 - Understanding that document/kernel can have different states can be challenging.


-- 

## Network enabled / web based

User love fancy schmancy colors and things moving. Using D3 and other dynamic
libraries are highly popular

Seamless transition to HPC: `Kernel Menu` > `Restart on Cluster`

Document persist if code crash.

Can be Zero-Installation (See JupyterHub).

-- 

## JupyterHub 

![](hublogo.png)

-- 

![](jhub-parts.png)

 - Each user can get their own process/version(s)/configuration(s)
 - Hooks into any Auth
 - Only requires a browser


---- 

# Use cases

## Education

The format of the notebook is attractive for Education/Tutorial
  
## Small Data analytics

AKA "Fit in memory", run on your laptop. 


--

# HPC

## Batch Jobs

You can run notebook in a headless manner... but not the best usecase

## Interactive Cluster. 

- Run a Hub (hook into LDAP/PAM...)
- Run notebook server on a Head node
- Run Kernels on head Node/fast queue
- Workers on Batch queue/cluster.

----

# Example of Famous notebook workflow. 

-- 

## LIGO gravitaional wave 

![](ligo-1.png)


- Binder (data subset): https://github.com/minrk/ligo-binder

-- 

## Pangeo

(GeoScience in the cloud)

![](pangeo-1.png)

- [JupyterHub, Dask, and XArray on the Cloud](https://pangeo-data.github.io/work/2018/01/25/cloud-deployment/)
- [http://pangeo.pydata.org/](http://pangeo.pydata.org/)
-- 

## Cern's SWAN

![SWAN](swan-screen.png)

[https://swan.web.cern.ch/](https://swan.web.cern.ch/)


- http://jupyterhub.readthedocs.io/en/latest/gallery-jhub-deployments.html





----



