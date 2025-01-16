(defmodule ljson-file
  (export
   (read 1) (read 2)
   (write 2) (write 3)))

(defun read (path)
  (case (file:read_file path)
    (`#(ok ,binary) (ljson:decode binary))
    (err err)))

(defun read (standard-type-atom rel-path)
  (read (make-path standard-type-atom rel-path)))

(defun write (path term-data)
  (file:write_file path (ljson:encode term-data))
  path)

(defun write (dir-type-atom rel-path term-data)
  (case (make-path dir-type-atom rel-path)
    (`#(error ,err) `#(error, err))
    (path (write path term-data))))

(defun make-path (dir-type-atom rel-path)
  (let ((path (dirs:assemble dir-type-atom (filename:split rel-path))))
    (case (filelib:ensure_dir path)
      ('ok path)
      (err err))))
