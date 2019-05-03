module steps::detection::Stemmer

import analysis::text::stemming::Snowball;

import steps::detection::RequirementsReader;

import IO;

Requirement stemWords(Requirement reqs) {
  // TODO: Stem the word list of the requirement. 
  // You can stem a list of words using the given method 'stemAll'.
  
  // REMOVE BELOW LINE, ONLY HERE TO MAKE THE TEMPLATES RUNNABLE
  return reqs;
}

// TODO: Add extra functions if wanted / needed

@doc {
  Returns the passed in list of words in a stemmed form
}
list[str] stemAll(list[str] orig) = [porterStemmer(w) | w <- orig];

test bool shouldStemWeakness() = stemWords({<"A1",["weakness"]>}) == {<"A1", ["weak"]>};
test bool shouldStemRunningAndWalking() = stemWords({<"A1",["running","walking"]>}) == {<"A1", ["run","walk"]>};
