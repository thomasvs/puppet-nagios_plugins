define nagios_plugins::check::rbl (
  $ensure                   = undef,
  $servicegroups            = undef,
  $check_period             = $::nagios::client::service_check_period,
  $contact_groups           = $::nagios::client::service_contact_groups,
  $first_notification_delay = $::nagios::client::first_notification_delay,
  $max_check_attempts       = $::nagios::client::service_max_check_attempts,
  $notification_period      = $::nagios::client::service_notification_period,
  $use                      = $::nagios::client::service_use,
) {

  include ::nagios::client
  include ::nagios_plugins::check::rbl::install

  nagios::service { "check_rbl_${title}":
    ensure                   => $ensure,
    check_command            => "check_rbl!${title}",
    service_description      => "rbl ${title}",
    servicegroups            => $servicegroups,
    check_period             => $check_period,
    contact_groups           => $contact_groups,
    first_notification_delay => $first_notification_delay,
    notification_period      => $notification_period,
    max_check_attempts       => $max_check_attempts,
    use                      => $use,
  }
}
