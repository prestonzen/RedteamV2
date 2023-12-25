
## HTTP in detail

[![N|Solid](https://tryhackme-images.s3.amazonaws.com/user-uploads/62c435d1f4d84a005f5df811/room-content/f54f3b9acec93f9cdbf2f1811dff1e70.png)
https://tryhackme.com/room/httpindetail

Added by Shuvro on Dec 25, 2023. This is a writeup for HTTP in detail module under Web Hacking Fundamental room on TryHackMe, and this is his first writeup ever.

## Task 1: What is HTTP(s)

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

![[Screenshot 2023-12-25 at 9.55.33 PM.png]]

## Task 2: Request & Response
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
