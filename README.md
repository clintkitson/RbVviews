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
