source ~/.bash_snippet
source ~/.coding_test_snippet
source ~/.docker_snippet
source ~/.git_snippet
source ~/.python_snippet

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
	echo ""
	echo "###### BASH COMMAND ######"
	echo "pk <port>"
	echo "host <port>"
	echo "cost <port>"
	echo ""
	echo "###### github COMMAND ######"
	echo "ignore <language>"
	echo ""
	echo "###### util COMMAND ######"
	echo ct
	echo "rcopy <str>"
	echo "after <num>"
}


## utils
ct(){
	echo 'import sys' > codingTest.py
	echo '' >> codingTest.py
	echo 'input = sys.stdin.readline' >> codingTest.py
	echo '' >> codingTest.py
	echo 'def spt():' >> codingTest.py
	echo '    return input().split(" ")' >> codingTest.py
	echo '' >> codingTest.py
	echo '' >> codingTest.py
	echo 'def spt_map_int():' >> codingTest.py
	echo '    return list(map(int, input().split(" ")))' >> codingTest.py
	echo '' >> codingTest.py
	echo '' >> codingTest.py
	echo 'def assertEqual(a, b):' >> codingTest.py
	echo '    assert a == b' >> codingTest.py
}
