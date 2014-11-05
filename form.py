#! /bin/python

import urllib2
import urllib
from bs4 import BeautifulSoup

#URL Manipulation
form_URL = raw_input("Enter form url: ")
list_URL = form_URL.partition('viewform')
response_URL = list_URL[0] + "formResponse"

#spam to feed form
spam = "SPAM"

#get viewform html
try:
	viewform = urllib2.urlopen(form_URL)
except:
	print("There was some problem while accesing viewform page.")
	exit()

#soup creation
soup = BeautifulSoup(viewform.read())

#define lists
input_tag_list = soup.findAll('input')
textarea_tag_list = soup.findAll('textarea')
textarea_name_tag_list = []
text_relevant_tag_list = []
text_name_tag_list = []
radio_relevant_tag_list = []
radio_name_tag_list = []
radio_value_tag_list = []
checkbox_relevant_tag_list = []
checkbox_name_tag_list = []
checkbox_value_tag_list = []

#get name for textarea tags
for particular_tag in textarea_tag_list:
	textarea_name_tag_list.append(str(particular_tag['name']))

#get tags for text type
for particular_tag in input_tag_list:
	try:
		if str(particular_tag['type']) == 'text':
			text_relevant_tag_list.append(particular_tag)			
	except:
		pass

#get tags for radio type
for particular_tag in input_tag_list:
	try:
		if str(particular_tag['type']) == 'radio':
			radio_relevant_tag_list.append(particular_tag)
	except:	
		pass

#get tags for checkbox type
for particular_tag in input_tag_list:
        try:
                if str(particular_tag['type']) == 'checkbox':
                        checkbox_relevant_tag_list.append(particular_tag)
        except:
                pass

#get name of each input of text type
for relevant_tag in text_relevant_tag_list:
	try:	
		text_name_tag_list.append(str(relevant_tag['name']))
	except:
		pass

#get name and value of each input of radio type
for relevant_tag in radio_relevant_tag_list:
	try:
		radio_name_tag_list.append(str(relevant_tag['name']))
		radio_value_tag_list.append(str(relevant_tag['value']))
	except:
		pass

#get name and value of each input of checkbox type
for relevant_tag in checkbox_relevant_tag_list:
        try:
                checkbox_name_tag_list.append(str(relevant_tag['name']))
                checkbox_value_tag_list.append(str(relevant_tag['value']))
        except:
                pass

#modify radio lists
i = len(radio_name_tag_list) - 1
while i > -1:
	current_count = radio_name_tag_list.count(radio_name_tag_list[i])
	if current_count != 1:
		del radio_name_tag_list[i]
		del radio_value_tag_list[i]
		i -= 1
	else:
		i -= 1

#modify checkbox lists
i = len(checkbox_name_tag_list) - 1
while i > -1:
        current_count = checkbox_name_tag_list.count(checkbox_name_tag_list[i])
        if current_count != 1:
                del checkbox_name_tag_list[i]
                del checkbox_value_tag_list[i]
                i -= 1
        else:
                i -= 1

#get dictionary
name_dictionary = {}

#populate dictionary
for name in textarea_name_tag_list:
	name_dictionary.update({name: spam})

for name in text_name_tag_list:
	name_dictionary.update({name: spam})

for i in range(0, len(radio_name_tag_list)):
	name_dictionary.update({radio_name_tag_list[i]: radio_value_tag_list[i]})

for i in range(0, len(checkbox_name_tag_list)):
        name_dictionary.update({checkbox_name_tag_list[i]: checkbox_value_tag_list[i]})
#fill form 
data_request = urllib.urlencode(name_dictionary)
form_response = urllib2.urlopen(response_URL, data_request)

#verify if submitted correctly
submit_soup = BeautifulSoup(form_response.read())
response_text = submit_soup.get_text()
if "Your response has been recorded." in response_text:
	print "Form correctly spammed."
else:
	print "Not able to spam the form."
