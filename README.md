# PowersHellSaturday
Code for session titled: Argument completers for the untrusting admin

## Session outline

You work for an organization with an internal development team working on a project called "Project X". The dev team asked the DevOps team to provide them a simple way to get access to the database in a temporary and secure way. Because this is critical to get right, the intern was tasked with completing this work.

Project X has a few different databases to work with.

- customers
- orders
- secrets
- telemetry

Because the intern wanted to impress the DevOps boss, they decided to write a solution in PowerShell to accomplish this task. "This is going to be easy!" they thought as they quickly hammered out a script to get the job done.

The intern's script was simple and it worked... mostly...[New-ProjectXAccess_1.ps1](DemoCode/New-ProjectXAccess_1.ps1). The script was sent out to the dev team and problems immediately started to arise. It turns out that the database platform was case sensitive, so lots of requests were failing.

"VALIDATE THE INPUT!" the DevOps boss yelled. The intern quickly added some validation to the script and sent out a new version [New-ProjectXAccess_2.ps1](DemoCode/New-ProjectXAccess_2.ps1). This version worked.... for a time.


A few months later, the dev team reached back out to the DevOps team to update the script - there was a new project named "The new hotness" that they needed access to. The intern was long gone, so the DevOps team had to take over the script. The script was a mess and the DevOps team decided to rewrite the script from scratch. They wanted to make sure that they didnt have to keep refactoring the script every time a new project was added. Surely there was a better way to do this..
