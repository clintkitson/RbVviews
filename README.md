RbVviews
========
This is a Ruby class that leverages (RbVmomi) to issue lookups based on settings per VC object and return detailed views that contain methods and variables.  For example, you can look up the instanceUuid of a Virtual Machine and the class returns the VM object.

The behavior is modeled from Get-View from PowerCLI.

<a href="http://velemental.com/2013/07/10/project-steel-integrating-virtual-machines-guests-with-puppet/">vElemental Blog Post</a>

Install
=======
gem install RbVviews

Requirements
============
Ruby 1.8.7+<br>
RbVmomi<br>

Ruby Example
============
require 'RbVviews'<br>
<Br>
vc_view = RbVviews.new("vcenter01.brswh.local","root","vmware")<br>
vc_view.connect<br>
vm = vc_view.get_view('VirtualMachine','config.instanceUuid','5038de0a-a3cf-8779-3c4c-d481b54876a9')<br>
puts vm[0].obj.name<br>

PowerCLI Equivalent Example
===========================
Connect-VIServer -server vcenter01.brswh.local -username root -password vmware<br>
$vm = Get-View -ViewType VirtualMachine -Filter @{"config.instanceuuid"="5038de0a-a3cf-8779-3c4c-d481b54876a9"}<br>
Write-Host $vm.name<br>
