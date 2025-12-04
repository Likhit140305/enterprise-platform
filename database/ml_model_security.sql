-- MACHINE LEARNING (ML) - INTRUSION DETECTION
-- Model Training & Prediction Script

-- NOTE: This script assumes the user has the necessary privileges:
-- GRANT CREATE MINING MODEL TO <user>;
-- GRANT CREATE PROCEDURE TO <user>;
-- GRANT CREATE TABLE TO <user>;

-- 1. DATA PREPARATION 
-- In a real scenario, we would split data into TRAIN and TEST sets.
-- For this portfolio, we assume Network_Logs is populated.

CREATE OR REPLACE VIEW vw_train_data AS
SELECT * FROM Network_Logs WHERE MOD(log_id, 5) != 0; -- 80% for training

CREATE OR REPLACE VIEW vw_test_data AS
SELECT * FROM Network_Logs WHERE MOD(log_id, 5) = 0; -- 20% for testing

-- 2. MODEL TRAINING

BEGIN
    -- Drop existing model if it exists
    BEGIN
        DBMS_DATA_MINING.DROP_MODEL('INTRUSION_DETECT_MODEL');
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;

    -- We use a Decision Tree (DT) or Random Forest (RF) for classification
    DELETE FROM user_mining_model_settings WHERE model_name = 'INTRUSION_DETECT_MODEL';
    

    -- Create the Model
    DBMS_DATA_MINING.CREATE_MODEL(
        model_name          => 'INTRUSION_DETECT_MODEL',
        mining_function     => DBMS_DATA_MINING.CLASSIFICATION,
        data_table_name     => 'vw_train_data',
        case_id_column_name => 'log_id',
        target_column_name  => 'label',
        settings_table_name => NULL -- Use defaults
    );
    
    DBMS_OUTPUT.PUT_LINE('Model INTRUSION_DETECT_MODEL created successfully.');
END;
/

-- 3. PREDICTION & ANALYTICS

-- View: Real-time Predictions
-- Shows the probability of a log entry being an attack (label=1)
CREATE OR REPLACE VIEW vw_intrusion_predictions AS
SELECT 
    log_id,
    src_ip,
    dst_ip,
    attack_cat AS actual_category,
    PREDICTION(INTRUSION_DETECT_MODEL USING *) AS predicted_label,
    PREDICTION_PROBABILITY(INTRUSION_DETECT_MODEL, 1 USING *) AS attack_probability
FROM Network_Logs;

-- View: Attack Statistics by Category (for Dashboard)
CREATE OR REPLACE VIEW vw_attack_stats AS
SELECT 
    attack_cat,
    COUNT(*) AS attack_count,
    ROUND(AVG(dbytes), 2) AS avg_data_transfer
FROM Network_Logs
WHERE label = 1
GROUP BY attack_cat
ORDER BY attack_count DESC;

-- View: High Risk IPs (Source IPs with high attack probability)
CREATE OR REPLACE VIEW vw_high_risk_ips AS
SELECT 
    src_ip,
    COUNT(*) as total_logs,
    SUM(CASE WHEN predicted_label = 1 THEN 1 ELSE 0 END) as predicted_attacks
FROM vw_intrusion_predictions
GROUP BY src_ip
HAVING SUM(CASE WHEN predicted_label = 1 THEN 1 ELSE 0 END) > 5;
