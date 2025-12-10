resource "azurerm_resource_group" "MynewinfraRG" { # Resource Group create karne ke liye resource block. Resource Group ek logical container hota hai jisme hum apne Azure resources ko organize karte hain.
  name     = var.infra_rg_name                     # yeh resource group ka name hai jo azure mein create hoga
  location = var.infra_rg_location                 # yeh is resource group ka region batata hai
}

resource "azurerm_storage_account" "Infrastorage_account" { # Storage Account create karne ke liye resource block. Storage Account ek logical container hota hai jisme hum blobs, files, queues, tables etc. store kar sakte hain.
  name                     = var.infra_storage_account      # storage account ka unique name jo globally unique hona chahiye
  resource_group_name      = azurerm_resource_group.MynewinfraRG.name
  location                 = azurerm_resource_group.MynewinfraRG.location
  account_tier             = var.account_tier    # storage account ka performance tier (Standard ya Premium). Standard cost-effective hota hai aur general purpose ke liye use hota hai, jabki Premium high-performance workloads ke liye use hota hai.
  account_replication_type = var.redundancy_type # replication type jo data redundancy provide karta hai. LRS (Locally Redundant Storage) data ko ek hi region mein replicate karta hai, GRS (Geo-Redundant Storage) data ko do alag regions mein replicate karta hai for disaster recovery.
}

resource "azurerm_virtual_network" "InfraVNet" { # Virtual Network create karne ke liye resource block. Virtual Network ek logical isolation hota hai jahan hum apne resources ko network provide karte hain.
  name                = var.infra_vnet_name
  resource_group_name = azurerm_resource_group.MynewinfraRG.name     # virtual network ko resource group se link karna zaroori hai, kyunki har resource ek resource group mein hi rehta hai.
  location            = azurerm_resource_group.MynewinfraRG.location # virtual network ka location bhi resource group ke location ke same hona chahiye.
  address_space       = var.infra_vnet_address_space

}


resource "azurerm_subnet" "Infrakasubnet" { # Subnet create karne ke liye resource block. Subnet virtual network ka ek logical segmented part hota hai jo IP address range ko divide karta hai.
  name                = var.infra_subnet_name
  resource_group_name = azurerm_resource_group.MynewinfraRG.name
  #location = azurerm_resource_group.MynewinfraRG.location 
  #location wala attribute yahan zaroori nahi hai, kyunki subnet ka virtual network ka ek logical part hota hai aur virtual network ka location already defined hai.
  virtual_network_name = azurerm_virtual_network.InfraVNet.name
  address_prefixes     = var.infra_subnet_address_prefixes
}

resource "azurerm_network_security_group" "Infranetkasecurityguard" { # Network Security Group (NSG) create karne ke liye resource block. NSG network traffic ko filter karne ke liye rules define karta hai.
  name                = var.infra_NSG_name
  location            = azurerm_resource_group.MynewinfraRG.location
  resource_group_name = azurerm_resource_group.MynewinfraRG.name

  security_rule {                                                               # NSG ke andar ek security rule karna zaroori hai, jo hume help karega traffic ko allow ya deny karne mein. Yahan traffic ka matlab hai ki kaunse data packets network ke andar ya bahar ja sakte hain.
    name                       = var.infra_security_rule_name                   # security rule ka name
    priority                   = var.infra_security_rule_priority               # priority define karti hai ki agar multiple rules hain to kaunse rule ko pehle evaluate karna hai. Lower number ka matlab higher priority hota hai.
    direction                  = var.infra_security_rule_direction              # direction define karti hai ki yeh rule inbound traffic ke liye hai ya outbound traffic ke liye.
    access                     = var.infra_security_rule_access                 # access define karta hai ki yeh rule traffic ko allow karega ya deny.
    protocol                   = var.infra_security_rule_protocol               # protocol define karta hai ki yeh rule kis protocol ke liye apply hoga, jaise TCP, UDP, ya Any.
    source_port_range          = var.infra_security_rule_source_port            # source port range define karti hai jahan se traffic aa raha hai.
    destination_port_range     = var.infra_security_rule_destination_port       # destination port range define karti hai jahan traffic ja raha hai.
    source_address_prefix      = var.infra_security_rule_source_IP_address      # source IP address prefix define karta hai jahan se traffic aa raha hai.
    destination_address_prefix = var.infra_security_rule_destination_IP_address # destination IP address prefix define karta hai jahan traffic ja raha hai.
  }
}

