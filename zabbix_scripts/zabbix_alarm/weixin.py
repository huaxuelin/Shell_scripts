#!/usr/bin/env python
# script name : wechat.py
# date: 2015/11/24 16:00
# create user: Puppet
# -*- coding: utf-8 -*-

import urllib,urllib2,json
import sys
reload(sys)
sys.setdefaultencoding( "utf-8" )

class WeChat(object):
	__token_id = ''
	# init attribute
	def __init__(self,url):
		self.__url = url.rstrip('/')
		self.__corpid = 'wwba90979b8cb2cfc8'
		self.__secret = 'liacVzJ1HY-FUqp4Pygdi-8h-jU4MYDmPA4tHYHdr6c'

	# Get TokenID
	def authID(self):
		params = {'corpid':self.__corpid, 'corpsecret':self.__secret}
		data = urllib.urlencode(params)

		content = self.getToken(data)

		try:
			self.__token_id = content['access_token']
			# print content['access_token']
		except KeyError:
			raise KeyError

	# Establish a connection
	def getToken(self,data,url_prefix='/'):
		url = self.__url + url_prefix + 'gettoken?'
		try:
			response = urllib2.Request(url + data)
		except KeyError:
			raise KeyError
		result = urllib2.urlopen(response)
		content = json.loads(result.read())
		return content

	# Get sendmessage url
	def postData(self,data,url_prefix='/'):
		url = self.__url + url_prefix + 'message/send?access_token=%s' % self.__token_id
		request = urllib2.Request(url,data)
		try:
			result = urllib2.urlopen(request)
		except urllib2.HTTPError as e:
			if hasattr(e,'reason'):
				print 'reason',e.reason
			elif hasattr(e,'code'):
				print 'code',e.code
			return 0
		else:
			content = json.loads(result.read())
			result.close()
		return content

	# send message
	def sendMessage(self,touser,message,contents):

		self.authID()

		data = json.dumps({
			'touser':touser,
			'toparty':"1",
			'msgtype':"text",
			'agentid':"1000004",
			'text':{
				'content':message  + '\n' + contents
			},
			'safe':"0"
		},ensure_ascii=False)

		response = self.postData(data)
		print response


if __name__ == '__main__':
	a = WeChat('https://qyapi.weixin.qq.com/cgi-bin')
	a.sendMessage(sys.argv[1],sys.argv[2],sys.argv[3])
