Puppet::Type.type(:ovs_port).provide(:ovs_vsctl) do

	commands :cmd => "ovs-vsctl"

	def create
		cmd "--", "--may-exist", "add-port", resource[:bridge], resource[:name]
	end

	def destroy
		cmd "--", "--if-exists", "del-port", resource[:brige], resource[:name]
	end

	def exists?
		out = cmd "list-ifaces", resource[:bridge]
		out.split("\s").include? resource[:name]
	end
end
