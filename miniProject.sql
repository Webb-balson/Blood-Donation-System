-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 20, 2018 at 05:41 AM
-- Server version: 5.7.21
-- PHP Version: 7.0.28-1+ubuntu16.04.1+deb.sury.org+1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `miniProject`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `donor_details1` (IN `id` VARCHAR(20) CHARSET latin1)  NO SQL
select A.FULLNAME, A.GENDER, B.BLOODGROUP
FROM BLOODDONARS A, BLOODGROUPS B
WHERE A.BG_ID=B.BG_ID AND A.AD_ID=id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_contactusQuery` ()  NO SQL
SELECT * FROM CONTACTUSQUERY$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_donars` ()  NO SQL
SELECT BD_ID, AD_ID,FULLNAME,AGE,BLOODGROUPS.BLOODGROUP,Quantity FROM BLOODDONARS,BLOODGROUPS WHERE BLOODDONARS.BG_ID = BLOODGROUPS.BG_ID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_donated_blood` (IN `quantity` INT(10) UNSIGNED, IN `Bgid` INT(10) UNSIGNED)  NO SQL
UPDATE BLOODGROUPS SET Total = Total + quantity where BG_ID = Bgid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_received_blood` (IN `quantity` INT(10) UNSIGNED, IN `Bgid` INT(10) UNSIGNED)  NO SQL
UPDATE BLOODGROUPS SET Total = Total - quantity where BG_ID = Bgid$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ADMIN`
--

CREATE TABLE `ADMIN` (
  `AD_ID` varchar(20) NOT NULL,
  `USERNAME` varchar(100) NOT NULL,
  `PASSWORD` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ADMIN`
--

INSERT INTO `ADMIN` (`AD_ID`, `USERNAME`, `PASSWORD`) VALUES
('AD101', 'AYUSH', 'AYUSHMAN'),
('AD102', 'ADARSH', 'ADA2797GUP');

-- --------------------------------------------------------

--
-- Table structure for table `BLOOD`
--

