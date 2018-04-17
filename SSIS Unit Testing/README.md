# Introduction
TODO: Trying to figure out how best to do SSIS Package unit testing. 

# Getting Started
There are 3 projects in the solution.

## isp1
An example SQL 2017 database which is consumed by the SSIS Package.  Build and deploy this to a local or an Azure db instance.

## ssisDBTest
SSIS DB tool project which contains 2 SSIS packag definitions.  One package will read allow the rows of a table and insert a record count into another table.  The other SSIS package calls the first one and contains the text 'test' to indicate it's a unit test.

If the second SSIS package runs without errors then the unit test is said to have 'passed'.

## SSISDevOpsPowerShell
These are PowerShell Scripts which have been partially validated which can deploy SSIS Packages to an Azure Data Factory for processing.

# Contribute
All contributions are welcome.

Darren Rich