# Note: source port aur destination port range dono hi string type ke hote hain kyunki hume specific ports ya port ranges define karni hoti hain jaise "80", "443", "1000-2000" etc. isiliye unhe string ke roop mein treat kiya jata hai.
# Note: source address prefix aur source port range mein main difference yeh hai ki source address prefix IP addresses ko define karta hai jahan se traffic aa raha hai, jabki source port range un ports ko define karta hai jahan se traffic originate ho raha hai. Dono alag-alag cheezein hain aur dono ko alag-alag specify karna zaroori hota hai.
# Note: destination address prefix aur destination port range mein bhi yehhi difference hai. Destination address prefix IP addresses ko define karta hai jahan traffic ja raha hai, jabki destination port range un ports ko define karta hai jahan traffic land ho raha hai.
# protocol attribute mein "Any" specify karne ka matlab hai ki yeh rule sabhi protocols (TCP, UDP, ICMP etc.) ke liye apply hoga. Agar aap specific protocol jaise "TCP" ya "UDP" specify karte hain, to yeh rule sirf usi protocol ke traffic par lagu hoga.

resource "azurerm_network_interface" "InfraNIC" { # Network Interface Card (NIC) create karne ke liye resource block. Iska use virtual machines ko network se connect karne ke liye kiya jata hai.
  name                = var.infra_NIC_name        # NIC ka name
  location            = azurerm_resource_group.MynewinfraRG.location
  resource_group_name = azurerm_resource_group.MynewinfraRG.name
  #virtual_network_name = azurerm_virtual_network.InfraVNet.name
  # yahan vnet ka name specify karna zaroori nahi hai kyunki NIC directly vnet se nahi judi hoti, balki subnet se judi hoti hai.
  #subnet_name = azurerm_subnet.Infrakasubnet.name
  # yahan subnet ka name specify karna zaroori nahi hai kyunki NIC ko subnet ke through hi virtual network se connect kiya jata hai. By default NIC subnet ke saath hi connect karta hai jise hum neeche ip_configuration block mein define karenge.

  ip_configuration { # NIC ke liye IP configuration define karne ke liye block. Isme hum specify karte hain ki NIC kaunsa subnet use karega aur IP address allocation kaise hoga.
    name      = "internal"
    subnet_id = azurerm_subnet.Infrakasubnet.id # subnet ka ID yahan specify karna zaroori hai taaki NIC ko pata chale ki yeh kis subnet se judi hai.
    #Yahan par subnet ID matlab hum subnet ka unique identifier de rahe hain jo humne pehle create kiya tha. Isse NIC ko pata chalega ki yeh kis subnet ke andar operate karega.
    private_ip_address_allocation = "Dynamic"                     # yeh specify karta hai ki NIC ko private IP address dynamically allocate kiya jayega ya statically. Dynamic ka matlab hai ki Azure automatically ek available IP address allocate karega jab NIC create hoga.
    public_ip_address_id          = azurerm_public_ip.InfraPIP.id # yeh specify karta hai ki NIC ke saath ek public IP address bhi associate karna hai. Isse NIC internet se accessible ho jayega.

  }
}

resource "azurerm_network_interface" "InfraNIC_Backend" {
  name                = var.infra_backend_NIC_name
  location            = azurerm_resource_group.MynewinfraRG.location
  resource_group_name = azurerm_resource_group.MynewinfraRG.name

  ip_configuration {
    name                          = "backendkaconnection"
    subnet_id                     = azurerm_subnet.Infrakasubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.InfraPIP_Backend.id
  }
}

resource "azurerm_network_interface_security_group_association" "InfraNICNSGAssociation" {
  network_interface_id      = azurerm_network_interface.InfraNIC.id                     # yeh NIC ka ID hai jise hum NSG se associate karna chahte hain. Reason yeh hai ki hum chahte hai ki NSG ke rules NIC ko traffic filter karne mein help karein.
  network_security_group_id = azurerm_network_security_group.Infranetkasecurityguard.id # yeh NSG ka ID hai jise hum NIC se associate karna chahte hain. Reason yeh hai ki hum chahte hain ki yeh NIC us NSG ke rules ko follow kare jo humne define kiya hai.

}

