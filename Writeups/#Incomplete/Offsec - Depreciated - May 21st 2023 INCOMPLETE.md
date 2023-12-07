---
tags:
  - windows
---
Target 192.168.213.170

nmap 192.168.213.170 -p 22,80,5132,8433 -sV -vvv -T4 --open -Pn


New option --open = only shows open ports

  

Also tip for -Pn is if I know a port is open but being blocked by a firewall or a proxy etc, I can force normal scanning since nmap will typically scan if it sees the host is up.

  

22/tcp   open  ssh     syn-ack OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)

80/tcp   open  http    syn-ack nginx 1.18.0 (Ubuntu)

5132/tcp open  unknown syn-ack

8433/tcp open  http    syn-ack Werkzeug httpd 2.0.2 (Python 3.8.10)

  

Check the website on 80

  

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<title>Under Maintainence</title>

<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">

<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>

<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

  

<style>

body {

    background: #dedede;

}

.page-wrap {

    min-height: 100vh;

}

</style>

</head>

<body>

  

<div class="page-wrap d-flex flex-row align-items-center">

<div class="container">

    <div class="row justify-content-center">

<div class="col-md-12 text-center">

<span class="display-1 d-block">Under Maintainence</span>

    <div class="mb-4 lead">For sometime web UI will stay down, please use the CLI application on port 5132</div>

</div>

    </div>

</div>

</div>

  

<!--commenting the code until we fix the whole application-->

   <!--<div class="row">-->

      <!--<div class="col-lg-4 col-sm-offset-2">-->

         <!--<div class="panel panel-primary">-->

            <!--<div class="panel-heading">Login</div>-->

            <!--<div class="panel-body">-->

               <!--<div class="col-md-6">-->

       <!--<form method="post" action="http://127.0.0.1:8433/graphql?query={login(username:$uname, password:$pswd)}" enctype="multipart/form-data">-->

                     <!--<div class="form-group">-->

                        <!--<label for="uname">Username</label>-->

                        <!--<input type="text" placeholder="username" name="uname" class="form-control"><br>-->

                        <!--<label for="pswd">Password</label>-->

                        <!--<input type="text" placeholder="password" name="pswd" class="form-control"><br>-->

                        <!--<button class="btn btn-primary" type="submit">Submit</button>-->

                     <!--</div>-->

                  <!--</form>-->

               <!--</div>-->

            <!--</div>-->

            <!--<div class="panel-footer">-->

               <!--<center>-->

                  <!--<p style="font-size:2em;color: black">    </p>-->

               <!--</center>-->

            <!--</div>-->

         <!--</div>-->

      <!--</div>-->

   <!--</div>-->

</body>

</body>

</html>

![](https://lh6.googleusercontent.com/F2-ShJpd9YV3x3vSifk-nkfA2ZQIfGswxxgN_40OywQYzLdM9w2RY4F7tpocoKcC_vRsSfckHsbydK6yStuYXVKN5Lqw2pixoixRQhJrHGq0O24kTmBKoxFmJMxzn5OiGA=w1280)

Now to check port 5132

Run nc to check

nc -v 192.168.213.170 5132

  

nc -v 192.168.213.170 5132

192.168.213.170: inverse host lookup failed: Unknown host

(UNKNOWN) [192.168.213.170] 5132 (?) open

Enter Username: admin One Shot

Enter OTP: 3425752 Random

Incorrect username or password

Service asks for an OTP

  

8433 runs GraphQL with the login format as seen in the code comments

  

 Use graphQL to pull data from the app

![](https://lh3.googleusercontent.com/ZtbXKs5z8OvbTiQcg5JqfRuD2HVgbEFMRG56zC4v207ju5FkspCfSwmZt3JMekLSBwtCSqV2LbwmdfEYRD5TaMPJeG3AGky5s-F8p710Zvsh2nKt9aS-quywgc6gYcostQ=w1280)

{

  getOTP(username:"peter")

}

  

{

  "data": {

    "getOTP": "Your One Time Password is: nuWWLk8Ub05tP6zJ"

  }

}