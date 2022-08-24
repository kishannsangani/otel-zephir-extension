FROM ubuntu:20.04

WORKDIR /home

ADD interceptors /home/interceptors/
ADD example /home/example/

RUN apt-get update && \
	apt-get install -y vim git curl && \
	# Install PHP
	DEBIAN_FRONTEND=noninteractive apt -y install software-properties-common && \
	add-apt-repository -y ppa:ondrej/php && \
	apt-get update && \
	apt -y install php7.4 && \
	apt-get install -y php7.4 php7.4-bcmath php7.4-bz2 php7.4-common php7.4-curl php7.4-decimal php7.4-dev php7.4-json php7.4-intl php7.4-mbstring php7.4-mcrypt php7.4-mysql php7.4-opcache php7.4-pgsql php7.4-readline php7.4-sqlite3 php7.4-ssh2 php7.4-xml php7.4-xmlrpc php7.4-zip php7.4-yaml && \
	apt-get install -y php7.4-dev gcc make re2c autoconf automake git libpcre3-dev build-essential && \
	# Install Zephir Parser
	pecl channel-update pecl.php.net && \
	pecl install zephir_parser && \
	# Configure Zephir Parser
	echo '[Zephir Parser]\n\
	extension=zephir_parser.so\n'\
	> /etc/php/7.4/cli/conf.d/Zephir.ini && \
	# Install Composer
	apt-get install -y composer && \
	# Install Zephir
	composer global require phalcon/zephir:0.16.0 && \
	echo 'export PATH=$PATH:`composer -n config --global home`/vendor/bin' >> ~/.bashrc && \
	. ~/.bashrc && \
	zephir --version && \
	ls && \
	cd /home/ && \
	# Init Hello World
	zephir init helloworld && \
	cd helloworld && \
	cp /home/interceptors/greetings.zep ./helloworld/ && \
	zephir build && \
	# Configure Hello World Extension
	echo '[Hello World]\n\
	extension=/home/helloworld/ext/modules/helloworld.so\n'\
	> /etc/php/7.4/cli/conf.d/HelloWorld.ini && \
	cd /home/example && \
	composer require "php-http/guzzle7-adapter" && \
	composer require open-telemetry/opentelemetry

CMD ["sleep","6h"]