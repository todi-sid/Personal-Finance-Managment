#execution code of procedure addingMoney
DELIMITER $$
Create Procedure walletRecharge(in useID int unsigned,BanID int unsigned,AccNo Varchar(14),amoun int,transactioTime DATETIME)
BEGIN
insert into BankTransactions(userID,BankID,AccountNumber,amount,transactionTime)  #reflecting in bank transactions
values (useID,BanID,AccNo,-1*amoun,transactioTime);
update FinanceManagement.BankAccounts            #reflecting in bank accounts
set balance=balance-amoun
where userID=useID and BankID=BanID and AccountNumber=AccNo;
insert into Wallet(userID,amount,categoryID,walletTransactionTime) #reflecting in wallet
values (useID,amoun,8,transactioTime);
insert into FinanceManagement.CategoryExpenditure(userID,categoryID,amount) #reflecting in category expenditure
Values (useID,8,amoun);
END $$
DELIMITER ;	

#execution code of procedure addingMoney 
DELIMITER $$
Create procedure addingMoney(in useID int unsigned,BanID int unsigned,AccNo Varchar(14),amoun int,transactioTime DATETIME)
BEGIN
insert into FinanceManagement.BankTransactions(userID,BankID,AccountNumber,amount,transactionTime)  #reflecting in bank transactions
values (useID,BanID,AccNo,amoun,transactioTime);
update FinanceManagement.BankAccounts            #reflecting in bank accounts
set balance=balance+amoun
where userID=useID and BankID=BanID and AccountNumber=AccNo;
END$$
DELIMITER ;

use FinanceManagement;

#execution code for the procedure SpendMoney
DELIMITER $$
Create procedure SpendMoney(in useID int unsigned,amoun int,categorID int unsigned,walletTransactioTime DATETIME)
BEGIN
insert into FinanceManagement.wallet(userID,amount,categoryID,walletTransactionTime)     #reflecting in wallet
Values(useID,-1*amoun,categorID,walletTransactioTime);
insert into FinanceManagement.CategoryExpenditure(userID,categoryID,amount)       #reflecting in corresponding category
Values(useID,categorID,amoun);
END $$
DELIMITER ;

#execution code of BalanceCheck procedure
delimiter $$
create procedure BalanceCheck (in ID int, out balance_left int)
begin
select sum(amount) as balance_left from financemanagement.wallet
where userID=ID;
end $$
delimiter ;

#code execution of the procedure walletToBank
DELIMITER $$
Create procedure walletToBank(in useID int,amoun int,walletTransactioTime DATETIME,BanID int,AccNo Varchar(40))
BEGIN
insert into FinanceManagement.wallet(userID,amount,categoryID,walletTransactionTime)                 #reflecting in wallet
Values(useID,-1*amoun,10,walletTransactioTime);
insert into FinanceManagement.BankTransactions(userID,BankID,AccountNumber,amount,transactionTime)  #reflecting in bank transactions
values (useID,BanID,AccNo,amoun,walletTransactioTime);
update FinanceManagement.BankAccounts                             #reflecting in bank accounts
set Balance=Balance+amoun
where userID=useID and BankID=banID and AccountNumber=AccNo;
insert into FinanceManagement.CategoryExpenditure(userID,categoryID,amount)       #reflecting in corresponding category
Values(useID,10,amoun);
END $$
DELIMITER ;

#Execution code of the procedure BankTransfers
Delimiter $$
create procedure BankTransfers(in useID int,BanID int,AccNo varchar(14),amoun int,transactioTime DATETIME,useID2 int,BanID2 int,AccNo2 varchar(14))
BEGIN
insert into FinanceManagement.BankTransactions(userID,BankID,AccountNumber,amount,transactionTime)  #reflecting in bank transactions
values (useID,BanID,AccNo,-1*amoun,transactioTime), #adding transaction for the user who is sending money
(useID2,BanID2,AccNo2,amoun,transactioTime);  #adding transaction for the user who is receiving money
update FinanceManagement.BankAccounts                             #reflecting in the bank account from which money is been debited
set Balance=Balance-amoun
where userID=useID and BankID=BanID and AccountNumber=AccNo;
update FinanceManagement.BankAccounts                             #reflecting in the bank account into which money is been credited
set Balance=Balance+amoun
where userID=useID2 and BankID=BanID2 and AccountNumber=AccNo2;
END $$
DELIMITER ;


