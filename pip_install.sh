#!/bin/bash
#
#!/bin/bash
#
#       pip_install.sh
#       Author:@rootsecurity
#       Date:2014-04-17 16:23:33
#       Usage:pip_install.sh {install|uninstall|}

pver=1.5.4

function_install() {
        if [ ! -f "pip-${pver}.tar.gz" ]; then
                wget -c https://pypi.python.org/packages/source/p/pip/pip-${pver}.tar.gz --no-check-certificate
        fi

        tar zxvf pip-${pver}.tar.gz
        cd pip-${pver}/
        /usr/bin/python setup.py build
        /usr/bin/python setup.py install
        cd ../
}

function_uninstall() {
        echo "The Packages has been uninstall manually!"
}

case $1 in 
        install)
                function_install
                ;;
        uninstall)
                function_uninstall
                ;;
        *)
                echo "Usage: $0 {install|uninstall}"
                exit 1
                ;;
esac
