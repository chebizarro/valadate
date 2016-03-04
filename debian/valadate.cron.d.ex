#
# Regular cron jobs for the valadate package
#
0 4	* * *	root	[ -x /usr/bin/valadate_maintenance ] && /usr/bin/valadate_maintenance
