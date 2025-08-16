INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'appointment-documents',
  'appointment-documents', 
  false, -- Private bucket (no public access)
  10485760, -- 10MB file size limit (10 * 1024 * 1024 bytes)
  ARRAY[
    'application/pdf',
    'image/jpeg',
    'image/jpg', 
    'image/png',
    'image/webp'
  ]
);