variable "subscription_current" {
  description = "Yeh wo subcription jisme hum resource create and deploy karenge."
  type        = string #kyunki subscription if ko string ki tarah treat kiya jata hai
}

variable "infra_rg_name" {
  description = "Yeh wo resource group ka name hai jo hum azure mein create karenge."
  type        = string # kyunki resource group ka name ek string mein diya jata hai
}

variable "infra_rg_location" {
  description = "Yeh wo location hai jahan humara resource group create hoga."
  type        = string # kyunki location bhi ek string hoti hai jaise 'East US', 'West Europe' etc.
}

variable "infra_vnet_name" {
  description = "Yeh wo virtual network ka name hai jo yeh resources ko network provide karega."
  type        = string # kyunki virtual network ka name bhi ek string hota hai
}

variable "infra_vnet_address_space" {
  description = "Yeh wo IPv4 address space hai jo virtual network ke liye allocate kiya jayega."
  type        = list(string) # kyunki Ip address ek list mein hote hain, koi bhi ek use ya allocate kar sakte hai. isiliye list of string use kiya gaya hai.
}

variable "infra_subnet_name" {
  description = "Yeh wo subnet ka name hai jo virtual network ke andar create hoga."
  type        = string # kyunki subnet ka name bhi ek string hota hai
}

variable "infra_subnet_address_prefixes" {
  description = "Yeh wo IPv4 address prefixes hain jo subnet ke andar create hone wale resources ke liye allocate kiye jayenge."
  type        = list(string) # kyunki subnet me bhi multiple Ip address hote hai jinko par usage ke liye allocate karna hota hai, isiliye list of string use kiya gaya hai.
}

variable "infra_NSG_name" {
  description = "Yeh wo network security group ka name hai jo hum create karenge."
  type        = string # kyunki NSG ka name bhi ek string hota hai
}

variable "infra_security_rule_name" {
  description = "Yeh wo security rule ka name hai jo NSG mein define kiya jayega."
  type        = string # kyunki security rule ka name bhi ek string hota hai
}
variable "infra_security_rule_priority" {
  description = "Yeh wo priority hai jo security rule ko assign ki jayegi."
  type        = number # kyunki priority ek numeric value hoti hai
}
variable "infra_security_rule_direction" {
  description = "Yeh wo direction hai jo security rule ke liye define ki jayegi (Inbound ya Outbound)."
  type        = string # kyunki direction ek string hoti hai
}
variable "infra_security_rule_access" {
  description = "Yeh wo access type hai jo security rule ke liye define ki jayegi (Allow ya Deny)."
  type        = string # kyunki access type bhi ek string hoti hai
}
variable "infra_security_rule_protocol" {
  description = "Yeh wo protocol hai jo security rule ke liye define kiya jayega (TCP, UDP, ya Any)."
  type        = string # kyunki protocol bhi ek string hota hai
}
variable "infra_security_rule_source_port" {
  description = "Yeh wo source port range hai jo security rule ke liye define ki jayegi."
  type        = string # kyunki port range ek string hoti hai
}
variable "infra_security_rule_destination_port" {
  description = "Yeh wo destination port range hai jo security rule ke liye define ki jayegi."
  type        = string # kyunki port range ek string hoti hai
}
variable "infra_security_rule_source_IP_address" {
  description = "Yeh wo source IP address prefix hai jo security rule ke liye define kiya jayega."
  type        = string # kyunki IP address prefix bhi ek string hota hai
}
variable "infra_security_rule_destination_IP_address" {
  description = "Yeh wo destination IP address prefix hai jo security rule ke liye define kiya jayega."
  type        = string # kyunki IP address prefix bhi ek string hota hai
}

variable "infra_NIC_name" {
  description = "Yeh wo network interface card (NIC) ka name hai jo hum create karenge."
  type        = string # kyunki NIC ka name bhi ek string hota hai
}

variable "infra_PIP_name" {
  description = "Yeh wo public IP address ka name hai jo hum ek resource ke liye create karenge."
  type        = string # kyunki public IP address ka name bhi ek string hota hai
}

variable "infra_storage_account" {
  description = "Yeh wo storage account ka name hai jo hum create karenge."
  type        = string # kyunki storage account ka name bhi ek string hota hai
}

variable "account_tier" {
  description = "Yeh wo account type jo performance tier define karta hai. Isme do tarah ke options hote hain: Standard aur Premium."
  type        = string # kyunki account tier mein hum string values use karte hain jaise "Standard" ya "Premium"
}
variable "redundancy_type" {
  description = "Yeh wo replication or backup strategy hai jo data redundancy provide karta hai. Isme 4 tarah ke options hote hain: LRS (Locally Redundant Storage), GRS (Geo-Redundant Storage), ZRS (Zone-Redundant Storage), aur GZRS (Geo Zone Redundant Storage)."
  type        = string # kyunki redundancy type mein hum string values use karte hain jaise "LRS", "GRS", "ZRS", ya "GZRS"
}

variable "infra_vm_name" {
  description = "Yeh hai virtual machine ka naam jo hum create karenge."
  type        = string # kyunki virtual machine ka naam bhi ek string hota hai
}

variable "infra_vm_admin_username" {
  description = "Yeh hai virtual machine ka administrator username."
  type        = string # kyunki username bhi ek string hota hai
}

variable "infra_vm_admin_password" {
  description = "Yeh hai virtual machine ka administrator password."
  type        = string # kyunki password bhi ek string hota hai
  sensitive   = true   # taaki yeh value terraform output mein na dikhe
}
