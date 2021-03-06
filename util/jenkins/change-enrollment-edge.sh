cd configuration
pip install -r requirements.txt
env

ip=$(python playbooks/ec2.py | jq -r '."tag_Name_prod-edge-worker"[0] | strings')
ssh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
manage="cd /edx/app/edxapp/edx-platform && sudo -u www-data /edx/bin/python.edxapp ./manage.py lms change_enrollment"

if [ $"noop" ]; then
  if [ ! -z "$username" ]; then
    $ssh ubuntu@"$ip" "$manage --noop --course $course --user $name --to $to --from $from --settings aws"
  else
    $ssh ubuntu@"$ip" "$manage --noop --course $course --to $to --from $from --settings aws"
  fi
  elif [ ! -z "$username" ]; then
    $ssh ubuntu@"$ip" "$manage --course $course --user $name --to $to --from $from --settings aws"
  else
    $ssh ubuntu@"$ip" "$manage --course $course --to $to --from $from --settings aws"
  fi
fi
