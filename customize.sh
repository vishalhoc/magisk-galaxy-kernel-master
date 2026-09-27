SKIPUNZIP=0

ui_print "***********************************************"
ui_print "*   Galaxy Kernel Master & Router Optimizer   *"
ui_print "*        Samsung Galaxy M32 5G (MT6853)       *"
ui_print "***********************************************"

ui_print "- Installing Kernel Master & Router Engine..."
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm $MODPATH/service.sh 0 0 0755
set_perm $MODPATH/action.sh 0 0 0755
set_perm $MODPATH/post-fs-data.sh 0 0 0755
set_perm $MODPATH/system/bin/kernel_master 0 0 0755
set_perm $MODPATH/web/cgi-bin/api.cgi 0 0 0755

ui_print "- Configuring Web Control Panel on port 8090..."
ui_print "- Complete! Access Web UI at http://localhost:8090"
ui_print "  or forward via ADB: adb forward tcp:8090 tcp:8090"
