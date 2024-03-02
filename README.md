Shell scripts useful for KiCAD users
===============

datasheets.csv
--------------
Spreadsheet file containing manufacturer names, part numbers, and datasheet links.

checkDatasheets.sh
------------------
Reads datasheet links from datasheets.csv and checks availability by downloading them. Keep this script in the same directory as datasheets.csv.

usage: checkDatasheets.sh

libRemoveVirtuals.sh
--------------------
Searches all .kicad_mod files in the current directory and removes "virtual attribute" from them. Please don't run this script if you want to keep the "virtual attribute" of the components.
  
usage: libRemoveVirtuals.sh

pcbFontSize.sh
--------------
Sets footprints reference and value text dimensions to width: 25 mils, height: 25 mils, and thickness: 5 mils.

usage: pcbFontSize.sh filename.kicad_pcb

replaceInFileName.sh
--------------------
Replaces all or part of filenames in the directory. Useful to rename all project files at once.

usage: replaceInFileName.sh old_project_name new_project_name

schAddDatasheet2Comp.sh
-----------------------
Reads datasheet links from datasheets.csv and fills datasheet fields of the components in all .sch files in the directory. Keep this script in the same directory as datasheets.csv.

usage: schAddDatasheet2Comp.sh

schAddLib2Comp.sh
-----------------
Adds library name in front of the "library reference" field of components in all .sch files in the directory. If the previous library reference is "resistor" it becomes "library_name:resistor".

usage: schAddLib2Comp.sh library_name

schCost.sh
----------
A wrapper to call kicost utility.

usage: schCost.sh

schFieldSize.sh
---------------
Sets reference and value fields size to 40, visibility to yes. Sets other fields to invisible with the size of 35. And edits a little bit more to align schematic symbols.

usage: schFieldSize.sh

schReplaceStr.sh
----------------
Replaces strings inside all .sch files in the directory. Useful to replace a particular component's part number in a project.

usage: schReplaceStr.sh old_sgtring new_string

svg2pdf.sh
----------
A wrapper for Inkscape to convert all .svg files to .pdf files in the directory. Useful to convert PCBNew's SVG outputs.

usage: svg2pdf.sh

stlMeter2mm.sh
--------------
Converts dimensions from meter to millimeter by multiplying them with 1000 in all .stl files in the directory. Useful for converting openEMS exported .stl files to use with FreeCAD.

usage: stlMeter2mm.sh

csvRemoveDNP.sh
--------------
Removes the lines containing the "DNP" word in all .csv files in the directory. Useful for preparing position files for manufacturing.

usage: csvRemoveDNP.sh
