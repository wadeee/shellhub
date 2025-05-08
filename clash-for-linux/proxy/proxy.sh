function proxy_on() {
	export all_proxy="socks5h://10.166.10.231:7890"
	export http_proxy="http://10.166.10.231:7890"
	export https_proxy="http://10.166.10.231:7890"
	export ftp_proxy="http://10.166.10.231:7890"
	export no_proxy=127.0.0.1,localhost
	echo -e "[√] 已开启代理"
}

function proxy_off(){
	unset all_proxy
	unset http_proxy
	unset https_proxy
	unset ftp_proxy
	unset no_proxy
	echo -e "[×] 已关闭代理"
}

proxy_on
