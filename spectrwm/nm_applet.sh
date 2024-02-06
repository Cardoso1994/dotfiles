 #!/bin/sh
 
 # displays network manager as a standalone window
 # requires stalonetray package
 

 nm-applet    > /dev/null 2>/dev/null &
 stalonetray  > /dev/null 2>/dev/null
 killall nm-applet
