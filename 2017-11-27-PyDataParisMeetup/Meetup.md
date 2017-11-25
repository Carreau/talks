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

# IPython, I for Interactive

## Jupyter and the IPython kernel, hidden and awaiting implementation features

---

# About me

Matthias Bussonnier – University of California, Berkeley Institute Data Science 

@mbussonn/@carreau

<!--Hello there, I'm Matthias, I'm really happy to be here tonight  and speak with you. Huge thanks to Sylvain and Sebastien for organising and EDF for having us here tonight. It's going to be tough to deliver a talk at the level of Emanuelle. As you can HEAR I am French, and to be honest right now my brain does not know which language to speak so if I go too fast, or start speaking French, don't hesitate to interrupt me. -->

<!-- That's also apply if you have questions (if we are not recorded) otherwise let's try to keep the questions for the end. I'm happy to have this talk be more interactive. -->


## A bit of history

<!-- So circa 2011, I was doing a PhD, Here in paris 11th, at Institut Curie and had to deal with experimental data. While most of the lab used matlab, I was more attracted to Python because of all the software ingeniering features it provided that matlab did not. And especially if you have data to **Explore**  one of the Key package to to that was IPython (reminder, at that time the notebook was not a thing, and the QtConsole was just released).-->

<!-- As a reminder for those of you who were not aware of IPython at that time, or just because 2011 was a long time ago; IPython was create in 2001 (By Fernando Perez) and Used to be only a Shell up until ~2011. Thanks to a Grant from Enthought, the Core of IPython was reworked to be be (optionally) two processes, and lead to what is now the QtConsole and the base of the Protocol that gave birth to the nottebooks-->

<!-- So here I go using IPython, and starting to fill-in bugs, and  send PRs. So by the start of My PhD I wa doing a LOT of PhD, a bit of IPython, and by the end – as any procrastinating Graduate student – a bit of PhD a LOT of IPython. I still graduated BTW. And hence -->

I've now been an IPython/Jupyter Developer for about 6 years.
(got commit right, helped create the Notebok, Jupyter, NbConvert, Nbviewer... )

-- 

<!-- There was one particularly important part in what I said earlier, which is not trivial, and is one of the key that makes IPython (and Python) a popular language : -->

Explore.

<!-- You see if you look at the spectrum of what we can call "Programming", one one hand you have Elliot Alderson right (Mr Robot for those not following) that's the "Standard Sofware Engeniering", you are a point A, you know you want  (or are told) to go to point B, you know all that's in between, or have little to no chance to try quickly your program on eisting data. That's mostly what "traditional" IDE are good for. Create medium to large projects with a known end goal, unit test...etc -->

<!-- On the other end of the spectrum you have exploratory programming. Programming is not an end-goal, it's a tool to explore data, it's there to empower the user at the keyboard to multiply their ability. The users have often extremely deep domain specific knowlege, which is required to work this problem, and may not know everythong about Time complexity or even API, and most often they need to see the result of step N to decide what step N+1 should be (or what step N-1) should have been. I like to think of this end as Your (or My) Grand Mother, you've shown her how to mail to you pictures she took,  to print pictures of Cat she found on the internet and she ends up printing cat images and take pictures of them to mail them to you. If it works its not dumb.  -->

<!-- IPython focus a lot on the exploratory part -->

I in IPython is for interactive and it's not lower case I <!--,we don't charge $999, though I'm pretty sure there are plugins for Animoji, and Facerecognition look at Sylvain, Martin and widgets-->, 
<!-- So let's have a look at some of the features of IPython -->

<!-- start terminal --> 

<!--
  - classing out vs print ("Hello Paris")
  
    my_list = ["Hello"]
    my_list[0].<tab>
   
    can completer we have type inference.
   
    from random import choice
    item = choice(['hello', 0])
    item.
--> 
And that's where IPython/Jupyter starts to differentiate from "Classic" IDE

<!-- 
Shell esape
-->
    
load_ext rpy2.ipython
%%R 1+1
array([ 2.])


## Ast nodes interactivity

## disp and Update Display

## Things to come

Async All the things !
Unless you've been living under a rock, you may have heard about `async` and `await` (not be be confused with AsyncIO)

    
    
   
   










