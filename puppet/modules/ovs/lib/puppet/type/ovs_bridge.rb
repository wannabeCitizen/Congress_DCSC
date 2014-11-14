Puppet::Type.newtype(:ovs_bridge) do

	@doc = "An OpenVSwitch Bridge."

	ensurable do
		defaultvalues
		defaultto :present
	end

	newparam(:name, :namevar => true)

	autorequire(:service) do
		["openvswitch"]
	end
end
