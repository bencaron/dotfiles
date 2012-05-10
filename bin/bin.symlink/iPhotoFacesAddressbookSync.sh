#!/bin/bash

echo "=================================================================================================================="
echo "This tool matches names from Address Book to names that are tagged in iPhoto 09 Faces feature and copies the email"
echo "address to iPhoto"
echo ""
echo "For this tool to work faces must have aleady been created in iphoto Names must match address book in format"
echo "'Firstname Lastname'. If a name has a hyphen or apostrophie it will be ignored and the name will match."
echo "Only Faces in iPhoto which do not have Email Addresses will be updated"
echo ""
echo "This tool only works on iPhoto Libraries stored in the default location( ~/Photos/iPhoto Library )"
echo ""
echo "This tool is provided with no warranties or gurantees and operates by modifying iPhotos internal database in what"
echo "is probably an unsupported way. Use it your own risk."
echo ""
echo "Always, ALWAYS, backup your library before using this tool."
echo "=================================================================================================================="
echo ""

echo -n "Do you want to continue? (y/n):"
read confirm
if [ $confirm != "y" ] ; then
    echo "Exiting. No Changes were made"
    exit;
fi

echo -n "Is iPhoto Closed? (y/n):"
read confirm
if [ $confirm != "y" ] ; then
    echo "Exiting. Changes cannot be made while iPhoto is running"
    exit;
fi

echo ""
echo "Backing up the Face database file in your iPhoto Library..."
cp ~/Pictures/iPhoto\ Library/face.db ~/Pictures/iPhoto\ Library/face.db.bak
echo "~/Pictures/iPhoto\ Library/face.db.bak created"

echo ""
echo -n "Do you want to see a list of Names from your iPhoto Library before sync is done? (y/n):"
read confirm
if [ $confirm == "y" ] ; then
sqlite3 ~/Pictures/iPhoto\ Library/face.db <<EOF
.headers on
.mode column
.width 25 25 60
select name as 'iPhoto Cork Board Name', full_name as 'Full Name', email as 'Email' from face_name where name is not null;
EOF
echo "-------------------------  -------------------------  ------------------------------------------------------------"
echo -n "Do you still want to continue? (y/n):"
read confirm
if [ $confirm != "y" ] ; then
    echo "Exiting. No Changes were made"
    exit;
fi
echo ""
fi


echo "Looking for email addresses in Address book..."
sqlite3 ~/Library/Application\ Support/AddressBook/AddressBook-v22.abcddb <<EOF
.output iPhotoFacesAddressbooksyncGenerated.sql

select 'update face_name set full_name=' || quote( zfirstname || ' ' || zlastname) || ', email=' ||quote( zaddressnormalized) || ' where upper(replace(replace(replace(name,'''''''',''''),''-'', ''''),'' '',''''))=' ||  quote(replace(replace(replace(upper( zfirstname || zlastname),'''',''),'-',''), ' ', '')) || ' and email is null;' AS SQL from  zabcdrecord inner join zabcdemailaddress on zabcdrecord.z_pk= zabcdemailaddress.zowner where zisprimary=1 and zfirstname is not null and zlastname is not null ;

EOF
echo "List of Names and Emails generated."

echo ""
echo "Applying updates to the iPhoto Faces database..."

sqlite3 ~/Pictures/iPhoto\ Library/face.db <<EOF
.read iPhotoFacesAddressbooksyncGenerated.sql
EOF

echo "Updates Applied to iPhoto."

rm iPhotoFacesAddressbooksyncGenerated.sql

echo ""
echo -n "Do you want to see a list of Names from your iPhoto Library now that sync is done? (y/n):"
read confirm
if [ $confirm == "y" ] ; then
sqlite3 ~/Pictures/iPhoto\ Library/face.db <<EOF
.headers on
.mode column
.width 25 25 60
select name as 'iPhoto Cork Board Name', full_name as 'Full Name', email as 'Email' from face_name where name is not null;
EOF
echo "-------------------------  -------------------------  ------------------------------------------------------------"
echo ""
fi

echo "You can now open iPhoto. Script Complete"

