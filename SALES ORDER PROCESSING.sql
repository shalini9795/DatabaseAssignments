									-- SALES ORDER PROCESSING--
	
USE DAC28;
										/* TABLE CREATION*/
CREATE TABLE Branch_mst  
(
	Branch_cd     Char(4)      Primary key,
    Branch_name   Varchar(25)  Not null 
);

CREATE TABLE Mktg_territory_mst  
(
	Area_cd      Char(4)       Primary key,
    Area_name    Varchar(25)   Not null,
    Branch_cd    Char(4)       not null
);

CREATE TABLE Mktg_rep_mst  
(
	Rep_cd      Char(4)        Primary key,
    Rep_name    Varchar(25)    Not null,
    Area_cd     Char(4)        primary key
);

CREATE TABLE Customer_mst  
(
	Cust_cd     Char(4)        Primary key,
	Cust_name   Varchar(25)    Not null
);

CREATE TABLE Product_mst  
(
	Prod_cd        Char(4)     Primary key,
    Prod_name      Varchar(25) Not null,
    Qty_on_hand    Int(6)      Not null,
    Reorder_level  Int(6)      Not null check(Reorder_level < Maximum_level),
    Maximum_level  Int(6)      Not null,
    Booked_qty     Int(6)      check(Booked_qty>0), check(Booked_qty < Qty_on_hand)
);

INSERT INTO Product_mst VALUES('2','LUXD',15,10,20,15);
SELECT * FROM Product_mst;

CREATE TABLE Order_mst  
(
	Branch_cd      Char(4)     Not null,
    Order_no       Int(6),
    Order_dt       Date        Not null,
    Cust_cd        Char(4)     Not null,
    Rep_cd         Char(4)     Not null,
    Order_status   Char(1)     Not null default 'P',
    Valid_upto     Date        Not null check(Valid_upto > Order_dt ),
    Remarks        Varchar(200),
    primary key(Order_no,Branch_cd )
);

CREATE TABLE Order_dtl  
(
	Branch_cd      Char(4)     Not null,
    Order_no       Int(6)      Not null,
    Prod_cd        Char(4)     Not null,
    Qty            Int(3)      Not null check(Qty > 0),
    Rate           Float(6,2)  Not null check(Rate > 0), 
    primary key(Branch_cd, Order_no, Prod_cd)
);


										/* TRIGGER CREATION */
DELIMITER //
CREATE TRIGGER T_Product_mst
BEFORE UPDATE
ON Product_mst FOR EACH ROW  
BEGIN
	    
		INSERT INTO O_Product_mst VALUES(Prod_cd,Prod_name,Qty_on_hand,Booked_qty);
        
END; //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE PRODUCT1()
BEGIN
	DECLARE A CHAR(4);
    DECLARE B VARCHAR(25);
    DECLARE C INT(6);
    DECLARE D INT(6);
    DECLARE X INT(6) default 1;
	DECLARE C1 CURSOR FOR SELECT  Prod_cd, Prod_name, Qty_on_hand, Booked_qty FROM Product_mst;
    OPEN C1;
        WHILE X<3 DO
		FETCH C1 INTO A,B,C,D;
			UPDATE Product_mst 
			SET C =15, D =10
			WHERE A = 1;
            SET X = X+1;
         END WHILE;
	 CLOSE C1;
END; //
DELIMITER ;
DROP PROCEDURE PRODUCT1;
DELETE FROM O_Product_mst ;
CALL PRODUCT1();
SELECT * FROM O_Product_mst ;
CREATE TABLE O_Product_mst 
(
	Prod_cd        Char(4)     Primary key,
    Prod_name      Varchar(25) Not null,
    Qty_on_hand    Int(6)      Not null,
    Booked_qty     Int(6)     
);


DELIMITER //
CREATE TRIGGER T_Product_mst1
BEFORE UPDATE
ON Product_mst FOR EACH ROW  
BEGIN
	    
		INSERT INTO OP VALUES(UPDATED);
        
END; //
DELIMITER ;

CREATE TABLE OP
(
RES varchar(3)
);



delete FROM YUP;

USE DAC28;
SHOW TABLES;
