# Puppet in Bamgrid
Some snippets of how we utilize Puppet in MLBAM which is codenamed bamgrid.

## Custom Facts in Bamgrid
The first and most important thing is our Puppet custom facts.  Our goal is to manage servers as fleets and not as individual hostnames.  Every server gets a layer of metadata applied.  The metadata below is listed from coarsest to finest.  This is planted with a single JSON hash and a custom fact parser.
 * **env:** Dev, QA, Production etc...
 * **facility:** Location designation and a number. Examples being am1 for amazon1, am2, etc...
 * **group:** Which team owns the server.  Useful for namespacing, permissioning and contact information for when there are issues.
 * **server_type:** The fleet the server belongs to.  Examples being mlbweb, pushweb, pushapp etc...

## Hiera Configuration
Directly utilizes our custom facts.  You can see an example [hiera.yaml](configuration_files/hiera.yaml) in our configuration files.

## Bamgrid Hiera YAML to Puppet Module Parser
This is the meat of what we do.  We have a module that reads our YAML in using hiera_array and combines the results across our metadata.  This essentially turns our hiera YAML's into a shopping cart of Puppet Modules, Classes and Defines.  It allows us to separate configuration from modules effortlessly.  A provided example [yaml_parser](modules/bamgrid/manifests/yaml_parser.pp) in the modules section of this repo.  Essentially, what this yaml parser is doing, is taking the identity of the server, looking up the install hash in the correct hierarchy of data, merging them into a single array and invoking the proper puppet code from that.  

## Bamgrid Hiera YAML Example
Under the configuration files [data](configuration_files/data) directory, you can see what a typical set of Hiera data files looks like for us.

 * [data/dev/am1/base.yaml](configuration_files/data/dev/am1/base.yaml): This yaml would affect all servers running in dev in our first AWS facility.  You can see we're pushing out awslogs and New Relic system monitoring to all of our instances
 * [data/dev/am1/mob/group.yaml](configuration_files/data/dev/am1/mob/group.yaml): This yaml manages all servers that belong to our mobile group.  Something simple like ensuring all versions of Java are standardized in the group or application users could go here.
 * [data/dev/am1/mob/pushweb.yaml](configuration_files/data/dev/am1/mob/pushweb.yaml): This is the meat of the application on the server.  You can see we expose several key parameters to the YAML so development teams are empowered to push out their own containers, manage settings and in general have more visibility into the details of their app.
 * [data/dev/am1/mob/pushapp.yaml](configuration_files/data/dev/am1/mob/pushapp.yaml): This is just to show that all server types that belong to the mobile group in dev am1 would live here.  Essentially, every change to your systems end up in Git.  You're also exposing a public interface to your Puppet modules and allowing developer teams to apply modules that you've written without ever exposing the modules themselves.  

## Future information
Configuration Phases, Workflows, MCollective, Code deployment workflows, hiera data lookups in modules.  There is a lot of other thought that has gone into this.  This is just the first part of our process.  If there's any interest in more information, we can certainly go into a few other things.  The main point of this workflow is the fact that our YAMLs become the source of truth.  Every single operation is either a puppet module change or a yaml change.  All change in the system is done the same way.  Pull down the latest YAML, puppet apply.
