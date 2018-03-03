(load "srcs/gui.lisp")
(load "srcs/cli.lisp")

;;(main *posix-argv*))
(defun main ()
  (setq y 100)
  (setq x 50)
  (setq width 1000)
  (setq height 1000)
  (setq zoom_dec_speed 2)
  (setq move_speed 10)
  (defparameter tile_size 15)
  (defparameter move_x 0)
  (defparameter move_y 0)
  
  (setq arr (make-array (list y x) :initial-element 0))

  (ft_loop tile_size)
  (exit)
)

(sb-int:with-float-traps-masked (:invalid :inexact :overflow) (main))
