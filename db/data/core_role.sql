-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: tmp_users
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.10.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES ('Accompagnateur','Community health worker','bc4eaa2a-587c-11d6-861b-0024217bb78e'),('Accompagnateur Leader','Responsible for overseeing up to 30 Accompagnateurs','bc4eacaa-587c-11d6-861b-0024217bb78e'),('Adults','OPD user group for adults entries','bc4eada4-587c-11d6-861b-0024217bb78e'),('Anonymous','Privileges for non-authenticated users.','774b2af3-6437-4e5a-a310-547554c7c65c'),('Authenticated','Privileges gained once authentication has been established.','f7fd42ef-880e-40c5-972d-e4ae7c990de2'),('Clinician','Users who are a part of direct patient care.','bc4eb06a-587c-11d6-861b-0024217bb78e'),('Data Assistant','Clerks who perform data entry.','bc4eb15a-587c-11d6-861b-0024217bb78e'),('Data Element Contributor','Role for users who contribute to the management of data elements in OpenMRS.','bc4eb254-587c-11d6-861b-0024217bb78e'),('Data Manager','User who maintains clinical data stored within the OpenMRS repository.','bc4eb33a-587c-11d6-861b-0024217bb78e'),('Doctor','People in direct care of patient. According to the Malawian context, this is a user who has acquired medical training to level of MBBS.','bc4eb420-587c-11d6-861b-0024217bb78e'),('General Registration Clerk','A General Registration Clerk','bc4ebaba-587c-11d6-861b-0024217bb78e'),('HMIS lab order','OPD user group for HMIS lab order clerk entries','bc4ebbb4-587c-11d6-861b-0024217bb78e'),('Informatics Manager','User who maintains the local installation of the OpenMRS repository.','bc4ebc9a-587c-11d6-861b-0024217bb78e'),('Lab','Lab technicians and assistants','bc4ebd8a-587c-11d6-861b-0024217bb78e'),('Medical Assistant','Medical Assistants','bc4ebe66-587c-11d6-861b-0024217bb78e'),('Nurse','Nursing Officers and Technicians','bc4ebf56-587c-11d6-861b-0024217bb78e'),('Paediatrics','OPD user group for paediatrics entries','bc4ec032-587c-11d6-861b-0024217bb78e'),('Pharmacist','A Pharmacist','bc4ec118-587c-11d6-861b-0024217bb78e'),('Program Manager','Has permission to view most/all data, but no permission for entry or editing.','bc4ec1f4-587c-11d6-861b-0024217bb78e'),('Provider','Health care provider','8d94f280-c2cc-11de-8d13-0010c6dffd0f'),('Registration Clerk','This is a user responsible for registering patients at the patient registration station. mostly used in Baobab applications. This is probably an equivalent of Data Assistant.','bc4ec3c0-587c-11d6-861b-0024217bb78e'),('Social Worker','Social Worker','bc4ec4ba-587c-11d6-861b-0024217bb78e'),('SPINE clinician','OPD user group for SPINE clinician entries','bc4ec5a0-587c-11d6-861b-0024217bb78e'),('Superuser','This is a user who has access to all Baobab developed applications\' functionality','bc4ec686-587c-11d6-861b-0024217bb78e'),('Superuser,Superuser,','Superuser','bc4ec76c-587c-11d6-861b-0024217bb78e'),('System Developer','Developers of the OpenMRS .. have additional access to change fundamental structure of the database model.','8d94f852-c2cc-11de-8d13-0010c6dffd0f'),('Therapeutic Feeding Clerk','A clerk who just enters therapeutic feeding data.','bc4ec942-587c-11d6-861b-0024217bb78e'),('Vitals Clerk','A user who just enters vitals for patients. ','bc4eca32-587c-11d6-861b-0024217bb78e');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-07-18 22:11:23
