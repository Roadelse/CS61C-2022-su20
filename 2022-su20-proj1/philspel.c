/*
 * Include the provided hash table library.
 */
#include "hashtable.h"

/*
 * Include the header file.
 */
#include "philspel.h"

/*
 * Standard IO and file routines.
 */
#include <stdio.h>

/*
 * General utility routines (including malloc()).
 */
#include <stdlib.h>

/*
 * Character utility routines.
 */
#include <ctype.h>

/*
 * String utility routines.
 */
#include <string.h>

/*
 * This hash table stores the dictionary.
 */
HashTable *dictionary;

/*
 * The MAIN routine.  You can safely print debugging information
 * to standard error (stderr) as shown and it will be ignored in 
 * the grading process.
 */
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Specify a dictionary\n");
    return 0;
  }
  /*
   * Allocate a hash table to store the dictionary.
   */
  fprintf(stderr, "Creating hashtable\n");
  dictionary = createHashTable(2255, &stringHash, &stringEquals);

  fprintf(stderr, "Loading dictionary %s\n", argv[1]);
  readDictionary(argv[1]);
  fprintf(stderr, "Dictionary loaded\n");
  // fprintf(stdout, "1196 key = %s\n", dictionary->data[1196]->key);
  // fprintf(stdout, "1201 key = %s\n", dictionary->data[1201]->key);
  // for (int k = 0; k < 2255; k++){
    // if (dictionary->data[k])
    // fprintf(stdout, "%d key = %s\n", k, dictionary->data[k]->key);
  // }


  fprintf(stderr, "Processing stdin\n");
  processInput();

  for (int i = 0; i < dictionary->size; ++i) {
    if (dictionary->data[i] != NULL){
      struct HashBucket *hbt = dictionary->data[i];
      struct HashBucket *hbt2;
      while (hbt->next){
        hbt2 = hbt->next;
        free(hbt->key);
        free(hbt);
        hbt = hbt2;
      }
      free(hbt);
    }
  }
  free(dictionary);


  /*
   * The MAIN function in C should always return 0 as a way of telling
   * whatever program invoked this that everything went OK.
   */
  return 0;
}

/*
 * This should hash a string to a bucket index.  Void *s can be safely cast
 * to a char * (null terminated string) and is already done for you here 
 * for convenience.
 */
unsigned int stringHash(void *s) {
  char *string = (char *)s;
  int len = strlen(s);
  unsigned long long hash = 5381;
  for (int i = 0; i < len; i++) { 
    hash = hash * 33 + (unsigned long long) string[i]; 
  }
  // fprintf(stdout, "%s <-> %lld\n", string, hash % 2255);
  return hash % 2255;
}

/*
 * This should return a nonzero value if the two strings are identical 
 * (case sensitive comparison) and 0 otherwise.
 */
int stringEquals(void *s1, void *s2) {
  char *string1 = (char *)s1;
  char *string2 = (char *)s2;
  // -- TODO --
  if (strcmp(string1, string2)){
    // fprintf(stdout, "%s != %s\n", string1, string2);
    return 0;
  }else{
    // fprintf(stdout, "%s == %s\n", string1, string2);
    return 1;
  }
}

/*
 * This function should read in every word from the dictionary and
 * store it in the hash table.  You should first open the file specified,
 * then read the words one at a time and insert them into the dictionary.
 * Once the file is read in completely, return.  You will need to allocate
 * (using malloc()) space for each word.  As described in the spec, you
 * can initially assume that no word is longer than 60 characters.  However,
 * for the final 20% of your grade, you cannot assumed that words have a bounded
 * length.  You CANNOT assume that the specified file exists.  If the file does
 * NOT exist, you should print some message to standard error and call exit(1)
 * to cleanly exit the program.
 *
 * Since the format is one word at a time, with new lines in between,
 * you can safely use fscanf() to read in the strings until you want to handle
 * arbitrarily long dictionary chacaters.
 */

