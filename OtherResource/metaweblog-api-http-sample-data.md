# What is metaWeblog API 

See [http://en.wikipedia.org/wiki/MetaWeblog](http://en.wikipedia.org/wiki/MetaWeblog)

# The MetaWeblog API reference

See [http://codex.wordpress.org.cn/XML-RPC_MetaWeblog_API](http://codex.wordpress.org.cn/XML-RPC_MetaWeblog_API)

# Samples

## metaWeblog.getRecentPosts

### 支持情况

平台|支持情况|发送地址
---|---|---
Wordpress|支持|http://www.webersongao.com/
ZBlog|支持|http://www.webersongao.com:8080/xmlrpc
Cnblogs|支持|http://www.cnblogs.com/webersongao/services/metaweblog.aspx
OSChina|支持|http://my.oschina.net/action/xmlrpc
163|支持|http://os.blog.163.com/api/xmlrpc/metaweblog/
51CTO|支持|http://webersongao.blog.51cto.com/xmlrpc.php
Sina|支持|http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php


### 发送数据（ZBlog示例）
```
<?xml version="1.0"?>
<methodCall>
    <methodName>metaWeblog.getRecentPosts</methodName>
	<params>
		<param>
			<value>1</value>
		</param>
		<param>
			<value>admin</value>
		</param>
		<param>
			<value>123456</value>
		</param>
		<param>
		    <value><i4>1</i4></value>
		</param>
	</params>
</methodCall>
```

## metaWeblog.getUsersBlogs

### 支持情况

平台|支持情况|发送地址
---|---|---
Wordpress|支持|http://www.webersongao.com/
ZBlog|支持|http://www.webersongao.com:8080/xmlrpc
Cnblogs|不支持|http://www.cnblogs.com/swiftartisan/services/metaweblog.aspx
OSChina|支持|http://my.oschina.net/action/xmlrpc
163|不支持|http://os.blog.163.com/api/xmlrpc/metaweblog/
51CTO|支持（但返回结果为空）|http://webersongao.blog.51cto.com/xmlrpc.php
Sina|支持|http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php


### 发送数据（ZBlog示例）

```
<?xml version="1.0"?>
<methodCall>
	<methodName>metaWeblog.getUsersBlogs</methodName>
	<params>
		<param>
			<value>1</value>
		</param>
		<param>
			<value>admin</value>
		</param>
		<param>
			<value>123456</value>
		</param>
	</params>
</methodCall>
```

## metaWeblog.getPost

### 支持情况

平台|支持情况|发送地址
---|---|---
Wordpress|支持|http://www.webersongao.com/
ZBlog|支持|http://www.webersongao.com:8080/xmlrpc
Cnblogs|支持|http://www.cnblogs.com/tangyouwei/services/metaweblog.aspx
OSChina|支持|http://my.oschina.net/action/xmlrpc
163|支持（但返回结果为空|http://os.blog.163.com/api/xmlrpc/metaweblog/
51CTO|支持|http://webersongao.blog.51cto.com/xmlrpc.php
Sina|支持|http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php

### 发送数据（ZBlog示例）

```
<?xml version="1.0"?>
<methodCall>
	<methodName>metaWeblog.getPost</methodName>
	<params>
		<param>
			<value>6</value>
		</param>
		<param>
			<value>admin</value>
		</param>
		<param>
			<value>123456</value>
		</param>
	</params>
</methodCall>
```

## metaWeblog.getCategories

### 支持情况

平台|支持情况|发送地址
---|---|---
Wordpress|支持|http://www.webersongao.com/
ZBlog|支持（但500错误）|http://www.webersongao.com:8080/xmlrpc
Cnblogs|支持|http://www.cnblogs.com/webersongao/services/metaweblog.aspx
OSChina|支持|http://my.oschina.net/action/xmlrpc
163|支持|http://os.blog.163.com/api/xmlrpc/metaweblog/
51CTO|支持|http://webersongao.blog.51cto.com/xmlrpc.php
Sina|支持|http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php

### 发送数据（ZBlog示例）

```
<?xml version="1.0"?>
<methodCall>
	<methodName>metaWeblog.getCategories</methodName>
	<params>
		<param>
			<value>1</value>
		</param>
		<param>
			<value>admin</value>
		</param>
		<param>
			<value>123456</value>
		</param>
	</params>
</methodCall>
```

## metaWeblog.newPost

### 支持情况

平台|支持情况|发送地址
---|---|---
Wordpress|支持|http://www.webersongao.com/
ZBlog|支持（但500错误）|http://www.webersongao.com:8080/xmlrpc
Cnblogs|支持但错误（Request contains too few param elements based on method signature）|http://www.cnblogs.com/webersongao/services/metaweblog.aspx
OSChina|支持但错误（Failed to parse XML-RPC request: Expected param element, got struct）|http://my.oschina.net/action/xmlrpc
163|支持但错误|http://os.blog.163.com/api/xmlrpc/metaweblog/
51CTO|支持但错误|http://webersongao.blog.51cto.com/xmlrpc.php
Sina|支持|http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php

### 发送数据（ZBlog示例）

```
<?xml version="1.0"?>
<methodCall>
	<methodName>metaWeblog.newPost</methodName>
	<params>
		<param>
			<value>1</value>
		</param>
		<param>
			<value>admin</value>
		</param>
		<param>
			<value>123456</value>
		</param>
        <struct>
                <member>
                    <name>title</name>
                    <value>metaWeblog发布文章测试</value>
                </member>
                <member>
                    <name>description</name>
                    <value>测试文章内容：此api文档http://codex.wordpress.org.cn/XML-RPC_MetaWeblog_API#metaWeblog.newPost</value>
                </member>
               <member>
                    <name>dateCreated</name>
                    <value>
                        <dateTime.iso8601>20150616T00:04:00</dateTime.iso8601>
                    </value>
                </member>
        </struct>
	</params>
</methodCall>
```

## metaWeblog.editPost

### 支持情况

平台|支持情况|发送地址
---|---|---
Wordpress|支持|http://www.webersongao.com/
ZBlog|500|http://www.webersongao.com:8080/xmlrpc
Cnblogs|500|http://www.cnblogs.com/webersongao/services/metaweblog.aspx
OSChina|500|http://my.oschina.net/action/xmlrpc
163|500|http://os.blog.163.com/api/xmlrpc/metaweblog/
51CTO|500|http://webersongao.blog.51cto.com/xmlrpc.php
Sina|支持|http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php


### 发送数据（ZBlog示例）

```
<?xml version="1.0"?>
<methodCall>
	<methodName>metaWeblog.editPost</methodName>
	<params>
		<param>
			<value>6</value>
		</param>
		<param>
			<value>admin</value>
		</param>
		<param>
			<value>123456</value>
		</param>
        <struct>
                <member>
                    <name>title</name>
                    <value>metaWeblog发布文章测试</value>
                </member>
                <member>
                    <name>description</name>
                    <value>测试文章内容：此api文档http://codex.wordpress.org.cn/XML-RPC_MetaWeblog_API#metaWeblog.newPost</value>
                </member>
        </struct>
	</params>
</methodCall>
```


## metaWeblog.deletePost

### 支持情况

平台|支持情况|发送地址
---|---|---
Wordpress|支持|http://www.webersongao.com/
ZBlog|500|http://www.webersongao.com:8080/xmlrpc
Cnblogs|500|http://www.cnblogs.com/webersongao/services/metaweblog.aspx
OSChina|500|http://my.oschina.net/action/xmlrpc
163|500|http://os.blog.163.com/api/xmlrpc/metaweblog/
51CTO|500|http://webersongao.blog.51cto.com/xmlrpc.php
Sina|500|http://upload.move.blog.sina.com.cn/blog_rebuild/blog/xmlrpc.php

### 发送数据（ZBlog示例）

```
<?xml version="1.0"?>
<methodCall>
	<methodName>metaWeblog.deletePost</methodName>
	<params>
		<param>
			<value>1</value>
		</param>
	    <param>
			<value>6</value>
		</param>
		<param>
			<value>admin</value>
		</param>
		<param>
			<value>123456</value>
		</param>
	</params>
</methodCall>
```