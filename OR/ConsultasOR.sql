-- Consultas OR

/*
SELECT REF 
SELECT DEREF 
CONSULTA À VARRAY 
CONSULTA À NESTED TABLE
*/

-- SELECT REF


-- SELECT DEREF
-- Selecionar os clientes que foram no Trem Fantasma
SELECT C.nome AS Nome
FROM tb_brinca B, tb_cliente C
WHERE DEREF(B.cliente).cpf = C.cpf AND
DEREF(B.nome_brinquedo).nome = 'Trem Fantasma';
/

-- O preço do ingresso comprado com 'Desconto de Aniversário'
SELECT DEREF(B.ingresso).valor - DEREF(B.promocao).desconto AS Valor
FROM tb_bilheteria B 
WHERE DEREF(B.promocao).restricao = 'Desconto Aniversário';
/
-- CONSULTA À VARRAY

-- Mostrar nome, cpf e telefones do "Atendente Chefe" (supervisor)
SELECT nome, cpf, T.* 
FROM tb_atendente A, TABLE(A.telefone) T 
WHERE cpf_supervisor IS NULL;
/

-- CONSULTA À NESTED TABLE 

-- Consultar os nomes dos dependentes que foram no Carrocel
SELECT nome FROM TABLE(SELECT B.dependentes FROM tb_brinquedo B WHERE nome = 'Carrocel');
/
--Retorne a quantidade e a idade média dos dependentes de clientes que frequentam o parque e brincam no carrosel
SELECT COUNT(*) AS QTD_DEPENDENTES ,AVG(TRUNC(MONTHS_BETWEEN(SYSDATE, D.data_nascimento)/12)) AS IDADE_MEDIA FROM TABLE (
    SELECT B.dependentes FROM tb_brinquedo B
    WHERE B.nome = 'Carrocel'
) D;

--Exiba as informações de todos os Funcionários do parque
DECLARE 
    CURSOR C_INFO IS
    SELECT VALUE(O) FROM tb_operador O;

	 CURSOR C_INFO2 IS
    SELECT VALUE(A) FROM tb_atendente A;

    V_operador tp_operador;
	V_atendente tp_atendente;
BEGIN
    OPEN C_INFO;
	DBMS_OUTPUT.PUT_LINE('Informações Sobre os Operadores' || CHR(10));
    LOOP
        FETCH C_INFO INTO V_operador;
        EXIT WHEN C_INFO%NOTFOUND;
        V_operador.EXIBIRINFORMACOES();
		DBMS_OUTPUT.PUT_LINE(CHR(10));
        
    END LOOP;
	CLOSE C_INFO;

	OPEN C_INFO2;
	DBMS_OUTPUT.PUT_LINE('Informações Sobre os Atendentes' || CHR(10));
    LOOP
        FETCH C_INFO2 INTO V_atendente;
        EXIT WHEN C_INFO2%NOTFOUND;
        V_atendente.EXIBIRINFORMACOES();
		DBMS_OUTPUT.PUT_LINE(CHR(10));
        
    END LOOP;
	CLOSE C_INFO2;
END;