resource "azurerm_public_ip" "InfraPIP" {  # Public IP address create karne ke liye resource block. Public IP address ka use internet se resources ko access karne ke liye kiya jata hai.
  name                = var.infra_PIP_name # Public IP address ka name
  location            = azurerm_resource_group.MynewinfraRG.location
  resource_group_name = azurerm_resource_group.MynewinfraRG.name
  allocation_method   = "Static" # yeh specify karta hai ki public IP address static hoga ya dynamic. 
  #Reason static IP address choose karne ka yeh hai ki hume chahiye ki humara resource hamesha same IP address par accessible rahe, jo ki important hota hai jab hum kisi service ko internet par host kar rahe hote hain.
}
# Note: Agar hum "Dynamic" choose karte hain to IP address time ke saath change ho sakta hai, jo ki kuch scenarios mein problematic ho sakta hai, jaise ki jab hum kisi service ko internet par host kar rahe hote hain aur hume chahiye ki wo hamesha same IP address par accessible rahe.
# Note: Static IP address choose karne ka yeh bhi fayda hai ki hum apne DNS records ko easily manage kar sakte hain, kyunki hume pata hota hai ki humara resource kis IP address par accessible hoga.

resource "azurerm_public_ip" "InfraPIP_Backend" {
  name                = var.infra_PIP_backend_name
  location            = azurerm_resource_group.MynewinfraRG.location
  resource_group_name = azurerm_resource_group.MynewinfraRG.name
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "Infra_VM" { # Virtual Machine create karne ke liye resource block. Virtual Machine ek compute resource hota hai jahan hum apne applications aur services ko run karte hain.
  name                             = var.infra_vm_name
  location                         = azurerm_resource_group.MynewinfraRG.location
  resource_group_name              = azurerm_resource_group.MynewinfraRG.name
  network_interface_ids            = [azurerm_network_interface.InfraNIC.id]
  vm_size                          = "Standard_B1s"
  delete_os_disk_on_termination    = true # Yeh ensure karta hai ki jab virtual machine delete ki jaye, to uska associated OS disk bhi automatically delete ho jaye. Isse unnecessary storage costs bachti hain aur resource cleanup mein madad milti hai.
  delete_data_disks_on_termination = true # Yeh ensure karta hai ki jab virtual machine delete ki jaye, to uske associated data disks bhi automatically delete ho jayein.

  storage_image_reference { # Virtual machine ke liye OS image specify karne ke liye block. Yahan hum Ubuntu Server 22.04 LTS image use kar rahe hain.
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }

  storage_os_disk { # OS disk ke liye storage configuration define karne ke liye block.
    name              = "infraosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile { # Virtual machine ke liye OS profile define karne ke liye block. Isme hum specify karte hain ki virtual machine ka computer name kya hoga aur admin credentials kya honge.
    computer_name  = "infravm"
    admin_username = var.infra_vm_admin_username
    admin_password = var.infra_vm_admin_password
  }

  boot_diagnostics { # Virtual machine ke boot diagnostics configuration define karne ke liye block. Isme hum specify karte hain ki boot diagnostics enable karna hai ya nahi aur uske liye storage URI kya hoga.
    enabled     = true
    storage_uri = azurerm_storage_account.Infrastorage_account.primary_blob_endpoint
  }

}

resource "azurerm_virtual_machine" "Infra_VM_Backend" {
  name                = var.infra_backend_vm_name
  location            = azurerm_resource_group.MynewinfraRG.location
  resource_group_name = azurerm_resource_group.MynewinfraRG.name
  network_interface_ids = [azurerm_network_interface.InfraNIC_Backend.id]
  vm_size              = "Standard_B1s"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "infrabackendosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "infrabackendvm"
    admin_username = var.infra_vm_backend_admin_username
    admin_password = var.infra_vm_backend_admin_password
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.Infrastorage_account.primary_blob_endpoint
  }

}


