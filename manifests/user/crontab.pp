define cron::user::crontab (
  $ensure  = file,
  $owner   = undef,
  $group   = undef,
  $mode    = '0600',
  $path    = $cron::user_crontab_path,
  $content = undef,
#  $content = template('cron/usercrontab.erb'),
  $vars    = undef,
  $entries = undef,
){
 
  include ::cron
 
  if $owner == undef {
    $myowner = $name
  }
  else {
    $myowner = $owner
  }
 
  if $group == undef {
    $mygroup = $name
  }
  else {
    $mygroup = $group
  }
 
  if $entries != undef {
    validate_hash($entries)
    notify { "My Entries are $entries": }
    $myentries = $entries
  }
 
  if $vars != undef {
    validate_hash($vars)
    notify { "My Variables are $vars": }
    $myvars = $vars
    $myusercronvars = $vars
  }
 
  if is_string($myowner) == undef { fail('cron::user::crontab::owner must be a string') }
  if is_string($mygroup) == undef { fail('cron::user::crontab::group must be a string') }
 
  validate_absolute_path($path)
  validate_re($ensure, '^(absent|file|present)$', "cron::fragment::ensure is ${ensure} and must be absent, file or present")
  validate_re($mode, '^[0-7]{4}$', "cron::fragment::mode is <${mode}> and must be a valid four digit mode in octal notation.")
 
  file { "${path}/${name}":
    ensure  => file,
    owner   => $myowner,
    group   => $mygroup,
    mode    => $mode,
    content => $content ? {
      undef => template('cron/test.erb'),
      default => $content,
    },
    require => File[crontab],
  }


 
}