#Execution code for the procedure weeklyExpenses
DELIMITER $$
Create procedure weeklyExpenditure(in startDateTime DATETIME,endDateTime DATETIME,useID int,out weekly_amount int)
BEGIN
select -1*sum(amount) as expenditure from FinanceManagement.Wallet
where userID=useID and CategoryID NOT IN (8,10) and walletTransactionTime BETWEEN startDateTime AND endDateTime;
END $$
DELIMITER ;

#display username-category name-total amount spent
select users.name AS UserName,Categories.name As CategoryName,sum(CategoryExpenditure.amount) AS Amount
from CategoryExpenditure
Right Join 
Categories
ON CategoryExpenditure.categoryID=Categories.categoryID
Right Join users
ON CategoryExpenditure.userID=users.userID
where CategoryExpenditure.categoryID not in (8,10)
Group by users.name,Categories.name;

#walletRecharge is a procedure to add money to wallet from Bank Accounts
#walletRecharge(userID,BankID,AccountNumber,Amount,Transaction)
CALL walletRecharge(1,2,99999999999998,350,"2022-04-13 16:01:56"); #Recharging 1's wallet by Rs 350 from 1's bank account having BankID=2 and AccountNumber=99999999999998

#addingMoney is a procedure to diposit money directly to one's account
#addingMoney(userID,BankID,AccountNumber,Amount,TransactionTime)
call addingMoney(2,9,99999999999995,1001,"2022-04-13 15:40:00"); #Adding money to 2's Bank Account having BankID=9 and AccountNumber=99999999999995 , amount =Rs1001

#SpendMoney is a procedure to spend money on any of the categories from the wallet
#SpendMoney(userID,Amount,CategoryID,walletTransactionTime)
call SpendMoney(1,100,1,"2022-04-13 16:20:00");        #Spending Rs100 from 1's wallet on Eating out on 2022-04-12 20:43:45
call SpendMoney(1,36,1,"2022-4-19 07:30:40");         #Spending Rs36 from 1's wallet on Eating out on 2022-04-19 07:30:40

#BalanceCheck is a procedure to check balance in an individual's wallet
#BalanceCheck(userID,@Balance)
call BalanceCheck(1,@balance_left);   #Calculating Balance in 1's wallet

#walletToBank is a procedure to send money back from wallet to any of the bank accounts of the same user
#walletToBank(userID,Amount,TransactionTime,BankID,AccountNumber)
call walletToBank(1,125,"2022-04-13 17:05:23",1,99999999999999); #Depositing Rs 125 from 1's wallet to its bank account with BankID=1 and AccountNumber=99999999999999

#BankTransfers is a procedure to facilitate transfer of many from one bank account to second bank account
#BankTransfers(userID1,BankID1,AccountNumber1,Amount,TransactionTime,userID2,BankID2,AccountNumber2) 
#where userID1 is the id of the person who is sending money and userID2 is the id of the person recieving the money
call BankTransfers(1,4,99999999999996,99,"2022-04-13 16:49:49",2,8,99999999999994); #Transfering Rs 1's Bank Account(BankID=4 and AccountNumber=99999999999996) to 2's Bank Account(BankID= 8 and AccountNumber=99999999999994)

#weeklyExpenditure is a procedure to calculate the weekly expenses of a user
#weeklyExpenditure(startDateTime,endDateTime,userID,@weekly_amount)
call weeklyExpenditure("2022-04-10 00:00:00","2022-04-17 23:59:59",1,@weekly_amount); #weekly expenditure of 1 from 2022-04-10 00:00:00 to 2022-04-17 23:59:59
