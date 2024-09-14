function proxy_on() {
	export all_proxy="socks5://10.166.30.102:7891"
	export http_proxy="http://10.166.30.102:7890"
	export https_proxy="http://10.166.30.102:7890"
	export socks_proxy="socks5://10.166.30.102:7891"
	export ftp_proxy="http://10.166.30.102:7890"
 	export NO_PROXY=127.0.0.1,localhost
	echo -e "[√] 已开启代理"
}

function proxy_off(){
	unset http_proxy
	unset https_proxy
	unset no_proxy
  unset HTTP_PROXY
	unset HTTPS_PROXY
	unset NO_PROXY
	echo -e "[×] 已关闭代理"
}
