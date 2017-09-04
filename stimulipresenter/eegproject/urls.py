from django.conf.urls import *
from django.contrib import admin
from django.views.generic import TemplateView

from eegbrowse import views as eegbrowse_views


"""eegproject URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""


urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^eegbrowse/hello/', eegbrowse_views.hello, name ='hello'),
    url(r'^eegbrowse/connection/', TemplateView.as_view(template_name ='login.html')),
    url(r'^eegbrowse/login/', eegbrowse_views.login, name ='login'),
    url(r'^eegbrowse/image/', eegbrowse_views.image, name ='image'),
    url(r'^eegbrowse/sound/', eegbrowse_views.sound, name ='sound'),
    url(r'^eegbrowse/start/', eegbrowse_views.start, name ='start'),
    url(r'^eegbrowse/text/', eegbrowse_views.text, name='text'),
]