CREATE TABLE `BLOOD` (
  `BG_ID` varchar(20) NOT NULL,
  `BLOODGROUP` varchar(20) NOT NULL,
  `Total` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `BLOOD`
--

INSERT INTO `BLOOD` (`BG_ID`, `BLOODGROUP`, `Total`) VALUES
('1', 'A+', 250),
('2', 'A-', 200),
('3', 'AB+', 350),
('4', 'AB-', 600),
('5', 'B+', 350),
('6', 'B-', 100),
('7', 'O+', 1000),
('8', 'O-', 500);

-- --------------------------------------------------------

--
-- Table structure for table `BLOODDONARS`
--

CREATE TABLE `BLOODDONARS` (
  `BD_ID` varchar(20) NOT NULL,
  `AD_ID` varchar(20) NOT NULL,
  `FULLNAME` varchar(100) DEFAULT NULL,
  `MOBILENUMBER` char(11) DEFAULT NULL,
  `EMAILID` varchar(100) DEFAULT NULL,
  `GENDER` varchar(20) DEFAULT NULL,
  `AGE` int(11) DEFAULT NULL,
  `BG_ID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `ADDRESS` varchar(255) DEFAULT NULL,
  `POSTINGDATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `BLOODDONARS`
--

INSERT INTO `BLOODDONARS` (`BD_ID`, `AD_ID`, `FULLNAME`, `MOBILENUMBER`, `EMAILID`, `GENDER`, `AGE`, `BG_ID`, `Quantity`, `ADDRESS`, `POSTINGDATE`) VALUES
('BD101', 'AD101', 'Ayush Tomar', '7795112719', 'aayush.starr@gmail.com', 'MALE', 27, 1, 250, 'Address of ayush', '2017-06-30 14:44:16'),
('BD102', 'AD102', 'Adarsh Gupta', '7204997136', 'adarshadg@gmail.com', 'MALE', 24, 2, 150, 'Address of adarsh', '2017-07-01 01:51:21'),
('BD103', 'AD101', 'Ankit Mishra', '9407477408', '1ankitm05@gmail.com', 'MALE', 22, 3, 200, 'Address of ankit', '2017-07-01 03:30:18'),
('BD104', 'AD102', 'Yash Badia', '7411094468', 'yashbadia@gmail.com', 'MALE', 23, 4, 250, 'Address of yash badia', '2017-02-02 14:50:20'),
('BD105', 'AD101', 'Digvijay', '7795271988', 'digvijay@gmail.com', 'MALE', 28, 5, 100, 'Address of digvijay', '2017-07-07 02:51:42'),
('BD106', 'AD101', 'anyname', '7894566547', 'ahjsa@gmail.com', 'male', 22, 7, 100, 'gfghad', '2017-12-05 07:34:18');

--
-- Triggers `BLOODDONARS`
--
DELIMITER $$
CREATE TRIGGER `constraint` BEFORE INSERT ON `BLOODDONARS` FOR EACH ROW BEGIN
IF NEW.BG_ID > 8 || NEW.BG_ID < 1 THEN
INSERT BLOODDONARS (BG_ID)
VALUES (DEFAULT);
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `donar_update` AFTER UPDATE ON `BLOODDONARS` FOR EACH ROW BEGIN
IF NEW.BG_ID != OLD.BG_ID THEN
INSERT update_log(BD_ID,ACTION)
VALUES(OLD.BD_ID, CONCAT('BLOODGROUP CHANGED FROM ', OLD.BG_ID,' TO ', NEW.BG_ID));
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_bloodDonor` AFTER INSERT ON `BLOODDONARS` FOR EACH ROW BEGIN
CALL update_donated_blood(NEW.`Quantity`,NEW.`BG_ID`);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_donated` AFTER INSERT ON `BLOODDONARS` FOR EACH ROW BEGIN
INSERT DONATED (BD_ID,AD_ID,BG_ID, QUANTITY)
VALUES (NEW.BD_ID,NEW.AD_ID,NEW.BG_ID,NEW.Quantity);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `BLOODGROUPS`
--

CREATE TABLE `BLOODGROUPS` (
  `BG_ID` varchar(20) NOT NULL,
  `BLOODGROUP` varchar(20) NOT NULL,
  `Total` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `BLOODGROUPS`
--

INSERT INTO `BLOODGROUPS` (`BG_ID`, `BLOODGROUP`, `Total`) VALUES
('1', 'A+', 700),
('2', 'A-', 350),
('3', 'AB+', 250),
('4', 'AB-', 600),
('5', 'B+', 350),
('6', 'B-', 100),
('7', 'O+', 1200),
('8', 'O-', 500);

--
-- Triggers `BLOODGROUPS`
--
DELIMITER $$
CREATE TRIGGER `check_availability` AFTER INSERT ON `BLOODGROUPS` FOR EACH ROW BEGIN
IF NEW.Total > BLOODRECIEPENT.Quantity THEN
INSERT BLOODGROUPS(Total)
VALUES (DEFAULT);
END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `BLOODRECIEPENT`
--

CREATE TABLE `BLOODRECIEPENT` (
  `BR_ID` varchar(20) NOT NULL,
  `AD_ID` varchar(20) NOT NULL,
  `FULLNAME` varchar(100) NOT NULL,
  `MOBILENUMBER` char(11) NOT NULL,
  `EMAILID` varchar(100) NOT NULL,
  `GENDER` varchar(10) NOT NULL,
  `AGE` int(11) NOT NULL,
  `BG_ID` int(11) NOT NULL,
  `Quantity` int(10) NOT NULL,
  `ADDRESS` varchar(100) NOT NULL,
  `DATETIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `BLOODRECIEPENT`
--

INSERT INTO `BLOODRECIEPENT` (`BR_ID`, `AD_ID`, `FULLNAME`, `MOBILENUMBER`, `EMAILID`, `GENDER`, `AGE`, `BG_ID`, `Quantity`, `ADDRESS`, `DATETIME`) VALUES
('BR101', 'AD101', 'Anshu Agarwal', '7788994455', 'anshu@gmail.com', 'MALE', 20, 1, 250, 'address of anshu', '2017-11-16 13:05:29'),
('BR102', 'AD102', 'Fanoos fathima', '9988775544', 'fanoos@gmail.com', 'Female', 21, 2, 250, 'address of fanoos', '2017-11-16 13:39:38'),
('BR103', 'AD101', 'Akshata kulkarn', '9989784757', 'akshata@gmail.com', 'Female', 21, 3, 100, 'address of akshata', '2017-11-16 13:31:14'),
('BR104', 'AD102', 'Deeksha reddy', '9798787947', 'deeksha@gmail.com', 'Female', 22, 4, 100, 'address of deeksha', '2017-11-16 13:41:11'),
('BR105', 'AD101', 'Austin Emmanuel', '8109877451', 'austin@gmail.com', 'Female', 21, 6, 100, 'Address of austin', '2017-11-16 13:45:58');

--
-- Triggers `BLOODRECIEPENT`
--
DELIMITER $$
CREATE TRIGGER `constraint1` AFTER INSERT ON `BLOODRECIEPENT` FOR EACH ROW BEGIN
IF NEW.BG_ID > 8 || NEW.BG_ID < 1 THEN
INSERT BLOODRECIEPENT (NEW.BG_ID)
VALUES (DEFAULT);
END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_bloodRecipent` AFTER INSERT ON `BLOODRECIEPENT` FOR EACH ROW BEGIN
CALL update_received_blood(NEW.`Quantity`,NEW.`BG_ID`);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_received` AFTER INSERT ON `BLOODRECIEPENT` FOR EACH ROW BEGIN
INSERT RECEIVED (BR_ID,AD_ID,BG_ID, QUANTITY)
VALUES (NEW.BR_ID,NEW.AD_ID,NEW.BG_ID,NEW.Quantity);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `CONTACTUS`
--

CREATE TABLE `CONTACTUS` (
  `CON_ID` varchar(20) NOT NULL,
  `AD_ID` varchar(20) DEFAULT NULL,
  `NAME` varchar(20) DEFAULT NULL,
  `EMAILID` varchar(100) DEFAULT NULL,
  `CONTACTNO` char(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `CONTACTUS`
--

INSERT INTO `CONTACTUS` (`CON_ID`, `AD_ID`, `NAME`, `EMAILID`, `CONTACTNO`) VALUES
('1', 'AD101', 'AYUSH TOMAR', 'AAYUSH.STARR@GMAIL.COM', '7795112719'),
('2', 'AD102', 'ADARSH GUPTA', 'ADARSHADG@GMAIL.COM', '7204997136');

-- --------------------------------------------------------

--
-- Table structure for table `CONTACTUSQUERY`
--

CREATE TABLE `CONTACTUSQUERY` (
  `ID` int(11) NOT NULL,
  `CON_ID` varchar(20) NOT NULL DEFAULT 'AD101',
  `NAME` varchar(100) DEFAULT NULL,
  `EMAILID` varchar(120) DEFAULT NULL,
  `CONTACTNUMBER` char(11) DEFAULT NULL,
  `MESSAGE` varchar(255) DEFAULT NULL,
  `POSTINGDATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `CONTACTUSQUERY`
--

INSERT INTO `CONTACTUSQUERY` (`ID`, `CON_ID`, `NAME`, `EMAILID`, `CONTACTNUMBER`, `MESSAGE`, `POSTINGDATE`) VALUES
(1, '1', 'Ankit', '1ankitm05@gmail.com', '1122334455', 'This is ankit\'s query', '2017-11-03 03:26:07'),
(2, '2', 'Digvijay', 'digvijay@gmail.com', '7788994455', 'This is digvijays\'s query', '2017-11-02 20:39:39'),
(3, '2', 'Anshuman', 'anshuman@gmail.com', '5566441122', 'This is anshuman\'s query', '2017-11-02 20:41:53'),
(4, '1', 'Ayush Tomar', 'abc@gmail.com', '9425967815', 'This is my query', '2017-11-30 15:52:31');

-- --------------------------------------------------------

--
-- Table structure for table `DONATED`
--

CREATE TABLE `DONATED` (
  `BD_ID` varchar(10) NOT NULL,
  `AD_ID` varchar(10) NOT NULL,
  `BG_ID` int(10) NOT NULL,
  `QUANTITY` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `DONATED`
--

INSERT INTO `DONATED` (`BD_ID`, `AD_ID`, `BG_ID`, `QUANTITY`) VALUES
('', '', 0, 0),
('', '', 0, 0),
('BD107', 'AD101', 8, 250),
('BD234', 'AD101', 2, 100),
('BR105', 'AD102', 2, 200),
('BD209', 'AD101', 4, 500),
('BD201', 'AD101', 1, 100),
('BD405', 'AD101', 2, 100),
('BD410', 'AD105', 2, 100),
('', 'AD102', 4, 422),
('BD110', 'AD101', 7, 100),
('BD106', 'AD101', 1, 250),
('BD106', 'AD101', 1, 100),
('BD107', 'AD101', 1, 100),
('BD107', 'AD101', 2, 250),
('BD106', 'AD101', 8, 100),
('BD106', 'AD101', 7, 100);

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_details`
--
CREATE TABLE `get_details` (
`BD_ID` varchar(20)
,`AD_ID` varchar(20)
,`FULLNAME` varchar(100)
,`AGE` int(11)
,`BLOODGROUP` varchar(20)
,`Quantity` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `get_details_name`
--
CREATE TABLE `get_details_name` (
`FULLNAME` varchar(100)
,`ADDRESS` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `RECEIVED`
--

CREATE TABLE `RECEIVED` (
  `BR_ID` varchar(20) NOT NULL,
  `AD_ID` varchar(20) NOT NULL,
  `BG_ID` int(10) NOT NULL,
  `QUANTITY` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `RECEIVED`
--

INSERT INTO `RECEIVED` (`BR_ID`, `AD_ID`, `BG_ID`, `QUANTITY`) VALUES
('BR107', 'AD101', 2, 10),
('BR110', 'AD101', 2, 100),
('BR104', 'AD101', 2, 100),
('BR106', 'AD101', 3, 100),
('BR106', 'AD101', 8, 100);

-- --------------------------------------------------------

--
-- Table structure for table `update_log`
--

CREATE TABLE `update_log` (
  `BD_ID` varchar(20) NOT NULL,
  `UPDATED` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ACTION` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `update_log`
--

INSERT INTO `update_log` (`BD_ID`, `UPDATED`, `ACTION`) VALUES
('', '2017-11-13 19:52:05', 'BLOODGROUP IS CHANGED FROM1TO 6ON BD_IDBD101'),
('', '2017-11-13 20:00:23', 'BLOODGROUP IS CHANGED FROM6TO 1ON BD_IDBD101'),
('BD101', '2017-11-13 20:00:23', 'BLOODGROUP CHANGED FROM 6 TO 1'),
('BD108', '2017-11-14 09:35:27', 'BLOODGROUP CHANGED FROM 4 TO 5'),
('', '2017-11-14 09:35:27', 'BLOODGROUP IS CHANGED FROM4TO 5ON BD_IDBD108');

-- --------------------------------------------------------

--
-- Structure for view `get_details`
--
DROP TABLE IF EXISTS `get_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_details`  AS  select `BLOODDONARS`.`BD_ID` AS `BD_ID`,`BLOODDONARS`.`AD_ID` AS `AD_ID`,`BLOODDONARS`.`FULLNAME` AS `FULLNAME`,`BLOODDONARS`.`AGE` AS `AGE`,`BLOODGROUPS`.`BLOODGROUP` AS `BLOODGROUP`,`BLOODDONARS`.`Quantity` AS `Quantity` from (`BLOODDONARS` join `BLOODGROUPS`) where (`BLOODDONARS`.`BG_ID` = `BLOODGROUPS`.`BG_ID`) ;

-- --------------------------------------------------------

--
-- Structure for view `get_details_name`
--
DROP TABLE IF EXISTS `get_details_name`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `get_details_name`  AS  select `BLOODDONARS`.`FULLNAME` AS `FULLNAME`,`BLOODDONARS`.`ADDRESS` AS `ADDRESS` from `BLOODDONARS` group by `BLOODDONARS`.`FULLNAME`,`BLOODDONARS`.`ADDRESS` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ADMIN`
--
ALTER TABLE `ADMIN`
  ADD PRIMARY KEY (`AD_ID`);

--
-- Indexes for table `BLOOD`
--
ALTER TABLE `BLOOD`
  ADD PRIMARY KEY (`BG_ID`);

--
-- Indexes for table `BLOODDONARS`
--
ALTER TABLE `BLOODDONARS`
  ADD PRIMARY KEY (`BD_ID`);

--
-- Indexes for table `BLOODGROUPS`
--
ALTER TABLE `BLOODGROUPS`
  ADD PRIMARY KEY (`BG_ID`);

--
-- Indexes for table `BLOODRECIEPENT`
--
ALTER TABLE `BLOODRECIEPENT`
  ADD PRIMARY KEY (`BR_ID`);

--
-- Indexes for table `CONTACTUS`
--
ALTER TABLE `CONTACTUS`
  ADD PRIMARY KEY (`CON_ID`);

--
-- Indexes for table `CONTACTUSQUERY`
--
ALTER TABLE `CONTACTUSQUERY`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `CONTACTUSQUERY`
--
ALTER TABLE `CONTACTUSQUERY`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
