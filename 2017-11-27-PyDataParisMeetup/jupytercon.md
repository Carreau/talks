---
title: Protocols and Kernels
separator: \n---- ?\n
verticalSeparator: \n-- ?\n
theme: jupyter
highlightTheme : darcula
revealOptions:
    transition: 'slide'
    slideNumber: 'c/t'

---

# Protocols and Kernels


Paul Ivanov – Matthias Bussonnier

JupyterCon – August 25, 2017, NYC

----

<!-- .slide: class="jupyter-light" -->

# About Us


Paul Ivanov  - Bloomberg LP – @ivanov
<!-- .element: class="fragment" data-fragment-index="1" -->


Matthias Bussonnier – UC BIDS - @mbussonn/@carreau
<!-- .element: class="fragment" data-fragment-index="2" -->


-- 

----


# Part II 

--

 - Rich display messages
 - Tab Completion

<!-- 
In this part I'm going to dive into 2 subject:
- The rich display protocol, 
- Completion

-->
-- 
## The display messages

Part of the Jupyter Protocol which allow the kernel to send data to:

  - Be displayed to the user, now or later
  - Be stored in a document (e.g., notebook file)

-- 

### On he wire

It is part of the IOPub channel (Broadcasted)


In particular for __Display Data__

 ```
 {
    'data' : dict,
    'metadata' : dict,
    'transient': dict,
 }
```

<!-- 

If we do not dive into details on how to associate a request to a reply, 
we can see three fields: data, metadata and transient. 

The data field is a mapping from mime type to the actual data for this mimetype. – we'll come back to that just after 

The metadata field contain a mapping from mimetype to metadata for the
associated mimetype. The metadata can be safely ignored, but could contain extra
informations like preferred width/height for an image, 

The transient dict is for information which do make sens while the kernel is
alive, but should not be persisted in a document. 

Let's focus on the `data` field
-->

-- 

## `data`

Mimetype keyed dictionary, values should be interpreted by the frontend.

- Kernel sends _all_ mimetypes.
- Notebook frontend stores _all_ values.
- Allows _a posteriori_ choices 
- handling of custom unknown mimetypes by extensions

<!--

It is important to understand that this information is broadcasted, the kernel
does not have any idea that the execution request comes from 

  - Classic notebook
  - Nteract
  - JupyterLab
  - Hydrogen

Even if the execution comes from one of these it might not be the only one
listening. Hence we do not make assumptions about the frontend and send all the
mimetyes. 

This allow the frontend to decide, and in particular to store all information
for a posteriori re rendering. 

So far we have not introduced any language specificity in our description. 
Our kernel, which is a dispatching process is responsible from creating these
mimebundle. The mechanism by which this is done may not be part of the
underlying language. 

-->

-- 

## In IPython

In IPython the display portion of the protocol can be implemented in 2 ways:
  - Using `_repr_*_` methods
  - By registering `formatters`

It is triggered in 2 cases:
  - When calling `display` on an object
  - On the result of the last expression in a cell

-- 

## repr methods

```python
class MultiMime:
    
    def __repr__(self):
        return "this is the repr"
    
    def _repr_html_(self):
        return "This <b>is</b> html"
    
    def _repr_markdown_(self):
        return "This **is** mardown"

    def _repr_latex_(self):
        return "$ Latex \otimes mimetype $"
```

```
MultiMime()
```

```
display(MultiMime())
```
-- 


## registering formatters

-- 

```python
ipython = get_ipython()
html_formatter = ipython.display_formatter.formatters['text/html']

html_formatter.for_type(type, function(object)->data )
```

```python
from requests import Responses
def req_formatter(response):
    return "&lt;This is a response object&gt;"
html_formatter.for_type(Response, req_formatter)
```

```
requests.get('https://api.github.com')
```

-- 

## Demo

-- 

- Kernel can use display mechanism not native to language
- Send _all_ the mimetypes
- Do not assume which frontend you are working in

-- 

## Tab completion

-- 

### what is tab completion ?

- Shortcut from one state of document to another state.
    - *Most* of the time : append text.
    - Most editor : static analysis

-- 

### Jupyter Tab completion

It is part of the Shell channel (Not Broadcasted). Completion only make sens
for the client requesting it.

```
# request
content = {
    'code' : str, # may be multiline

    # The cursor position within 'code' (in unicode codepoints) 
    'cursor_pos' : int,
}
```

Reply : A list "Patches", replace from... to ... by ...

-- 

- More generic than append
  - `\alpha` -> `α`
  - `maltp` -> `%matplotlib`
  - Equivalent of a Microsoft LSP `TextEdit`s
 
-- 

- Kernel Decide how to dispatch completion. 
  - Static Analysis
  - Inspection of current state

-- 

## Demo

-- 

Kernels are processes managing user requests.
  - They are not limited to one language. 
  - Implementation can be in a different language (metakernel, Xeus, ... )
  - Implementation do not make full use of protocol

&nbsp;
- Lots of protocol details we haven't seen here.
- Mostly scratches only the classic notebook interface.

-- 

# Related Talks

- **L. Gautier :** Polyglot Data Analysis with SQL, Python and R
- **K. Kelley, B. Granger : ** Jupyter Frontends: From classic jupyter notebook
- **S. Corlay, J. Mabille : ** Xeus : A framework for writing Juyter Kernels
- **M. Pacer, J. Hamrick, D. Avila :** Jupyter notebook as a document

# Thanks!

