# This script is intended to be executed from within the Imaging Task Sequence.
# It will be placed as a "Pre-Flight Check" in the UDI Wizard of the Task Sequence.
# This script checks to see if the System Model is a known and supported type.
# If the Model is not listed below, it is considered UNKNOWN and not supported for deployment.
# If the Model is not listed below, The "Pre-Flight Check" will Fail and the Imaging Sequence will fail.
# 
# Created by Luke Balzrina 20160628

<#
exit codes:
11 - Dell
12 - Microsoft
13 - Lenovo
14 - VMware
15 - HyperV
#>

$LogFile = "X:\Windows\TEMP\SMSTSLog\Check-KnownHardware.log"

# Create a basic function for outputting information to a log
Function LogWrite
{
    Param ([string]$logstring)
    Add-Content $LogFile -value $logstring
}

# Timestamp & Title current log directory
$Date = (Get-Date).ToString()
LogWrite $Date
LogWrite ""

LogWrite "This Log documents the WMI values for Manufacturer, Model, and System Family (Description)"
LogWrite "An exit code of 11-15 is a success. An Exit Code of 1 is a Failure"
LogWrite ""

$model = Get-WmiObject -Class Win32_ComputerSystem | ForEach-Object {$_.Model}
$systemfamily = Get-WmiObject -Class Win32_ComputerSystem | ForEach-Object {$_.SystemFamily}
$manufacturer = Get-WmiObject -Class Win32_ComputerSystem | ForEach-Object {$_.Manufacturer}
    
LogWrite "System Manufacturer is $manufacturer. System Model is: $model. System Family is $systemfamily."
LogWrite ""

If($model -eq "Latitude E7450" -or "Latitude E7470" -or "Latitude E7270" -or "Optiplex 7040" -or "Latitude E5470" -or "E7240" -or "E7440" -or "E7250" -or "E7450" -or "Surface Pro 3" -or "Surface Pro 4" -or "Surface Book" -or "20BS009YUS" -or "20FRS0XC00" -or "VMware Virtual Machine" -or "Virtual Machine"){
    LogWrite "This model is supported and Imaging will proceed."
    } 
    ELSE {
    LogWrite "This model is not supported. Imaging will NOT proceed."
    }

switch ($model) {
    
    ### Dell Models ###
    "E7240" {exit 11}
    "E7440" {exit 11}
    "E7250" {exit 11}
    "E7450" {exit 11}
    "Latitude E5470" {exit 11}
    "Optiplex 7040" {exit 11}
    "Latitude E7270" {exit 11}
    "Latitude E7470" {exit 11}
    "Latitude E7450" {exit 11}
    ### Microsoft Models ###
    "Surface Pro 3" {exit 12}
    "Surface Pro 4" {exit 12}
    "Surface Book" {exit 12}
    ### Lenovo Models ###
    "20BS009YUS" {exit 13}
    "20FRS0XC00" {exit 13}
    ### VMware Models ###
    "VMware Virtual Platform" {exit 14}
    ### Hyper-V Models ###
    "Virtual Machine" {exit 15}
    ### Default Out ###
    default {exit 1}
    }


