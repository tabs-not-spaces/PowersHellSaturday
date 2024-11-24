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

The intern's script was simple ([New-ProjectXAccess_1.ps1](DemoCode/New-ProjectXAccess_1.ps1).) and it worked... mostly... 

The script was sent out to the dev team and problems immediately started to arise. It turns out that the database platform was case sensitive, so lots of requests were failing.

"VALIDATE THE INPUT!" the DevOps boss yelled. The intern quickly added some validation to the script and sent out a new version [New-ProjectXAccess_2.ps1](DemoCode/New-ProjectXAccess_2.ps1). This version worked.... for a time.

A few months later, the dev team reached back out to the DevOps team to update the script - there was a new project named "The new hotness" that they needed access to. The original intern was long gone, so the DevOps team asked the current intern to handle the request. The main request was that they wanted to make sure that significant work wasn't required every time a new project was added.
