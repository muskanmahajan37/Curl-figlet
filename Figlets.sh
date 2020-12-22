echo 

# Shows NeosAlpha Technologies

npm i figlet  &>/dev/null  #<--

echo "var figlet = require('figlet');
 
figlet('NeosAlpha Technologies', function(err, data) {
    if (err) {
        console.log('Something went wrong...');
        console.dir(err);
        return;
    }
    console.log(data)
});
" > test.js

node test.js

echo
echo
echo

sleep 3
Yellow='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${Yellow}Please note that the following entities won't be migrated as part of this tool.\nIn most cases, you'll need to migrate these manually using the Apigee Edge \nconsole.For more on migrating these, see the Apigee documentation on org data \nmigration."
echo -e "1. Cache resources and cached values.
2. Environment resources such as target servers, virtualhosts, and keystores.
3. KVM entries for encrypted key-value maps. Encrypted values can't be retrieved   using the management API. Make a note of the values you're using in your old    org, then add these values manually to the new org.
4. Organization or environment level resources such as .jar files, .js files \n   and so on.${NC}"

echo
echo
sleep 3


npm install -g grunt-cli
git clone https://github.com/rkdhacker/apigee-migrate-tool.git



cd ./apigee-migrate-tool/
npm install
npm install grunt --save-dev
npm install load-grunt-tasks --save
npm install grunt-available-tasks --save-dev
npm install grunt-mkdir --save-dev
npm install request --save-dev


echo
echo

while [ 1 ]
do
    read -p "Enter your apigee username : "  username  

	if [ -z $username ]
	then
		echo "Required !!! "
	else    
		break
	fi

done


while [ 1 ]
do
    read -p 'Enter your apigee password : ' -s Password  
    
	if [ -z $Password ]
	then
	    echo
		echo "Required !!! "
	else    
		break
	fi

done

echo 

while [ 1 ]
do
    read -p "Enter your Organization/Org name  : "  Org

	if [ -z $Org ]
	then
		echo "Required !!! "
	else    
		break
	fi

done

read  -p "Enter your environment you want to Export? (Optionally leave blank if want to export data of all environments) : " env


echo "module.exports = {

	from: {
		version: '19.04',
		url: 'https://api.enterprise.apigee.com',
		userid: '${username}',
		passwd: '${Password}',
		org: '${Org}',
		env: '${env}'
	},
	to: {
		version: '19.04',
		url: 'https://api.enterprise.apigee.com',
		userid: 'admin@google.com',
		passwd: 'SuperSecret123!9',
		org: 'org2',
		env: 'test'
	}
} ;
" > config.js


grunt exportAll -v
echo
echo
echo
echo "Data exported successfully from ${Org}"

echo
echo
read -p "Press Enter to close the window.............."  enter