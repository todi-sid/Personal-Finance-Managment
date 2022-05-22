Drop database FinanceManagement; #Database deletion, if any such database exist beforehand, so that fresh creation can take place
Create Database FinanceManagement; #Database Creation
Show Databases;
Use FinanceManagement;
Select database();
show tables;

#Table Creation Begins
#users table will contain the details of all the user using this Personal Finance Management Application
Create Table users(
userID int Unsigned NOT NULL Auto_Increment,
name Varchar(50) NOT NULL Default ' ',
phoneNo Varchar(12) NOT NULL,
gender Varchar(1) NOT NULL,
birth_date DATE NOT NULL,
primary key(userID)
);

#Universal Bank List will contain the list of all the Bank Names
Create Table universalBankList(
BankID int Unsigned NOT NULL Auto_Increment,
BankName Varchar(50) NOT NULL Default ' ',
primary key(BankID)
);

#BankAccounts will contains the details of each individual's bank accounts details
Create Table BankAccounts(
userID int Unsigned NOT NULL,
BankID int Unsigned NOT NULL,
AccountNumber Varchar(14) NOT NULL,
Balance int,
Foreign Key(userID) references users(userID),
Foreign Key(BankID) references universalBankList(BankID),
primary key(userID,BankID,AccountNumber)
);

#BankTransactions will contain details about the transactions between Bank and Wallet, and also about depositing cash to bank account
Create Table BankTransactions(
userID int Unsigned NOT NULL,
BankID int Unsigned NOT NULL,
AccountNumber Varchar(14) NOT NULL,
transactionID int Unsigned NOT NULL Auto_Increment,
amount int,
transactionTime DATETIME NOT NULL,
Foreign key(userID,BankID,AccountNumber) references BankAccounts(userID,BankID,AccountNumber),
primary key(transactionID)
);

#Categories contains a list of names of all category, where expenditure can be made from wallet
Create Table Categories(
categoryID int unsigned NOT NULL Auto_Increment,
name varchar(50) NOT NULL Default ' ',
primary key(categoryID)
);

#Wallet keeps a track of each individual's wallet and the transaction made to and from the wallet
Create Table Wallet(
userID int Unsigned NOT NULL,
walletTransactionID int Unsigned NOT NULL Auto_Increment,
Amount int,
categoryID int unsigned NOT NULL,
walletTransactionTime DATETime NOT NULL,
Foreign key(userID) references users(userID),
Foreign key(categoryID) references Categories(categoryID),
Primary key(walletTransactionID)
);

#CategoryExpenditure keeps track of each individual's expenditure under each category mentioned in the Categories table
Create Table CategoryExpenditure(
userID int unsigned NOT NULL,
categoryID int unsigned NOT NULL,
categoryExpenditureID int unsigned NOT NULL Auto_Increment,
amount int,
Foreign key(userID) references users(userID),
Foreign key(categoryID) references Categories(categoryID),
primary key(categoryExpenditureID)
);

#adding data in Universal Bank List
insert into FinanceManagement.UniversalBankList(BankName)
values("HDFC Bank");
insert into FinanceManagement.UniversalBankList(BankName)
values("Axis Bank"),("ICICI Bank"),("SBI Bank"),("PNB Bank"),("Allahabad Bank"),("Yes Bank"),("Kotak Mahindra Bank"),("Induslnd Bank");

#adding categories
insert into FinanceManagement.Categories(name)
Values ("Eating Out"),("Shopping"),("Travel"),("Eating Out"),("Entertainment"),("Sports"),("Others");
insert into FinanceManagement.Categories(name)
Values ("Wallet Recharge");
insert into FinanceManagement.Categories(name)
Values("Initital user Creation");
insert into FinanceManagement.Categories(name)
Values("Wallet to Bank");
update FinanceManagement.Categories
set name="Investment" where categoryID=4;

#user creation
Insert into FinanceManagement.users(userID,name,phoneNo,gender,birth_date)
values (1,"Siddarth Todi", "919064412959","M","2000-10-14");
Insert into FinanceManagement.users(name,phoneNo,gender,birth_date)
values ("Nikunj", "919064415929","M","2001-01-14");
insert into FinanceManagement.Wallet(userID,Amount,categoryID,walletTransactionTime) #wallet initialization with Balance as Rs 0
values(1,0,9,"2022-04-11 21:09:06"),(2,0,9,"2022-04-11 21:10:56");

#creating bank accounts
insert into FinanceManagement.BankAccounts(userID,bankID,AccountNumber,Balance)
Values (1,1,99999999999999,1500),(1,2,99999999999998,5100),(1,1,99999999999997,100),(1,4,99999999999996,500),(2,9,99999999999995,34000),(2,8,99999999999994,2500);

#Show tables;
#Select * from <TableName>;

#drop database FinanceManagement