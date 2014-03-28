# funct_no_check
#
# Function to check no under AIX
#.

funct_no_check() {
  if [ "$os_name" == "AIX" ]; then
    parameter_name=$1
    correct_value=$2
    log_file="$parameter_name.log"
    actual_value=`lssrc -a |grep '$parameter_name ' |cut -f2 -d= |sed 's/ //g'`
    if [ "$audit_mode" != 2 ]; then
      echo "Checking:  Parameter \"$parameter_name\" is \"$correct_value\""
      if [ "$actual_value" != "$correct_value" ]; then
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score - 1`
          echo "Warning:   Parameter \"$parameter_name\" is not \"$correct_value\" [$score]"
          funct_verbose_message "" fix
          funct_verbose_message "no -p -o $parameter_name=$correct_value" fix
          funct_verbose_message "" fix
        fi
        if [ "$audit_mode" = 0 ]; then
          log_file="$work_dir/$log_file"
          echo "Setting:   Parameter \"$parameter_name\" to \"$correct_value\""
          echo "$actual_value" > $log_file
          no -p -o $parameter_name=$correct_value
          fi
        fi
      else
        if [ "$audit_mode" = 1 ]; then
          total=`expr $total + 1`
          score=`expr $score + 1`
          echo "Secure:    Parameter \"$parameter_name\" is \"$correct_value\" [$score]"
        fi
      fi
    else
      log_file="$restore_dir/$log_file"
      if [ -f "$log_file" ]; then
        previous_value=`cat $log_file`
        if [ "$previous_value" != "$actual_value" ]; then
          echo "Restoring: Parameter \"$parameter_name\" to \"$previous_value\""
          no -p -o $parameter_name=$previous_value
        fi
      fi
    fi
  fi
}
