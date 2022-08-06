# Go Money DevOps Challenge
## Introduction
Hi There. Thanks for reviewing my answers to the Go Money DevOps challenge. Kindly find said answers below.
## Answers
###### Monitoring API uptime and critical service uptime
Monitoring of services like APIs and WebServers are of extreme inportance as it provides priceless insights in the internal working of your application and aids in proactively fixing issue. 

For both these scenarios, I employed the use of upptime. Upptime is an open-source uptime monitor and status page, powered entirely by GitHub Actions, Issues, and Pages. This is a free monitoring tool and has properly mianitained documentation to help one get started easily. Kindly find my Upptime tool [here](https://n0mzee.github.io/upptime-monitor/). For more information on the Upptime utility, check out their [GitHub](https://github.com/upptime/upptime).

![Img of Live Status](/images/livestatus.png)

###### DB activity - Overload, performance.
I mostly work on Azure and I have found that one of the most useful tools for monitowring database performance is the Query store. This tool provides one with inteligent analysis on your SQL databases performance and it works with both on-premise and cloud bases SQL instances. For this scenario, I have deployed an Azure SQL general purpose tier- with 2vCPUs and proceeded monitor its performance using Queue store 

###### Network Infrastructure
For this scenario, I am considering a simple 3 tier application that consist of  webservers, API servers and a databases. Idealy I would have an applciation gate way as the single point of contact between the backend setup and the internet. Next I would place both the web and API servers behind load balancer to aid in the effective distribution of the traffic and further securing the backend. Below is a diagramtic representation of this infrastructure and you can find the terraform code [here](/TF_code).
![Img of Network Infra](/images/diagram.png)

###### How do you upgrade multiple services in a microservice architecture.
In a properly setup microservice architecture application, each of the services are independent from each other but collectively work together to attain the applications functionality. My approach to upgrading multiple services in a microservice architecture, is via versioning. With Microservice versioning, on is able to manage the application effectively and there is always a single functional version of the application in production.