#-*- coding: utf-8 -*-
import datetime
import parallel
from .modules import createstimuli


from django.contrib import messages
from django.shortcuts import render

from eegbrowse.forms import LoginForm
from eegbrowse.forms import NextForm
from .modules.marker import baparallel


# def hello(request):
#    text = """<h1>welcome to my app !</h1>"""
#    return HttpResponse(text)


# def hello(request):
#    today = datetime.datetime.now().date()
#    return render(request, "hello.html", {"today" : today})
p = parallel.Parallel()
p.setData(0)

def hello(request):
    today = datetime.datetime.now().date()
    daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    return render(request, "helloworld.html", {"today": today, "days_of_week": daysOfWeek})

def image(request):
    if 'concepts_list' not in request.session:
        # print("I am here in the if")
        concepts = createstimuli.get_concepts()
        concepts_list = createstimuli.create_shuffled_stimuli(concepts)
        request.session['concepts_list'] = concepts_list
        request.session['iteration'] = 0
#        print("These are the concepts: %s" % concepts_list)
    else:
#        print("I am here in the else")
        concepts_list = request.session['concepts_list']

    # print("These are the concepts: %s" % request.session['concepts_list'])
    # print("This is the session: %s" % request.session.keys())
    if request.session['iteration'] < len(concepts_list):
        mode = concepts_list[request.session['iteration']][0]
        concept = concepts_list[request.session['iteration']][1]
        request.session['iteration'] = request.session['iteration'] + 1
        iteration = request.session['iteration'] - 1
        
        i = iteration % 255 + 1
        print("Marker: %d" % i)
        p.setData(i)
        return render(request, "image.html", {"mode": mode, "concept": concept.lower(), "iteration": iteration})
    else:
        return render(request, "start.html")

def sound(request):
    return render(request, "sound.html")

def text(request):
    return render(request, "text.html")


def start(request):
    request.session.flush()
    return render(request, "start.html")


def login(request):
    username = "not logged in"

    if request.method == "POST":
        # Get the posted form
        MyLoginForm = LoginForm(request.POST)
        if MyLoginForm.is_valid():
            username = MyLoginForm.cleaned_data['username']
        else:
            messages.error(request, "Error")
    else:
        MyLoginForm = LoginForm()

    return render(request, 'loggedin.html', {"username": username})

