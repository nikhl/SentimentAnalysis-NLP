vocab = importdata('imdb_train_vocabulary.txt');

%load test datartest_data(:,2)
test_data = load('imdb_test.data');
test_labels = load('imdb_test.labels');
test_docs_length = length(test_labels);

%Loading polarity files
pospolarity = importdata('posformatted');
negpolarity = importdata('negformatted');

%pospolarity = set(pospolarity);
%negpolarity = set(negpolarity);

% forming predicted labels vector
predict = zeros(test_docs_length,1);

pol_length_matrix = zeros(test_docs_length,2);

for i=1:test_docs_length
   indices = find(test_data(:,1) == i);
   word_ids = test_data(indices,2);
   pos_length = length(intersect(vocab(word_ids),pospolarity));
   neg_length = length(intersect(vocab(word_ids),negpolarity));
   if pos_length >=  neg_length
       pol_length_matrix(i,1) = pos_length;
       pol_length_matrix(i,2) = neg_length;
       predict(i) = 1;
   else
       pol_length_matrix(i,1) = pos_length;
       pol_length_matrix(i,2) = neg_length;
       predict(i) = 2;
   end
end

no_of_errors = test_docs_length - sum(predict == test_labels);

classifier_accuracy = ((1-(no_of_errors/length(test_labels)))*100);

fprintf('Classifier accuracy is %d %',classifier_accuracy);
