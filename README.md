RbVviews
========
This is a Ruby class that leverages (RbVmomi) to issue lookups based on settings per VC object and return detailed views that contain methods and variables.  For example, you can look up the instanceUuid of a Virtual Machine and the class returns the VM object.

The behavior is modeled from Get-View from PowerCLI.

Install
=======
gem install RbVviews

Requirements
============
Ruby 1.8.7+
Hiera (included with Puppet 3)
Ensure Hiera is working with static yaml/json files for Node Classification first
VM has "puppet.classes" custom value of a class name that is valid

Configure
=========
1) Edit /etc/puppet/hiera.yaml and replace server, username (can be read-only account), and password for vCenter

---
:backends:
   - vcenter
:hierarchy:
   - "%{vminstanceuuid}"
:vcenter:
   :server: vcenter01.brswh.local
   :username: root
   :password: vmware
   :key: "%{vminstanceuuid}"
2) Edit /etc/puppet/manifests/site.pp and add following line
hiera_include('classes')

Run
===
Run Puppet Master interactively and watch the Node checkin and Hiera vCenter lookup "puppet master --no-daemonize --debug"
