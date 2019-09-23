
/*********************************************************/
/* Additional String Functios                            */
/*********************************************************/

#if defined _stringx_included
  #endinput
#endif
#define _stringx_included


/* Removes the first l characters from str */

stock strstrip(str[],chars) {
  new i=chars;
  new l=strlen(str);
  if (i>l) {
    str[0]=0;
  }
  else {
    while(i<=l) {
      str[i-chars]=str[i];
      i++;
    }
  }
}



/* Returns 1 if test is a substring of str starting at position pos */
stock streqindex(str[],test[],pos) {
  new ls = strlen(str);
  new lt = strlen(test);
  new i=0;

  while (i<lt) {
    if (pos+i>=ls) {
      return 0;
    }
    if (str[pos+i] != test[i]) {
      return 0;
    }
    i++;
  }
  return 1;
}

/* Like strsplit, but spliting must be done on a single character instead
 * of a string, and that character can be escaped with another one */
stock strsplitx(str[],separator,escape,...) {

  new pos=0;
  new len=strlen(str);
  new escaped=0;
  new splits=numargs();
  new split=3;
  new splitpos=0;
  new splitlen=0;

  while (split +3 < splits) {
    splitpos=0;
    splitlen= getarg(split+1);

    /* Copy characters from str into the split argument while there is room */
    while ((pos<len) && ((str[pos] != separator) || (escaped==1)) && (splitpos < splitlen-1)) {
      if ((str[pos] == escape) && (escaped==0)) {
        escaped=1;
      }
      else {
        setarg(split,splitpos,str[pos]);
        splitpos++;
        escaped=0;
      }
      pos++;
    }
    setarg(split,splitpos,NULL_CHAR);

    /* If the split output buffer is too small, throw away characters */
    while ((pos<len) && ((str[pos] != separator) || (escaped==1))) {
      if ((str[pos] == escape) && (escaped==0)) {
        escaped=1;
      }
      else {
        escaped=0;
      }
      pos++;
    }

    /* Move to next output argument */
    split=split+2;
    pos++;
  }

  /* Copy remaining characters from the split */
  splitpos=0;
  splitlen= getarg(split+1);

  while ((pos<len) && (splitpos < splitlen-1)) {
    if ((str[pos] == escape) && (escaped==0)) {
      escaped=1;
    }
    else {
      setarg(split,splitpos,str[pos]);
      splitpos++;
      escaped=0;
    }
    pos++;
  }
  setarg(split,splitpos,NULL_CHAR);

  return (split-1)/2+1;
}



/* Removes all characters from str that don't appear in allow */

stock strfilter(str[],allow[]) {
  new c = strlen(str);
  new i = 0;
  new j = 0;
  new p;

  while (i<c) {
    p = index(allow,str[i]);
    if (p>=0) {
      str[j]=str[i];
      j++;
    }
    i++;
  }
  str[j]=0;

  return (i=j);
}



/* returns the length of the longest sequence of characters from allow[]
 * that occurs in str[]. */
stock strseqlen(str[],allow[]) {
  new l=0;
  new i=0;
  new c=strlen(str);
  new res=0;

  for (i=0;i<c;i++) {
    if (index(allow,str[i]) >=0) {
      l++;
    } else {
      if (l>res) {
        res=l;
      }
      l=0;
    }
  }

  if (l>res) {
    res=l;
  }

  return res;
}

