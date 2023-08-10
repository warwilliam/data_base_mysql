CREATE SCHEMA dhemprestimos;
USE dhemprestimos;
--
-- Table structure for table `scoring`
--

DROP TABLE IF EXISTS `scoring`;

CREATE TABLE `scoring` (
  `idScoring` int NOT NULL AUTO_INCREMENT,
  `risco` varchar(45) DEFAULT NULL,
  `maxLimite` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`idScoring`)
) ;

--
-- Dumping data for table `scoring`
--

INSERT INTO `scoring` (risco, maxLimite) VALUES ('inicial',10000.00), ('alto',30000.00), ('medio',100000.00), ('baixo',500000.00);


--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;

CREATE TABLE `clientes` (
  `idclientes` int NOT NULL AUTO_INCREMENT,
  `rg` varchar(10) DEFAULT NULL,
  `sobrenome` varchar(45) DEFAULT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `data_nasc` date DEFAULT NULL,
  `Scoring_idScoring` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idclientes`,`Scoring_idScoring`),
  KEY `fk_clientes_Scoring_idx` (`Scoring_idScoring`),
  CONSTRAINT `fk_clientes_Scoring` FOREIGN KEY (`Scoring_idScoring`) REFERENCES `scoring` (`idScoring`)
);

--
-- Dumping data for table `clientes`
--

INSERT INTO `clientes` (rg, sobrenome, nome, data_nasc, Scoring_idScoring) VALUES ('101','Gomez','Alberto','1976-01-01',1);
