actions :add, :remove

default_action :add

attribute :name,                  kind_of: String,
                                  name_attribute: true,
                                  required: false
attribute :groupid,               kind_of: String,
                                  callbacks: { 'is not a valid group ID' =>
                                               ->(n) { valid_group_id?(n) } }
attribute :groupname,             kind_of: String,
                                  callbacks: { 'is not a valid group name' =>
                                               ->(n) { valid_group?(n) } }
attribute :description,           kind_of: String
attribute :cidr_ip,               kind_of: String,
                                  callbacks: { 'is not a valid IP' =>
                                               ->(ip) { valid_ip?(ip) } }
attribute :group,                 kind_of: String,
                                  callbacks: { 'is not a valid group name/ID' =>
                                               ->(n) { valid_group?(n) } }
attribute :source_group_id,       kind_of: String,
                                  regex: [/^sg-[a-zA-Z0-9]{8}$/]
attribute :source_group_name,     kind_of: String
attribute :owner,                 kind_of: String
attribute :ip_protocol,           kind_of: String,
                                  default: 'tcp',
                                  equal_to: %w(-1 tcp udp icmp)
attribute :port_range,            kind_of: String
attribute :region,                kind_of: String,  default: 'us-east-1'
attribute :from_port,             kind_of: Integer, default: 0
attribute :to_port,               kind_of: Integer, default: 65_535
attribute :mocking,               kind_of: [TrueClass, FalseClass],
                                  default: false

def self.valid_ip?(ip)
  require 'ipaddress'
  true if IPAddress.parse ip
rescue ArgumentError => e
  raise e unless e.message =~ /Invalid IP/
  false
end

def self.valid_group?(group)
  return true if group =~ /^[ \w-]+$/
  false
end

def self.valid_group_id?(group_id)
  return true if group_id =~ /^sg-[a-zA-Z0-9]{17}$/
end

attr_accessor :exists
