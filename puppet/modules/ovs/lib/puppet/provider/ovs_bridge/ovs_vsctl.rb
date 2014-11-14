Puppet::Type.type(:ovs_bridge).provide(:ovs_vsctl) do

	commands :cmd => "ovs-vsctl"

	def create
		cmd "--", "--may-exist", "add-br", resource[:name]
	end

	def destroy
		cmd "--", "--if-exists", "del-br", resource[:name]
	end

	def exists?
		begin
			cmd "br-exists", resource[:name]
		rescue
			Puppet::ExecutionFailure
			false
		else
			true
		end
	end
end
