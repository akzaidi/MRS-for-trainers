#################################
#### R Lab One -- Data Types ####
#################################


# R Primitives ------------------------------------------------------------

# use the `typeof` function to explore the type of various objects

random_norms <- rnorm(100)
typeof(random_norms)

some_letters <- letters[1:10]
typeof(some_letters)

int_vector <- c(1L, 2L, 3L)
typeof(int_vector)

booleans <- int_vector == 1
typeof(booleans)



## can you mix types in a vector?

combine_char_num <- c(random_norms, some_letters)
typeof(combine_char_num)



# R data structures -------------------------------------------------------

## to combine types, make list

list_char_num <- list(nums = random_norms, chars = some_letters)
typeof(list_char_num)
lapply(list_char_num, typeof)


## matrices, same length, same type

matrix_num <- matrix(rnorm(10), nrow = 5, ncol = 2)
# reuse
matrix_num_reuse <- matrix(rnorm(11), nrow = 6, ncol = 4)

## matricescan't have different types

## data.frames can

df_char_num <- data.frame(chars = letters[1:10], nums = rnorm(10))
lapply(df_char_num, typeof)

## data.frames must have same length in each column
df_char_num <- data.frame(chars = letters[1:8], nums = rnorm(10))


############################################
########### Helpful Functions ##############
############################################

# see your workspace
ls()

# remove object from workspace
rm(some_letters)

# check working directory, change directory
getwd()
setwd(getwd())

# create a sequence of numbers
1:10
seq(1, 10)
seq(1, 10, 2)

# get help
?seq
help(seq)




