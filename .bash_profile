source ~/terminal-snippets/.bash_snippet
source ~/terminal-snippets/.coding_test_snippet
source ~/terminal-snippets/.docker_snippet
source ~/terminal-snippets/.git_snippet
source ~/terminal-snippets/.python_snippet

list(){
	echo "###### DOCKER ######"
	echo "up"
	echo "down"
	echo "pydocker"
	echo "jdocker"
	echo "build <image:dev>"
	echo "rmi"
	echo ""

	echo "###### PYTHON ######"
	echo "venv <py:version>"
	echo "activate"
	echo "rr"
	echo "requirements"
	echo "freeze"
	echo "fast"
	echo "run <port>"
	echo "db"
	echo "pi <package>"
	echo "pui <package>"
	echo ""

	echo "###### BASH COMMAND ######"
	echo "pk <port>"
	echo "host <port>"
	echo "culst <port>"
	echo "rcopy <input>"
	echo "after <num> <optional:mm-dd>"
	echo "lck <filename>"
	echo "sb"
	echo "sz"
	echo ""

	echo "###### github COMMAND ######"
	echo "ignore <language>"
	echo ""

	echo "###### util COMMAND ######"
	echo ct
	echo ""
}