# Windows-Image-Maker

A Powershell Script and Structure to customise windows 10/11 ISO Images quickly and without hassle.

This saves days to weeks of stuffing around when It comes to making your own customized Windows Image.  There are plenty of other reasons to want to make your own Windows Image - and this will do that job for you easily.

I created this script because of Microsoft Intune.   In an enterprise rollout project, I found that default builds of windows with intune added via ppkg or autopilot could take anywhere from 3 hours to 3 days to complete.  Given the nature of our corporation, this was unacceptable.  Added to that, the load on the local network when building more then 20 machines at a time (With Adobe/Office installs being over 10gb each) was very high.  I wanted to build the computers quickly - a USB 3 Key build takes about 10 minutes, and after a 15m wait for Intune to settle, Users can login and be ready to go in another 10 minutes.  

I do understand there debate as to whether a brand new computer needs to be rebuilt from scratch (BYOD), but localized Bloatware - Un-needed apps, automatic updates we have no control over and "Free Software" already installed made this undesirable.  Also, autopilot requires you to login first, get the Hash key, import it and THEN rebuild... We decided to go with PPKG Instead.

This also solves the issue when trying to install huge programs like Autocad/Revit, Full Adobe Suite etc. Getting these applications into intune is a nightmare - Intune often spits these applications back out due to size limits or time-outs. Using a customized windows install means the files are already local, and you can just create an tiny intunewin package containing the install script.  This has worked perfectly.

Lastly, if you have MS Teams in your environment - script it as part of the build and install it FIRST.  It saves all kinds of hassles with intune and later installs.

Cheers



Windows Image maker :-

Easy to create multiple versions - Just rename the powershell script and a root directory with the same name will be created in the same folder.
Windows 10/11 ISO File pop-up request
Custom Drivers for multiple computers
Windows Updates embedded
Custom Background and Lockscreen pictures
Windows PE / Boot.wim drivers   (Wifi and Network Drivers embedded)
Localized program install files and Automated Install script
Autounattend file to load drivers and set the startup script, Region etc.



