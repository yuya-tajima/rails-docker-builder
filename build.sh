#!/usr/bin/env zsh

set -u

function usage {
    cat <<EOF

$(basename ${ZSH_ARGZERO}) 

Build a Rails Docker environment easily

Usage:
    $(basename ${ZSH_ARGZERO}) [<rails_version> [mysql|postgresql [<ruby_version>]]]

Options:
    <rails_version>    a specific version of rails, including the patch version number(e.g. x.x.x). see https://rubygems.org/gems/rails/versions
    [mysql|postgresql] the database to be connected to rails
    <ruby_version>     a specific version of ruby. see https://www.ruby-lang.org/en/downloads/releases/
    --help, -h         print usage

EOF
}

ARG1=${1:-}
if [[ $ARG1 = '-h' ]] || [[ $ARG1 = '--help' ]]; then
  usage
  exit
fi

# Rails version
RAILS_VERSION=${1:-5.2.2}
# Rails database('mysql' or 'postgresql').
DATABASE=${2:-mysql}
# Ruby version
RUBY_VERSION=${3:-2.5}

RAILS_MAJOR_VERSION=${RAILS_VERSION:0:1}

WEBPACK_NATIVE_SUPPORT=0
if [[ ${RAILS_VERSION:0:3} != '5.0' ]] && [[ $RAILS_MAJOR_VERSION -ge 5 ]]; then
  WEBPACK_NATIVE_SUPPORT=1
fi

echo "###########################"
echo
echo " rails version: ${RAILS_VERSION}"
echo " database     : ${DATABASE}"
echo " ruby version : ${RUBY_VERSION}"
echo
echo "###########################"

sleep 1

if [[ ! -d rails ]];then
  mkdir rails
fi

cp config/Dockerfile Dockerfile
sed -i ""  -e "s/2.5/${RUBY_VERSION}/g" Dockerfile
cp config/docker-compose/${DATABASE}.yml docker-compose.yml

cp config/Gemfile rails/
touch rails/Gemfile.lock 

sed -i ""  -e "s/5.2.2/${RAILS_VERSION}/g" rails/Gemfile

docker-compose run --no-deps web rails new . --webpack --force --database=${DATABASE} --skip-bundle

# To fix rails version strictly
sed -i ""  -e "s/gem 'rails', '~> ${RAILS_VERSION}'/gem 'rails', '= ${RAILS_VERSION}'/g" rails/Gemfile

if [[ $WEBPACK_NATIVE_SUPPORT -eq 0 ]]; then
  echo "gem 'webpacker', git: 'https://github.com/rails/webpacker.git', tag: 'v4.3.0'" >> rails/Gemfile
fi

docker-compose build

# move the database configuration file to rails
cp config/database/${DATABASE}.yml rails/config/database.yml

echo
echo "###########################################################################################"
echo "#                                                                                         #"
echo "# Please follow the steps below.                                                          #"
echo "#                                                                                         #"
if [[ $WEBPACK_NATIVE_SUPPORT -eq 1 ]]; then
echo "# 1. Run the 'docker-compose run --no-deps web rails webpacker:install'                   #"
else
echo "# 1. Run the 'docker-compose run --no-deps web bundle install', and the                   #"
echo "#    run the 'docker-compose run --no-deps web rake webpacker:install'                    #"
fi
echo "# 2. Run the 'docker-compose up' or 'docker-compose up -d' command.                       #"
echo "# 3. Open another terminal and run the 'docker-compose run web rake db:create' command.   #"
echo "#                                                                                         #"
echo "# To see more information above, visit https://docs.docker.com/compose/rails/             #"
echo "#                                                                                         #"
echo "# I hope you could enjoy your development.                                                #" 
echo "#                                                                                         #"
echo "# References of Docker Image                                                              #"
echo "# Ruby      : https://hub.docker.com/_/ruby                                               #"
echo "# MySQL     : https://hub.docker.com/_/mysql/                                             #"
echo "# PostgreSQL: https://hub.docker.com/_/postgres                                           #"
echo "#                                                                                         #"
echo "###########################################################################################"
echo

