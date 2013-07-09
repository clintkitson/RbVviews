require 'rbvmomi'

class RbVviews
  def initialize (host,user,password)
    @host, @user, @password = host, user, password        
  end

  def connect
    @vim = RbVmomi::VIM.connect host: @host, user: @user, password: @password, insecure: true
    @vim.instance_variable_set(:@serviceContent,@vim.serviceInstance.RetrieveServiceContent)
    vcenter_current_time = @vim.serviceInstance.CurrentTime()
    puts "vCenter server time is currently #{vcenter_current_time}"
    puts "Connected to vCenter at #{@host}"
  end

  def close
    @vim.serviceContent.sessionManager.Logout rescue RbVmomi::Fault
    puts "Disconnected from vCenter at #{@host}"
  end 

  def get_view (type,field,value)
  propSet = [
    { :type => type, :pathSet => ['name',field], :all => false  }
  ]

  filterSpec = RbVmomi::VIM.PropertyFilterSpec(
    :objectSet => [
      :obj => @vim.rootFolder,
      :skip => false,
      :selectSet => [
        RbVmomi::VIM.TraversalSpec(
          :name => 'folderTraversalSpec',
          :type => 'Folder',
          :path => 'childEntity',
          :skip => false,
          :selectSet => [
            RbVmomi::VIM.SelectionSpec(:name => 'folderTraversalSpec'),
            RbVmomi::VIM.SelectionSpec(:name => 'datacenterVmTraversalSpec'),
            RbVmomi::VIM.SelectionSpec(:name => 'datacenterHostTraversalSpec'),
            RbVmomi::VIM.SelectionSpec(:name => 'computeResourceHostTraversalSpec'),
            RbVmomi::VIM.SelectionSpec(:name => 'computeResourceRpTraversalSpec'),
            RbVmomi::VIM.SelectionSpec(:name => 'resourcePoolTraversalSpec'),
            RbVmomi::VIM.SelectionSpec(:name => 'hostVmTraversalSpec'),
            RbVmomi::VIM.SelectionSpec(:name => 'resourcePoolVmTraversalSpec'),
            RbVmomi::VIM.SelectionSpec(:name => 'datacenterDatastoreTraversalSpec'),
            RbVmomi::VIM.SelectionSpec(:name => 'datacenterNetworkTraversalSpec')
          ]
        ),
        RbVmomi::VIM.TraversalSpec(
          :name => 'datacenterVmTraversalSpec',
          :type => 'Datacenter',
          :path => 'vmFolder',
          :skip => false,
          :selectSet => [ RbVmomi::VIM.SelectionSpec(:name => 'folderTraversalSpec') ]
       ),
       RbVmomi::VIM.TraversalSpec(
          :name => 'datacenterHostTraversalSpec',
          :type => 'Datacenter',
          :path => 'hostFolder',
          :skip => false,
          :selectSet => [ RbVmomi::VIM.SelectionSpec(:name => 'folderTraversalSpec') ]
       ),
       RbVmomi::VIM.TraversalSpec(
          :name => 'computeResourceHostTraversalSpec',
          :type => 'ComputeResource',
          :path => 'host',
          :skip => false
       ),
       RbVmomi::VIM.TraversalSpec(
          :name => 'computeResourceRpTraversalSpec',
          :type => 'ComputeResource',
          :path => 'resourcePool',
          :skip => false,
          :selectSet => [ 
          	RbVmomi::VIM.SelectionSpec(:name => 'resourcePoolTraversalSpec'),
          	RbVmomi::VIM.SelectionSpec(:name => 'resourcePoolVmTraversalSpec')
          ]
       ),
       RbVmomi::VIM.TraversalSpec(
          :name => 'resourcePoolTraversalSpec',
          :type => 'ResourcePool',
          :path => 'resourcePool',
          :skip => false,
          :selectSet => [ 
          	RbVmomi::VIM.SelectionSpec(:name => 'resourcePoolTraversalSpec'),
          	RbVmomi::VIM.SelectionSpec(:name => 'resourcePoolVmTraversalSpec')
          ]
       ),
       RbVmomi::VIM.TraversalSpec(
          :name => 'hostVmTraversalSpec',
          :type => 'HostSystem',
          :path => 'vm',
          :skip => false,
          :selectSet => [ RbVmomi::VIM.SelectionSpec(:name => 'folderTraversalSpec') ]
       ),
       RbVmomi::VIM.TraversalSpec(
          :name => 'resourcePoolVmTraversalSpec',
          :type => 'ResourcePool',
          :path => 'vm',
          :skip => false,
       ),
       RbVmomi::VIM.TraversalSpec(
          :name => 'datacenterDatastoreTraversalSpec',
          :type => 'Datacenter',
          :path => 'datastoreFolder',
          :skip => false,
          :selectSet => [ RbVmomi::VIM.SelectionSpec(:name => 'folderTraversalSpec') ]
       ),
       RbVmomi::VIM.TraversalSpec(
          :name => 'datacenterNetworkTraversalSpec',
          :type => 'Datacenter',
          :path => 'networkFolder',
          :skip => false,
          :selectSet => [ RbVmomi::VIM.SelectionSpec(:name => 'folderTraversalSpec') ]
       ) 
      ]
    ],
    :propSet => propSet
  )

  results = @vim.propertyCollector.RetrieveProperties(:specSet => [filterSpec])

  result = results.select {|x| x.obj[field] == value || value == nil || value == ''}
  return result
  end
end

