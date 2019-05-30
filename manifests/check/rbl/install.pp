class nagios_plugins::check::rbl::install (
  $servers                  = undef,
) {
  # these are taken from upstream check_rbl.ini
  # at commit 2bcc800042e81e2d732d09ebc8cedd6d8a16849e
  # and removing nomorefunn and spamcannibal again
  $default_servers = [
    'cbl.abuseat.org',
    'bl.deadbeef.com',
    'spamtrap.drbl.drand.net',
    'spamsources.fabel.dk',
    '0spam.fusionzero.com',
    'mail-abuse.blacklist.jippg.org',
    'korea.services.net',
    'spamguard.leadmon.net',
    'ix.dnsbl.manitu.net',
    'relays.nether.net',
    'psbl.surriel.com',
    'dyna.spamrats.com',
    'noptr.spamrats.com',
    'spam.spamrats.com',
    'dnsbl.sorbs.net',
    'spam.dnsbl.sorbs.net',
    'bl.spamcop.net',
    'pbl.spamhaus.org',
    'sbl.spamhaus.org',
    'xbl.spamhaus.org',
    'ubl.unsubscore.com',
    'dnsbl-1.uceprotect.net',
    'dnsbl-2.uceprotect.net',
    'dnsbl-3.uceprotect.net',
    'db.wpbl.info',
    'access.redhawk.org',
    'blacklist.sci.kun.nl',
    'dnsbl.kempt.net',
    'forbidden.icm.edu.pl',
    'hil.habeas.com',
    'rbl.schulte.org',
    'sbl-xbl.spamhaus.org',
    'bl.technovision.dk',
    'b.barracudacentral.org',
    'cdl.anti-spam.org.cn',
    'dnsbl.antispam.or.id',
    'dnsbl.inps.de',
    'drone.abuse.ch',
    'dsn.rfc-ignorant.org',
    'dul.dnsbl.sorbs.net',
    'http.dnsbl.sorbs.net',
    'l1.spews.dnsbl.sorbs.net',
    'l2.spews.dnsbl.sorbs.net',
    'misc.dnsbl.sorbs.net',
    'postmaster.rfc-ignorant.org',
    'rbl.spamlab.com',
    'rbl.suresupport.com',
    'relays.bl.kunden.de',
    'short.rbl.jp',
    'smtp.dnsbl.sorbs.net',
    'socks.dnsbl.sorbs.net',
    'spam.abuse.ch',
    'spamrbl.imp.ch',
    'tr.countries.nerd.dk',
    'unsure.nether.net',
    'virbl.bit.nl',
    'virus.rbl.jp',
    'web.dnsbl.sorbs.net',
    'whois.rfc-ignorant.org',
    'wormrbl.imp.ch',
    'zen.spamhaus.org',
    'zombie.dnsbl.sorbs.net',
    'blackholes.five-ten-sg.com',
    'blacklist.woody.ch',
    'bl.emailbasura.org',
    'bogons.cymru.com',
    'combined.abuse.ch',
    'duinv.aupads.org',
    'dynip.rothen.com',
    'ohps.dnsbl.net.au',
    'omrs.dnsbl.net.au',
    'orvedb.aupads.org',
    'osps.dnsbl.net.au',
    'osrs.dnsbl.net.au',
    'owfs.dnsbl.net.au',
    'owps.dnsbl.net.au',
    'probes.dnsbl.net.au',
    'proxy.bl.gweep.ca',
    'proxy.block.transip.nl',
    'rbl.inter.net',
    'rbl.megarbl.net',
    'rdts.dnsbl.net.au',
    'relays.bl.gweep.ca',
    'residential.block.transip.nl',
    'ricn.dnsbl.net.au',
    'rmst.dnsbl.net.au',
    'spamlist.or.kr',
    't3direct.dnsbl.net.au',
    'ubl.lashback.com',
    'all.s5h.net',
    'dnsbl.anticaptcha.net',
    'dnsbl.dronebl.org',
    'dnsbl.spfbl.net',
    'ips.backscatterer.org',
    'singular.ttk.pte.hu',
    'spam.dnsbl.anonmails.de',
    'spambot.bls.digibase.ca',
    'z.mailspike.net',
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
