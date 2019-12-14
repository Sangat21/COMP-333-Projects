import random

# MATRIX CLASS


class Matrix:
    def __init__(self, row, col):
        self.row = row
        self.col = col
        self.elements = [
            [((int)(random.random()*100)) for i in range(col)]
            for j in range(row)]
    # Print Matrix

    def printMatrix(self):
        for i in range(self.row):
            for j in range(self.col):
                print(self.elements[i][j], end='')
                print(" ", end='')
            print("\n")

    # Validate addition, Subtraction, or Hadamard Product Operation
    def validateAddSubHad(self, otherMtx):
        if((self.row == otherMtx.row) and (self.col == otherMtx.col)):
            return True
        else:
            return False

    # Validate Dot product Operation
    def validateDot(self, otherMtx):
        if (self.col == otherMtx.row):
            return True
        else:
            return False

    # Add Operation
    def add(self, otherMtx):
        for i in range(self.row):
            for j in range(self.col):
                self.elements[i][j] = self.elements[i][j] + \
                    otherMtx.elements[i][j]
        return self

    # Subtract Operation
    def sub(self, otherMtx):
        for i in range(self.row):
            for j in range(self.col):
                self.elements[i][j] = self.elements[i][j] - \
                    otherMtx.elements[i][j]
        return self

    # Dot Product Operation
    def dot(self, otherMtx):
        # return self
        # initializing empty result matrice
        result = Matrix(self.row, otherMtx.col)
        # EMPTY THE result ARRAY
        for i in range(result.row):
            for j in range(result.col):
                result.elements[i][j] = 0

        # FILL IN THE result ARRAY
        # iterating by row of self
        for i in range(self.row):

            # iterating by coloum by other
            for j in range(otherMtx.col):

                # iterating by rows of other
                for k in range(self.col):
                    result.elements[i][j] += self.elements[i][k] * otherMtx.elements[k][j]

        return result

    # Hadamard Product Operation
    def hadamard(self, otherMtx):
        for i in range(self.row):
            for j in range(self.col):
                self.elements[i][j] = self.elements[i][j] * \
                    otherMtx.elements[i][j]
        return self

# GET MATRIX


def getMatrix(s):
    print("Enter number of rows for", s)
    row = int(input("Rows: "))
    print("Enter number of columns for", s)
    col = int(input("Col: "))
    return Matrix(row, col)

# GET OPERATION


def getOp():
    print("\n\nWhat Operation would you like to perform?")
    print("1. Add \n2. Subtract \n3. Dot Product \n4. Hadamard Product")
    selection = int(input("\nSelection: "))
    if (selection < 1 or selection > 4):
        print("Pick a valid Op!")
        getOp()
    else:
        return selection

# Check if Valid Operation


def isValidOp(selection, m1, m2):
    if selection == 3:
        if not(m1.validateDot(m2)):
            return False
        else:
            return True
    else:
        if not(m1.validateAddSubHad(m2)):
            return False
        else:
            return True


# CALCULATE MATRIX
def calculateMatrix(selection, m1, m2):

    if selection == 1:
        return m1.add(m2)
    elif selection == 2:
        return m1.sub(m2)
    elif selection == 3:
        return m1.dot(m2)
    else:
        return m1.hadamard(m2)


def doMatrixOp():
    # get Matrix 1
    m1 = getMatrix("Matrix 1")
    print("\nMatrix 1: ")
    m1.printMatrix()
    # get Matrix 2
    m2 = getMatrix("Matrix 2")
    print("\nMatrix 2: ")
    m2.printMatrix()

    # get selection
    selection = getOp()

    # check if selection is valid
    if(isValidOp(selection, m1, m2)):
        # find & print Matrix 3
        m3 = calculateMatrix(selection, m1, m2)
        m3.printMatrix()
    else:
        # Op can't be done
        print("INVALID OPERATION! Can't be done from given matrices")


# RUN EVERYTHING
doMatrixOp()
