class nagios_plugins::check::rbl::install (
  $servers                  = undef,
) {
  $default_servers = [
    'cbl.anti-spam.org.cn',
    'cblplus.anti-spam.org.cn',
    'cblless.anti-spam.org.cn',
    'cdl.anti-spam.org.cn',
    'cbl.abuseat.org',
    'dnsbl.cyberlogic.net',
    'bl.deadbeef.com',
    't1.dnsbl.net.au',
    'spamtrap.drbl.drand.net',
    'spamsources.fabel.dk',
    '0spam.fusionzero.com',
    'mail-abuse.blacklist.jippg.org',
    'korea.services.net',
    'spamguard.leadmon.net',
    'ix.dnsbl.manitu.net',
    'relays.nether.net',
    'no-more-funn.moensted.dk',
    'psbl.surriel.com',
    'dyna.spamrats.com',
    'noptr.spamrats.com',
    'spam.spamrats.com',
    'dnsbl.sorbs.net',
    'dul.dnsbl.sorbs.net',
    'old.spam.dnsbl.sorbs.net',
    'problems.dnsbl.sorbs.net',
    'safe.dnsbl.sorbs.net',
    'spam.dnsbl.sorbs.net',
    'bl.spamcannibal.org',
    'bl.spamcop.net',
    'pbl.spamhaus.org',
    'sbl.spamhaus.org',
    'xbl.spamhaus.org',
    'ubl.unsubscore.com',
    'dnsbl-1.uceprotect.net',
    'dnsbl-2.uceprotect.net',
    'dnsbl-3.uceprotect.net',
    'db.wpbl.info',
  ]

  package { [
    'perl-Data-Validate-Domain',
    'perl-Data-Validate-IP',
    'perl-Nagios-Plugin',
    'perl-Readonly',
  ]:
    ensure => installed,
  }

  if ($servers) {
    $real_servers = $servers
  } else {
    $real_servers = $default_servers
  }

  $server_args = inline_template(
    '<% @real_servers.each do | server | %>-s <%= server %> <% end -%>')


  file { "${nagios::client::plugin_dir}/check_rbl":
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    links  => 'follow',
    source => "puppet:///modules/nagios_plugins/plugins/check_rbl",
  }

  nagios_command { 'check_rbl':
    # 15 sec timeout was reached on vagrant
    command_line => "\$USER1\$/check_rbl ${server_args}-t 90 -H \$ARG1\$",
  }

}
