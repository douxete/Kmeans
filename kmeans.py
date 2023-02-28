import numpy as np
import mysql.connector
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="dbkmeans"
)

mycursor = mydb.cursor()

# get the x data
mycursor.execute("SELECT spending from tblData")

spendingQuerry = mycursor.fetchall()
spending = [row[0] for row in spendingQuerry]

x = np.empty(shape=[len(spending)], dtype=int)

for i,hours in enumerate(spending):
    x[i]=hours

# get the y data
mycursor.execute("SELECT income from tblData")

incomeQuerry = mycursor.fetchall()
income = [row[0] for row in incomeQuerry]

y = np.empty(shape=[len(income)], dtype=int)

for i,test in enumerate(income):
    y[i]=test

print(x,y)

# Visualizing the data 

plt.scatter(x,y)
plt.show()

# Visualize using elbow method

data = list(zip(x,y))
inertias = []

for i in range(1,11):
    kmeans = KMeans(n_clusters=i)
    kmeans.fit(data)
    inertias.append(kmeans.inertia_)

plt.plot(range(1,11), inertias, marker='o')
plt.title('Elbow Method')
plt.xlabel('Number of Clusters')
plt.ylabel('Inertia')
plt.show()


kmeans = KMeans(n_clusters=2)
kmeans.fit(data)

plt.scatter(x, y, c=kmeans.labels_)
plt.show()