Puppet::Type.newtype(:ovs_port) do

	@doc = "An OpenVSwitch Port."

	ensurable do
		defaultvalues
		defaultto :present
	end

	newparam(:name, :namevar => true)
	newparam(:bridge)

	autorequire(:ovs_bridge) do
		[value(:bridge)]
	end
end
