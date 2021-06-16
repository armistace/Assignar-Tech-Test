-- Load Order Facts
-- CREATE TABLE?
SELECT o.id as order_id,
    o.active,
    o.job_number,
    o.po_number,
    o.client_id,
    o.project_id,
    o.job_description,
    o.start_date,
    o.end_date,
    o.modified_time,
    right(o.status_id, 1) as LATEST_STATUS_ID,
    CASE
        WHEN s.status_name IS NOT NULL THEN s.status_name
        ELSE "UNKNOWN STATUS"
    END as status_name,
    supplier_id,
    user_id
FROM ffa_order o
    LEFT JOIN ffa_order_status s ON right(o.status_id, 1) = s.status_id

--Load Client Dimension
SELECT * FROM ffa_client

--Load project dimension
SELECT * FROM ffa_project 

--Load Project Hiearchy
--Do this in python need to work it out recursively
CREATE OR REPLACE TABLE prd_star.prd_star.H_PROJECT (SELECT l0.project_id as project_L0                                     
        ,CASE
            WHEN l0.parent_id = 0 THEN 0
            ELSE l1.project_id                                     
        END AS project_L1                                     
        ,CASE                                         
        WHEN l1.parent_id = 0 THEN 0                                         
        ELSE l2.project_id                                     
        END AS project_L2                                    
         ,CASE                                         
         WHEN l2.parent_id = 0 THEN 0                                         
         ELSE l3.project_id                                     
         END AS project_L3 
         FROM ffa_project l0                                        
         LEFT JOIN                                            
         (SELECT project_id                                             
         FROM prd_demo.ffa_project                                            
         WHERE parent_id in (380, 382, 383, 393, 394, 425, 426, 427, 517, 533, 552, 566, 
         567, 571, 572, 573, 591, 592, 601, 609, 613, 615, 626, 640, 661, 663, 664, 665, 
         666, 667, 12402, 12440, 12496, 12497, 12505, 12506, 12507, 12529, 12539, 12553)                                        
         ) l1                                         
         ON l0.parent_id = l1.project_id                                        
         LEFT JOIN                                            
         (SELECT project_id                                             
         FROM prd_demo.ffa_project                                            
         WHERE parent_id in (394, 533, 567, 12507)                                        
         ) l2                                         
         ON l1.parent_id = l2.project_id                                        
         LEFT JOIN                                            
         (SELECT project_id                                             
         FROM prd_demo.ffa_project                                            
         WHERE parent_id in (12507)                                        
         ) l3                                         
         ON l2.parent_id = l3.project_id

--Supplier clearly needs SCD type 2 (date modified etc) but not not now   

SELECT
    id as supplier_id,
    city,
    postcode,
    state,
    comments,
    external_id,
    active,
    date_added,
    date_modified,
    modified_time
from ffa_suppliers

--User 
SELECT 
    u.user_id,
    u.ut_id as user_type_id,
    ut.label as user_type,
    u.suburb,
    u.state,
    u.postcode,
    u.employment_type as employment_type_id,
    et.name as employment_type_name,
    u.active,
    u.modified_time,
    u.comments,
    u.app_version,
    u.device_os,
    u.device_os_version,
    u.app_timezone,
    u.last_logged_in
FROM ffa_user u
LEFT JOIN ffa_user_type ut ON u.ut_id = ut.ut_id
LEFT JOIN ffa_employment_type et on u.employment_type = et.employment_type
  
