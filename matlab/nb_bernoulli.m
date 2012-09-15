clear % Loading train data and setting number of words and labels
vocab = importdata('imdb_train_vocabulary.txt');
no_of_words = length(vocab);
newslabels = importdata('newsgrouplabels.txt');
no_of_labels = 2;

% Loading training data
train_data = load('imdb_train.data');
train_labels = load('imdb_train.labels');
no_of_docs = length(train_labels);

% setting laplacian coefficient = 1
laplacian = 1;

%Calculating priors
priors = zeros(no_of_labels,1);
for i=1:no_of_labels
   priors(i) = ((length(find(train_labels == i)))/(length(train_labels))); 
end

%Building (Words) vs (Labels) matrix
words_labels = zeros(no_of_words,no_of_labels);

for i=1:no_of_labels
   docIds = find(train_labels == i);
   for j=1:numel(docIds)
       index = docIds(j);
       indices = find(train_data(:,1) == index);
       words_labels(train_data(indices,2),i) = words_labels(train_data(indices,2),i) + 1;
   end
end

%load test datartest_data(:,2)
test_data = load('imdb_test.data');
test_labels = load('imdb_test.labels');
test_docs_length = length(test_labels);


%Calculating posteriors
posteriors_combined = zeros(test_docs_length,no_of_labels);

for i = 1:test_docs_length
    indices = find(test_data(:,1) == i);    
    wordIds = test_data(indices,2);
    for j=1:no_of_labels
        posteriors_combined(i,j) = sum(log((words_labels(wordIds,j) + laplacian)/(numel(find(train_labels == j)) + (laplacian * 2))) + log(priors(j))) ;
        %posteriors_combined(i,j) = sum(log((words_labels(wordIds,j) + laplacian)/(numel(find(train_labels == j)) + (laplacian * no_of_words))) + log(priors(j))) ;
        %posteriors_combined(i,j) = sum(((words_labels(wordIds,j) + laplacian)/(numel(find(train_labels == j)) + (laplacian * no_of_words))) * (priors(j))) ;
    end
end


z = 1:length(test_labels);
[dummy,posteriors] = max((posteriors_combined(z,:)),[],2);

errors = posteriors(:)-test_labels(:);
errors(errors == 0) = [];
no_of_errors = length(errors);

classifier_accuracy = ((1-(no_of_errors/length(test_labels)))*100);

fprintf('Classifier accuracy is %d %',classifier_accuracy);

confusion_matrix = zeros(no_of_labels,no_of_labels);

for i=1:length(test_labels)
    if posteriors(i) ~= test_labels(i)
        confusion_matrix(test_labels(i),posteriors(i)) = confusion_matrix(test_labels(i),posteriors(i)) + 1;
    end
end


Arraycopy = words_labels(:,1);
for j = 1:10
   [a, Index(j)] = max(Arraycopy);
   Arraycopy(Index(j)) = 0;
end
posmaxval = vocab(Index);

Arraycopy = words_labels(:,2);
for j = 1:10
   [a, Index(j)] = max(Arraycopy);
   Arraycopy(Index(j)) = 0;
end
negmaxval = vocab(Index);






