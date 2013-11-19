# -*- coding: utf-8 -*-
Veewee::Session.declare({
    :os_type_id => 'Windows2008_64',
    # http://technet.microsoft.com/en-us/evalcenter/dd459137.aspx
    # Download and install full featured software for 180-day trial
    :iso_file => "7601.17514.101119-1850_x64fre_server_eval_en-us-GRMSXEVAL_EN_DVD.iso",
    :iso_md5 => "4263be2cf3c59177c45085c0a7bc6ca5",
    :iso_src => "http://care.dlservice.microsoft.com//dl/download/7/5/E/75EC4E54-5B02-42D6-8879-D8D3A25FBEF7/7601.17514.101119-1850_x64fre_server_eval_en-us-GRMSXEVAL_EN_DVD.iso",
    :iso_download_timeout => "1000",
    :cpu_count => '2',
    :memory_size=> '2048', 
    :disk_size => '20480', :disk_format => 'VDI', :hostiocache => 'off',

    :floppy_files => [
      "Autounattend.xml", # automate install and setup winrm
      "install-winrm.bat",
      "extend-disk.txt",
      "sysprep.xml",
      "install-updates-and-sysprep.vbs",
      "secpol.inf",
      "begin-update-and-sysprep.cmd",                     
      "oracle-cert.cer"],

    :boot_wait => "35",
#    :boot_wait => "1",
    # after 35 seconds, hit these keys to not enter a product key and fully automate the install
    # if your machine is slower it may take more time
     :boot_cmd_sequence => [ 
     '<Tab><Tab><Tab><Enter>',
     '<Enter>'
     ],
    :boot_cmd_sequence => [''],

    # Actively attempt to winrm (no ssh on base windows) in for 10000 seconds
    # :ssh_user => "vagrant", :ssh_password => "vagrant", :ssh_key => "", 
    # :ssh_host_port => "59856", :ssh_guest_port => "5985",
    :winrm_user => "Administrator", :winrm_password => "vagrant",


    # And run postinstall.sh for up to 60 seconds
    :postinstall_timeout => "60",
    :postinstall_files => ["postinstall.cmd"],
    # No sudo on windows
    :sudo_cmd => "%f",
    # Shutdown is different as well
    :shutdown_cmd => "shutdown /s /t 60 /d p:4:1 /c \"Vagrant Shutdown\"",
})


