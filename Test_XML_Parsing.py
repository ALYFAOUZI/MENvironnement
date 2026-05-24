# Test XML Parsing:
#1039701_PR-2_2016_07_08.xle
import xml.etree.ElementTree as ET
#from bs4 import BeautifulSoup
# Parse the XML file
tree = ET.parse('1039701_PR-2_2016_07_08.xle')
# Get the root element
root = tree.getroot()
# Iterate through each child of the root element
for child in root:
    # Print the tag and attributes of each child element
    print(child.tag, child.attrib)

xtree = ET.parse("1039701_PR-2_2016_07_08.xle")
xroot = xtree.getroot()

for hnode in xroot.findall('File_info'):
    Date = hnode.find("Date").text
    print('Production date is ' +Date)
    Time = hnode.find("Time").text
    print('Production Time is ' +Time)

for hnode in xroot.findall('Instrument_info'):
    Serial_number = hnode.find("Serial_number").text
    print('Instrument Serial Number is ' +Serial_number)

for hnode in xroot.findall('Ch1_data_header'):
    Identification = hnode.find("Identification").text
    print('Identification is ' +Identification)
    Unit = hnode.find("Unit").text
    print('Unit is ' +Unit)

for hnode in xroot.findall('Ch2_data_header'):
    Identification = hnode.find("Identification").text
    print('Identification is ' +Identification)
    Unit = hnode.find("Unit").text
    print('Unit is ' +Unit)


for node in xroot.findall('Data'):
    for snode in node.findall('Log'):
         Date = snode.find("Date").text
         Time = snode.find("Time").text
         ms = snode.find("ms").text
         ch1 = snode.find("ch1").text
         ch2 = snode.find("ch2").text
         print(Date + '  ' + Time + '  ' + ms + '  ' + ch1 + '  ' + ch2)
         break
    break