unsigned int myGetLine(char** line, unsigned int *n, FILE *fp)
{
    char *buf = *line;
    unsigned int c, i=0;//i来记录字符串长度，c来存储字符
    if(buf == NULL || *n == 0)
    {
        *line = malloc(60);
        buf = *line;
        *n = 60;
    }

    while((c=fgetc(fp))!='\n')
    {
        if(c==EOF)
            return -1;
        if(i<*n-2)//留2个空间给\n和\0
        {
            *(buf+i++)=c;
        }
        else
        {
            *n = *n+10;
            buf = realloc(buf,*n);//空间不足时，重新进行分配
            *(buf+i++)=c;
        }
    }
    *(buf+i++)='\0';
    return i;

}


void readDictionary(char *dictName) {
  FILE *fp = fopen(dictName, "r");
  char *str = NULL;
  unsigned int i, n;
  if (fp){
    while ((i = myGetLine(&str, &n, fp)) != -1){
      insertData(dictionary, str, str);
      // free(str);
      str = NULL;
    }
  }else{
    fprintf(stderr, "no file!\n");
  }
}


/*
 * This should process standard input (stdin) and copy it to standard
 * output (stdout) as specified in the spec (e.g., if a standard 
 * dictionary was used and the string "this is a taest of  this-proGram" 
 * was given to stdin, the output to stdout should be 
 * "this is a teast [sic] of  this-proGram").  All words should be checked
 * against the dictionary as they are input, then with all but the first
 * letter converted to lowercase, and finally with all letters converted
 * to lowercase.  Only if all 3 cases are not in the dictionary should it
 * be reported as not found by appending " [sic]" after the error.
 *
 * Since we care about preserving whitespace and pass through all non alphabet
 * characters untouched, scanf() is probably insufficent (since it only considers
 * whitespace as breaking strings), meaning you will probably have
 * to get characters from stdin one at a time.
 *
 * Do note that even under the initial assumption that no word is longer than 60
 * characters, you may still encounter strings of non-alphabetic characters (e.g.,
 * numbers and punctuation) which are longer than 60 characters. Again, for the 
 * final 20% of your grade, you cannot assume words have a bounded length.
 */
void processInput() {
  char *word, *word2, *word3;
  unsigned int i, c, n, j;
  
  n = 60;
  word = malloc(sizeof(char) * n);

  // while ((c = getchar()) != EOF){
  //   fprintf(stdout, "%c", c);
  // }
  i = 0;
  while ((c = getchar())){
    if ((c >= 'a' && c <= 'z') || (c >= 'A' && c<='Z')){
      *(word+i++) = c;
      if (i + 2 >= n){
        word = realloc(word, sizeof(char) * (n + 10));
        n += 10;
      }
    }else{
      if (i == 0){
        fprintf(stdout, "%c", c);
        continue;
      }
      *(word+i) = '\0';
      word2 = malloc(sizeof(char) * (strlen(word) + 1));
      word3 = malloc(sizeof(char) * (strlen(word) + 1));
      strcpy(word2, word);
      strcpy(word3, word);
      // fprintf(stdout, "len = %d\n", (int) strlen(word));
      for (j = 0; j < strlen(word); j++){
        // fprintf(stdout, "hi\n");
        if (j >= 1) *(word2 + j) = tolower(*(word + j));
        *(word3 + j) = tolower(*(word + j));
      }
      // fprintf(stdout, "%s%s\n", "debug : ", word);
      // fprintf(stdout, "%s%s\n", "debug : ", word2);
      // fprintf(stdout, "%s%s\n", "debug : ", word3);
      // fprintf(stdout, "isFind w1? %d\n", findData(dictionary, word) != NULL);
      // fprintf(stdout, "isFind w2? %d\n", findData(dictionary, word2) != NULL);
      // fprintf(stdout, "isFind w3? %d\n", findData(dictionary, word3) != NULL);
      if (findData(dictionary, word) != NULL || findData(dictionary, word2) != NULL || findData(dictionary, word3) != NULL){
        if (c == EOF)
          fprintf(stdout, "%s", word);
        else
          fprintf(stdout, "%s%c", word, c);
      }else{
        if (c == EOF)
          fprintf(stdout, "%s%s", word, " [sic]");
        else
          fprintf(stdout, "%s%s%c", word, " [sic]", c);
      }
      i = 0;
      n = 60;
      free(word);
      free(word2);
      free(word3);
      word = malloc(sizeof(char) * n);
      if (c == EOF){
        free(word);
        break;
      }
    }
  }
}
