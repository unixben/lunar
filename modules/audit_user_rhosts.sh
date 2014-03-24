# audit_user_rhosts
#
# While no .rhosts files are shipped with Solaris, users can easily create them.
# This action is only meaningful if .rhosts support is permitted in the file
# /etc/pam.conf. Even though the .rhosts files are ineffective if support is
# disabled in /etc/pam.conf, they may have been brought over from other systems
# and could contain information useful to an attacker for those other systems.
#
# Refer to Section 9.2.10 Page(s) 169-70 CIS CentOS Linux 6 Benchmark v1.0.0
#.

audit_user_rhosts () {
  if [ "$os_name" = "SunOS" ] || [ "$os_name" = "Linux" ]; then
    funct_verbose_message "User RHosts Files"
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  User rhosts files"
    fi
    check_fail=0
    for home_dir in `cat /etc/passwd |cut -f6 -d":" |grep -v "^/$"`; do
      check_file="$home_dir/.rhosts"
      if [ -f "$check_file" ]; then
        check_fail=1
        funct_file_exists $check_file no
      fi
    done
    if [ "$check_fail" != 1 ]; then
      if [ "$audit_mode" = 1 ]; then
        total=`expr $total + 1`
        score=`expr $score + 1`
        echo "Secure:    No user rhosts files exist [$score]"
      fi
    fi
  fi
}
