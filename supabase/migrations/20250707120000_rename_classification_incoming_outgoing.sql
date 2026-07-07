-- Rename DTS classification values from Inbound/Outbound to Incoming/Outgoing.
UPDATE dts_docs
SET classification = 'Incoming'
WHERE classification = 'Inbound';

UPDATE dts_docs
SET classification = 'Outgoing'
WHERE classification = 'Outbound';

UPDATE dts_history
SET classification = 'Incoming'
WHERE classification = 'Inbound';

UPDATE dts_history
SET classification = 'Outgoing'
WHERE classification = 'Outbound';
