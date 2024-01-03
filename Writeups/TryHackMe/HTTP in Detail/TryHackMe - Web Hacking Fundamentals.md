
## HTTP in detail

[![N|Solid](https://tryhackme-images.s3.amazonaws.com/user-uploads/62c435d1f4d84a005f5df811/room-content/f54f3b9acec93f9cdbf2f1811dff1e70.png)
https://tryhackme.com/room/httpindetail

Added by Shuvro on Dec 25, 2023. This is a writeup for HTTP in detail module under Web Hacking Fundamental room on TryHackMe, and this is his first writeup ever.

### Task 1: What is HTTP(s)

#### Discussion

**What is HTTP? (HyperText Transfer Protocol)**

HTTP is what's used whenever you view a website, developed by Tim Berners-Lee and his team between 1989-1991. HTTP is the set of rules used for communicating with web servers for the transmitting of webpage data, whether that is HTML, Images, Videos, etc.

**What is HTTPS? (HyperText Transfer Protocol Secure)**

HTTPS is the secure version of HTTP. HTTPS data is encrypted so it not only stops people from seeing the data you are receiving and sending, but it also gives you assurances that you're talking to the correct web server and not something impersonating it.

#### Answers of the questions

What does HTTP stand for?

> HyperText Transfer Protocol

What does the S in HTTPS stand for?

> Secure

On the mock webpage on the right there is an issue, once you've found it, click on it. What is the challenge flag?

> THM{INVALID_HTTP_CERT}

Explanation: 
- click on the lock of the URL
- You'll get the flag as a Pop-up

![[HTTPinDetail-Cover.png]]

### Task 2: Request & Response
#### Discussion

**What is a URL? (Uniform Resource Locator)**

A URL is a unique code that can uniquely identify contents across the web.

![sample url](https://tryhackme-images.s3.amazonaws.com/user-uploads/5c549500924ec576f953d9fc/room-content/34ad66d8b90aaaa35f9536d3b152ea97.png)


- Scheme tells you what way to connect to a resource, like using HTTP, HTTPS, or FTP.

- User info, like a username and password, can be added to the URL if needed for logging in.

- Host is the server's domain name or IP address.

- Port is the connection point, usually 80 for HTTP and 443 for HTTPS, but it can be any number from 1 to 65535.

- Path is the file or location you want on the server.

- Query String is extra info for the requested path, like /blog?id=1 to get a specific blog.

- Fragment is a reference to a specific part of the page, useful for long content.


#### Making a request
It's possible to make a request to a web server with just one line "**GET / HTTP/1.1**"
![How to Make a Request?](https://tryhackme-images.s3.amazonaws.com/user-uploads/5c549500924ec576f953d9fc/room-content/09e70200e7af451077081a3ee3d3708c.png)
For a more interactive web experience, additional information needs to be sent. This data is conveyed through headers. Headers carry supplementary details to provide to the web server you're interacting with. 

**HTTP Request**

```http
GET / HTTP/1.1
Host: tryhackme.com
User-Agent: Mozilla/5.0 Firefox/87.0
Referer: https://tryhackme.com/
```

1. The first line indicates that this request uses the GET method (details covered in the HTTP Methods task), seeks the home page ("/"), and specifies the use of HTTP protocol version 1.1.

2. Line 2 specifies the desired website: tryhackme.com.

3. Line 3 communicates that the request is coming from a browser using Firefox version 87.

4. Line 4 conveys that the web page referring us to this one is https://tryhackme.com.

5. Every HTTP request concludes with a blank line to signal the completion of the request to the web server.

**HTTP Response**

```http
HTTP/1.1 200 OK
Server: nginx/1.15.8
Date: Fri, 09 Apr 2021 13:34:03 GMT
Content-Type: text/html
Content-Length: 98

<html>
<head>
    <title>TryHackMe</title>
</head>
<body>
    Welcome To TryHackMe.com
</body>
</html>
```

Breaking down each line of the response:

1. The first line talks about the version of the HTTP protocol (HTTP 1.1) and the status code (200 OK), indicating that the request was successful.

2. Line 2 provides information about the web server software and its version.

3. Line 3 mentions the current date, time, and timezone of the web server.

4. Line 4, the Content-Type header, informs the client about the type of data it can expect, like HTML, images, videos, PDF, or XML.

5. Line 5, Content-Length, specifies the size of the response so the client can ensure no data is missing.

6. Line 6 is a blank line, marking the end of the HTTP response.

7-14. The remaining lines (7-14) contain the information requested, which, in this case, is the content of the homepage.

#### Answers of the questions

What HTTP protocol is being used in the above example?

> 	HTTP/1.1

What response header tells the browser how much data to expect?

> Content-length

Explanation: 

- Content-Length specifies the expected size of the response so the client can ensure no data is missing.


### Task 3: HTTP Methods
#### Discussion

There are many http methods which are basically ways for the client to ask for an action while making an http request. GET and POST methods are widely used ones.

##### GET Request

This method is used to get information from the web servers.
##### POST Request

This method is used to submit new data to the web server and potentially creating new records.

##### PUT Request

Put method is used for submitting data to a web server to update existing information.

##### **DELETE Request**  

This is used for deleting information/records from a web server.

#### Answers of the questions

What method would be used to create a new user account?

> POST

What method would be used to update your email address?

> PUT

What method would be used to remove a picture you've uploaded to your account?

> DELETE

What method would be used to view a news article?

> GET


### Task 4: Status Code

#### Discussion

| Status Code |  Response Type |  Description |
|:-----------:|:-----------:|:-----------:|
| 100-199 | Information Response | These are sent to tell the client the first part of their request has been accepted and they should continue sending the rest of their request. These codes are no longer very common. |
| 200-299 | Success | These status codes tell the clients that their request was successful. |
| 300-399 | Redirection | These are used to redirect the client's request to another resource. This can be either to a different webpage or a different website altogether. |
| 400-499 | Client Errors | Used to inform the client that there was an error with their request. |
| 500-599 | Server Errors | This is reserved for errors happening on the server-side and usually indicate quite a major problem with the server handling the request. |

**Common HTTP Status Codes:**

| Status Code | Keyword | Description |
|:-----------:|:-----------:|:-----------:|
| 200 | OK | The request completed successfully. |
| 201 | Created | A new resource has been created (for example a new user or new blog post). |
| 301 | Moved Permanently | This redirects the client's browser to a new webpage or tells search engines that the page has moved somewhere else and to look there instead. |
| 302 | Found | Similar to the above permanent redirect, but as the name suggests, this is only a temporary change and it may change again in the near future. |
| 400 | Bad Request | This tells the browser that something was either wrong or missing in their request. This could sometimes be used if the web server resource that is being requested expected a certain parameter that the client didn't send. |
| 401 | Not Authorised | You are not currently allowed to view this resource until you have authorised with the web application, most commonly with a username and password. |
| 403 | Forbidden | You do not have permission to view this resource whether you are logged in or not. |
| 405 | Method Not Allowed | The resource does not allow this method request, for example, you send a GET request to the resource /create-account when it was expecting a POST request instead. |
| 404 | Page Not Found | The page/resource you requested does not exist. |
| 500 | Internal Service Error | The server has encountered some kind of error with your request that it doesn't know how to handle properly. |
| 503 | Service Unavailable | This server cannot handle your request as it's either overloaded or down for maintenance. |

#### Answers of the questions

  
What response code might you receive if you've created a new user or blog post article?

> 201

![[201-created.png]]

What response code might you receive if you've tried to access a page that doesn't exist?

> 404

![[404-notFound.png]]
What response code might you receive if the web server cannot access its database and the application crashes?

> 503

![[503-ServiceUnavailable.png]]
What response code might you receive if you try to edit your profile without logging in first?

> 401

![[401-NotAuthorised.png]]

### Task 5: Headers

#### Discussion

Headers are additional bits of data that client send to the web servers while making a request. Although it is not compulsory but it enhance the overall user experience in viewing a webpage.

Headers can be roughly divided into two. 
- Request Headers
- Response Headers

**Common Request Headers**

**Host**: As web servers contain multiple websites, so host header specifies which exact website client wants to view. If not mentioned, server will show default website.

**User-Agent**: This is your browser software and version number, telling the web server your browser software helps it format the website properly for your browser and also some elements of HTML, JavaScript and CSS are only available in certain browsers.

**Content-Length**: When sending data to a web server such as in a form, the content length tells the web server how much data to expect in the web request. This way the server can ensure it isn't missing any data.

**Accept-Encoding**: Tells the web server what types of compression methods the browser supports so the data can be made smaller for transmitting over the internet.

**Cookie:** Data sent to the server to help remember your information (see cookies task for more information).

**Common Response Headers**

These are the headers that are returned to the client from the server after a request.

**Set-Cookie:** Information to store which gets sent back to the web server on each request (see cookies task for more information).  

**Cache-Control:** How long to store the content of the response in the browser's cache before it requests it again.  

**Content-Type:** This tells the client what type of data is being returned, i.e., HTML, CSS, JavaScript, Images, PDF, Video, etc. Using the content-type header the browser then knows how to process the data.  

**Content-Encoding:** What method has been used to compress the data to make it smaller when sending it over the internet.

#### Answer the questions below

What header tells the web server what browser is being used?  

> User-Agent

What header tells the browser what type of data is being returned?  

> Content-Type

What header tells the web server which website is being requested?  

> Host

### Task 6: Cookies

#### Discussion

- Cookies are saved when you receive a "Set-Cookie" header from a web server.
- Because of HTTP being stateless, every further request you make, you'll send the cookie data back to the web server. Cookies can be used to remind the web server who you are, some personal settings for the website or whether you've been to the website before.

![[cookies.png]]
The cookie value won't usually be a clear-text string where you can see the password, but a token (unique secret code that isn't easily humanly guessable).

#### Answer the questions below

Which header is used to save cookies to your computer?

> Set-cookies

### Task 7: Making Requests

#### Discussion

This is an emulator room for making demo HTTP requests.

First, I tried making a GET request to http://tryhackme.com/
The request goes by,

```http
/ HTTP/1.1  
Host: tryhackme.com  
User-Agent: Mozilla/5.0 Firefox/87.0
```

Response got,

```http
HTTP/1.1 200 Ok  
Server: nginx/1.15.8  
Wed, 3 Jan 2024 14:47:58 GMT  
Content-Type: text/html; charset=utf-8  
Content-Length: 209  
Last-Modified: Wed, 3 Jan 2024 14:47:58 GMT  
  
<html>  
<head>  
    <title>TryHackMe</title>  
</head>  
<body>  
    Welcome to TryHackMe.com  
</body>  
</html>
```

Browser shows  -
![[browser-view-1.png]]

#### Answer the questions below

1. Make a GET request to /room  

> THM{YOU'RE_IN_THE_ROOM}

**Explanation:**

As we know from URL topic, '/room' is a path of the domain http://tryhackme.com/ .
A simple GET request to 'http://tryhackme.com/room' resulted in successful access to the resource without requiring authentication. The response contained the flag "THM{YOU'RE_IN_THE_ROOM}" both in the browser display and within the response content.

**GET request:**
```http
/room HTTP/1.1  
Host: tryhackme.com  
User-Agent: Mozilla/5.0 Firefox/87.0
```

**Response:**
```http
HTTP/1.1 200 Ok  
Server: nginx/1.15.8  
Wed, 3 Jan 2024 15:25:58 GMT  
Content-Type: text/html; charset=utf-8  
Content-Length: 233  
Last-Modified: Wed, 3 Jan 2024 15:25:58 GMT  
  
<html>  
<head>  
    <title>TryHackMe</title>  
</head>  
<body>  
    Welcome to the Room page THM{YOU'RE_IN_THE_ROOM}  
</body>  
</html>
```

**Browser View:**
![[1.png]]

2. Make a GET request to /blog and using the gear icon set the id parameter to 1 in the URL field  

> THM{YOU_FOUND_THE_BLOG}

**Explanation:**

As a GET request, I entered /blog as path after www.tryhackme.com and as said in the problem statement, I needed to set the id parameter to 1. So, the complete URL would be http://tryhackme.com/blog?id=1 

**GET Request:**
```http
/blog?id=1 HTTP/1.1  
Host: tryhackme.com  
User-Agent: Mozilla/5.0 Firefox/87.0
```

**Response**
```http
HTTP/1.1 200 Ok  
Server: nginx/1.15.8  
Wed, 3 Jan 2024 15:29:51 GMT  
Content-Type: text/html; charset=utf-8  
Content-Length: 231  
Last-Modified: Wed, 3 Jan 2024 15:29:51 GMT  
  
<html>  
<head>  
    <title>TryHackMe</title>  
</head>  
<body>  
    Viewing Blog article 1 THM{YOU_FOUND_THE_BLOG}  
</body>
</html>
```

**Browser View:**
![[2.png]]

3. Make a DELETE request to /user/1  

> THM{USER_IS_DELETED}

**Explanation:**
I changed the method to DELETE and updated the URL as http://tryhackme.com/user/1 and got the flag in browser.

**DELETE Request:**
```http
DELETE /user/1 HTTP/1.1  
Host: tryhackme.com  
User-Agent: Mozilla/5.0 Firefox/87.0  
Content-Length: 4
```

**Response**
```http
HTTP/1.1 200 Ok  
Server: nginx/1.15.8  
Wed, 3 Jan 2024 15:34:45 GMT  
Content-Type: text/html; charset=utf-8  
Content-Length: 231  
Last-Modified: Wed, 3 Jan 2024 15:34:45 GMT  
  
<html>  
<head>  
    <title>TryHackMe</title>  
</head>  
<body>  
    The user has been deleted THM{USER_IS_DELETED}  
</body>  
</html>
```

**Browser View:**
![[3.png]]

4. Make a PUT request to /user/2 with the username parameter set to admin  

> THM{USER_HAS_UPDATED}

**Explanation:**
As PUT request, I entered /user/2 as path after www.tryhackme.com and as said in the problem statement, I needed to set the username parameter to admin. So, the complete URL would be http://tryhackme.com/blog?username=admin.

**PUT Request:**
```http
/user/2 HTTP/1.1  
Host: tryhackme.com  
User-Agent: Mozilla/5.0 Firefox/87.0  
Content-Length: 23  
  
username=admin
```

**Response:**
```http
HTTP/1.1 200 Ok  
Server: nginx/1.15.8  
Wed, 3 Jan 2024 15:37:23 GMT  
Content-Type: text/html; charset=utf-8  
Content-Length: 232  
Last-Modified: Wed, 3 Jan 2024 15:37:23 GMT  
  
<html>  
<head>  
    <title>TryHackMe</title>  
</head>  
<body>  
    Username changed to admin THM{USER_HAS_UPDATED}  
</body>  
</html>
```

**Browser View:**
![[4.png]]

5. POST the username of thm and a password of letmein to /login

> THM{HTTP_REQUEST_MASTER}

**Explanation:**
This time I will be sending a POST method to the path /login and my authentication parameters will be username of thm and a password of letmein. URL would be http://tryhackme.com/login?username=thm&password=letmein

**POST Request**
```http
POST /login HTTP/1.1  
Host: tryhackme.com  
User-Agent: Mozilla/5.0 Firefox/87.0  
Content-Length: 33  
  
username=thm&password=letmein
```

**Response:**
```http
HTTP/1.1 200 Ok  
Server: nginx/1.15.8  
Wed, 3 Jan 2024 15:41:51 GMT  
Content-Type: text/html; charset=utf-8  
Content-Length: 237  
Last-Modified: Wed, 3 Jan 2024 15:41:51 GMT  
  
<html>  
<head>  
    <title>TryHackMe</title>  
</head>  
<body>  
    You logged in! Welcome Back THM{HTTP_REQUEST_MASTER}  
</body>  
</html>
```

**Browser View:**
![[5.png]]