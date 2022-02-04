#This loops through the letters of the alphbet

for(i in 1:nrow(letters)){
  print(letters[i,1])
}

#prints out each individual letter of each word
count <- 0
for(j in 1:nrow(Words)){
  string_split <- strsplit(Words[j,1],"")[[1]]
  count <- 0
  for (i in string_split) {
    count <- count + 1
    for(x in 1:nrow(letters)){
      if(i == letters[x,1]){
        Results[x,7] <- Results[x,7] + 1
        Results[x, count +1] <- Results[x, count +1] +1
        break
      }
        
    }
  }
}


Results[2,3] <- 0

Results[2] <- 0
Results[3] <- 0
Results[4] <- 0
Results[5] <- 0
Results[6] <- 0
Results[7] <- 0