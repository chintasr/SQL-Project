drop database if exists library;

create database library;

use library;

create table tbl_publisher(
publisher_publisherName varchar(255) primary key,
publisher_publisherAddress varchar(255),
publisher_publisherPhone varchar(225));

select * from tbl_publisher;


create table tbl_borrower(
borrower_cardNo int primary key auto_increment,
borrower_Name varchar(255),
borrower_address varchar(255),
borrower_phone varchar(225))auto_increment = 100;


select * from tbl_borrower;


create table tbl_library_branch(
library_branch_BranchID INT primary key NOT NULL,
library_branch_BranchName varchar(255) NOT NULL,
library_branch_BranchAddress varchar(255) NOT NULL);


select * from tbl_library_branch;



create table tbl_book(
book_BookID int primary key,
book_title varchar(255),
book_publisherName varchar(255),
foreign key (book_publisherName)
references tbl_publisher(publisher_publisherName) on delete cascade);


select * from tbl_book;



create table table_book_authors(
book_authors_bookID int,
book_authors_authorName varchar(255),
foreign key (book_authors_bookID)
references tbl_book(book_BookID) on delete cascade)auto_increment = 101;

select * from table_book_authors;


create table table_book_loans(
book_loans_BookID int,
book_loans_BranchId int,
book_loans_CardNo int,
book_loans_Dateout Date,
book_loans_Duedate date,
foreign key (book_loans_CardNo)
references tbl_borrower(borrower_cardNO) on delete cascade,
foreign key (book_loans_BranchId)
references tbl_library_branch(library_branch_branchID) on delete cascade,
foreign key (book_loans_BookID)
references tbl_book(book_BookId) on delete cascade);

select * from table_book_loans;

create table tbl_book_copies(
book_copies_BookID int,
book_copies_BranchID int,
book_copies_No_of_copies int,
foreign key (book_copies_BookID)
references tbl_book(book_bookID) on delete cascade,
foreign key (book_copies_BranchID)
references tbl_library_branch(library_branch_BranchID) on delete cascade);

select * from tbl_book_copies;


-- QUESTIONS

-- 1.How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

select book_copies_no_of_copies as total_copies from tbl_book b
join tbl_book_copies c
on  b.book_BookID = c.book_copies_BookID
join tbl_library_branch l
on c.book_copies_BranchID = l.library_branch_BranchID
where book_title = "The Lost Tribe" and library_branch_branchName = "Sharpstown";


-- 2.How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select book_copies_No_of_copies as copies,library_branch_branchName as library_branch,book_title from tbl_book b
join tbl_book_copies c
on  b.book_BookID = c.book_copies_BookID
join tbl_library_branch l
on c.book_copies_BranchID = l.library_branch_BranchID
where book_title = "The Lost Tribe";

-- 3.Retrieve the names of all borrowers who do not have any books checked out.

select borrower_name from tbl_borrower b
left join table_book_loans l
on b.borrower_cardNo = l.book_loans_cardNo
where book_loans_bookID IS NULL;

-- 4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18,
-- retrieve the book title, the borrower's name, and the borrower's address. 

select * from table_book_loans where book_loans_duedate = '2018-03-02' ;

select b.borrower_Name,b.borrower_address,tb.book_title from tbl_borrower b
join table_book_loans l
on b.borrower_cardNo = l.book_loans_cardNO
join tbl_library_branch lb
on l.book_loans_branchID = lb.library_branch_branchID
join tbl_book tb
on tb.book_bookID = l.book_loans_bookID
where library_branch_branchName = "Sharpstown" and book_loans_Duedate = '2018-03-02';


-- 5.For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select library_branch_branchName,count(book_loans_bookID) from tbl_library_branch lb
join table_book_loans tl
on tl.book_loans_branchID = lb.library_branch_branchID
group by library_branch_branchName;

-- 6.Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.

select b.borrower_Name,b.borrower_address,count(book_bookid) as books_count from tbl_borrower b
join table_book_loans bl
on b.borrower_cardNo = bl.book_loans_cardNo
join tbl_book tb
on bl.book_loans_bookID = tb.book_BookID
group by b.borrower_Name,b.borrower_address
having books_count > 5 order by books_count desc;

-- 7.For each book authored by "Stephen King", retrieve the title and the number of copies owned 
-- by the library branch whose name is "Central".

select book_title,book_copies_no_of_copies as no_of_copies from tbl_book b
join table_book_authors a
on a.book_authors_bookID = b.book_BookID
join tbl_book_copies c
on c.book_copies_bookID = b.book_BookID
join tbl_library_branch lb
on c.book_copies_branchID = lb.library_branch_branchID
where book_authors_authorName = "Stephen King" and library_branch_branchName = "Central" ;



