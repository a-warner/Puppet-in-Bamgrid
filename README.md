# Puppet in Bamgrid
Some snippets of how we utilize Puppet in MLBAM which is codenamed bamgrid.

## Custom Facts in Bamgrid
The first and most important thing is our Puppet custom facts.  Our goal is to manage servers as fleets and not as individual hostnames.  Every server gets a layer of metadata applied.  The metadata below is listed from coarsest to finest.
 * env: Dev, QA, Production etc...
 * facility: Location designation and a number.  am1 for amazon1, am2, web1 etc...
 * group: Which team owns the server.  Useful for namespacing, permissioning and contact information for when there are issues.
 * server_type: The fleet the server belongs to.  mlbweb, pushweb, pushapp etc...

## Hiera Configuration
Directly utilizes our custom facts.  You can see an example hiera.yaml in our configuration files.
