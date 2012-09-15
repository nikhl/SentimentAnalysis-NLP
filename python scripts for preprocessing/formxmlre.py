from BeautifulSoup import BeautifulStoneSoup
import os
import re
from xml.dom.minidom import Document
target_dir = r"/home/nikhil/workspace/formXML/apparel/regexp"
source_file = r"/home/nikhil/workspace/formXML/apparel/labeled_combined.reviews"
reviewsFilename = os.path.join(target_dir,'labeled_combined_reviews.xml')

posrev = open(source_file,'r')
handler = posrev.read()
soup = BeautifulStoneSoup(handler)
allreviews = soup.findAll('review')
print len(allreviews)
reviews = [review.review_text.contents for review in allreviews]

newSoup = BeautifulStoneSoup()
soupText = "<reviews>"

doc = Document()
reviews_xml = doc.createElement("reviews")
doc.appendChild(reviews_xml)

for eachReview in reviews:
    review = doc.createElement("review")
    review.setAttribute("doc_id", str(reviews.index(eachReview)+1))
    if (reviews.index(eachReview) > 949):
        review.setAttribute("class", "2")
    else:
        review.setAttribute("class", "1")
    temp = eachReview[0].strip()
    temp = temp.replace('"','')
    temp = temp.replace("'",'')
    temp = temp.replace('&','')
    temp = temp.replace('$','')
    temp = temp.replace(';','')
    temp = temp.replace('quot','')
    temp = re.sub(r'[\d]',"",temp)
    temp = re.sub(r'[/%\\[\\{}]',"",temp)
    temp = re.sub(r'[@#!:,\\.]',"",temp)
    temp = re.sub(r'[\\(\\)\\{\\}-]',"",temp)
    rtext = doc.createTextNode(temp)
    review.appendChild(rtext)
    reviews_xml.appendChild(review)
        
f = open(reviewsFilename, "w")
f.write(doc.toprettyxml(indent=""))
f.close()
