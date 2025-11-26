
USE `insight_places`;
DROP procedure IF EXISTS `insight_places`.`novoAluguel_1`;
;

DELIMITER $$
USE `insight_places`$$
CREATE DEFINER=`root`@`%` PROCEDURE `novoAluguel_1`()
BEGIN
    DECLARE varAluguel VARCHAR(10) DEFAULT 1001;
    DECLARE varCliente VARCHAR(10) DEFAULT 1002;
    DECLARE varHospedagem VARCHAR(10) DEFAULT 8635;
    DECLARE varDataInicio DATE DEFAULT '2023-03-01';
    DECLARE varDataFinal DATE DEFAULT '2023-03-05';
    DECLARE varPrecoTotal DECIMAL(10,2) DEFAULT 550.23;

    SELECT varAluguel, varCliente, varHospedagem, varDataInicio, varDataFinal, varPrecoTotal;
END$$

DELIMITER ;
;