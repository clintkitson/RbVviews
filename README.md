RbVviews
========
This is a Ruby class that leverages (RbVmomi) to issue lookups based on settings per VC object and return detailed views that contain methods and variables.  For example, you can look up the instanceUuid of a Virtual Machine and the class returns the VM object.

The behavior is modeled from Get-View from PowerCLI.

Install
=======
gem install RbVviews

Requirements
============
Ruby 1.8.7+<br>
Hiera (included with Puppet 3)<Br>
Ensure Hiera is working with static yaml/json files for Node Classification first<br>
VM has "puppet.classes" custom value of a class name that is valid<br>

Configure
=========
1) Edit /etc/puppet/hiera.yaml and replace server, username (can be read-only account), and password for vCenter<Br>
2) Edit /etc/puppet/manifests/site.pp and add following line<Br>
hiera_include('classes')<br>

Run
===
Run Puppet Master interactively and watch the Node checkin and Hiera vCenter lookup "puppet master --no-daemonize --debug"
