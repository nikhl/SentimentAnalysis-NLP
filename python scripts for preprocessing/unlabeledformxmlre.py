from BeautifulSoup import BeautifulStoneSoup
import os
target_dir = r"/home/nikhil/workspace/encodeText/regexp/unlabeled"
vocabFilename = os.path.join(target_dir,'electronics_test_vocabulary.txt')
trainLabelsFilename = os.path.join(target_dir,'electronics_test.labels')
trainDataFilename = os.path.join(target_dir,'electronics_test.data')
stopfile = os.path.join(target_dir,'unlabeled_stop.words')

def loaddata():
    stop_handler = open(stopfile,'r').read()
    stop_handler = stop_handler.split()
    stop_handler = " ".join(stop_handler)
    stop_handler = stop_handler.split()
    print set(stop_handler)
    file = open('regexp/unlabeled_reviews.xml','r');
    handler = file.read()
    vocab = open(vocabFilename,'w')
    labelNames = open(trainLabelsFilename,'w')
    docInfo = open(trainDataFilename,'w')
    rawSoup = BeautifulStoneSoup(handler)
    allreviews = rawSoup.findAll('review')
    reviews = [review.contents for review in allreviews]
    vocabulary = []
    train_labels = [review['class'] for review in allreviews]
    train_data_docIds = [review['doc_id'] for review in allreviews]
    for each in reviews:
        words = []
        words.append(each[0])
        words = " ".join(words)
        words = words.split()
        vocabulary.extend(words)
    vocabulary = sorted(set(vocabulary) - set(stop_handler))
    #print len(set(vocabulary))
    for item in vocabulary:
        vocab.write("%s\n" % item)
    
    for label in train_labels:
        labelNames.write("%s\n" % label)
    
    train_data = []
    i = 0
    for each in reviews:
        doc_id = train_data_docIds[i]
        print doc_id
        doc_words = reviews[int(doc_id)-1][0]
        doc_words = doc_words.split()
        words = []
        words.append(each[0])
        words = " ".join(words)
        words = words.split()
        words = sorted(set(words) - set(stop_handler))
        for word in words:
            row = str(i+1)+" "
            word_index = vocabulary.index(word)
            row = row+str(word_index+1)+" "
            word_count = doc_words.count(word)
            row = row+str(word_count)
            train_data.append(row)
        i = i+1
    
    for docRow in train_data:
        docInfo.write("%s\n" % docRow)

    return len(vocabulary)

print loaddata() 
