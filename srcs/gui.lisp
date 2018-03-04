(ql:quickload "lispbuilder-sdl")
(defparameter *random-color* sdl:*white*)

(defun ft_print_box (x_ y_ size)
  (sdl:draw-box (sdl:rectangle-from-midpoint-*  (+ x_ (floor size 2))  (+ y_(floor size 2)) size size)
    :color *random-color*)
)

(defun ft_print_gui_board (arr x y tile_size)
  (sdl:clear-display sdl:*black*)
  (dotimes (y2 y)
    (dotimes (x2 x)
      (if (eq (eq (aref arr y2 x2) 0) T)
        (ft_print_box (+ 1 (* x2 tile_size) move_x) (+ 1 (* y2 tile_size) move_y) (- tile_size (floor tile_size 10))))))
  (sdl:update-display))

(defun ft_zoom ()
  (setf tile_size (+ tile_size zoom_dec_speed))
  (setf move_x (- move_x 50))
  (setf move_y (- move_y 50))
)

(defun ft_dezoom ()
  (if (> tile_size zoom_dec_speed)
    (progn
      (setf tile_size (- tile_size zoom_dec_speed))
      (setf move_x (+ move_x 50))
      (setf move_y (+ move_y 50))
    )
  )
)

(defun ft_handle_event (key)
  (if (sdl:key= key :sdl-key-escape)
    (sdl:push-quit-event))
  (if (or (sdl:key= key :sdl-key-left) (sdl:key= key :sdl-key-a))
    (setf move_x (+ move_x move_speed)))
  (if (or (sdl:key= key :sdl-key-right) (sdl:key= key :sdl-key-d))
    (setf move_x (- move_x move_speed)))
  (if (or (sdl:key= key :sdl-key-up) (sdl:key= key :sdl-key-w))
    (setf move_y (+ move_y move_speed)))
  (if (or (sdl:key= key :sdl-key-down) (sdl:key= key :sdl-key-s))
    (setf move_y (- move_y move_speed)))
  (if (or (sdl:key= key :sdl-key-q) (sdl:key= key :sdl-key-kp-minus))
    (ft_dezoom))
  (if (or (sdl:key= key :sdl-key-e) (sdl:key= key :sdl-key-kp-plus))
    (ft_zoom))
  (if (or (sdl:key= key :sdl-key-r))
    (setq arr (make-array (list y x) :initial-element 0)))
  (if (or (sdl:key= key :sdl-key-p) (sdl:key= key :sdl-key-space))
	  (if (= pause 1)
		  (setf pause 0)
		)
    (if (= pause 0)
	  (setf pause 1)
	)
  )
  (ft_print_gui_board arr x y tile_size)
)

(defun ft_mouse_event ()
  (if (sdl:mouse-left-p)
	(let
	  ((i_tab (floor (- (sdl:mouse-y) move_y) tile_size))
	   (j_tab (floor (- (sdl:mouse-x) move_x) tile_size)))
	  (if (eq (and (>= i_tab 0) (< i_tab y) (>= j_tab 0) (< j_tab x)) T)
        (setf (aref arr i_tab j_tab) 1))))
  (if (sdl:mouse-right-p)
	(let
	  ((i_tab (floor (- (sdl:mouse-y) move_y) tile_size))
	   (j_tab (floor (- (sdl:mouse-x) move_x) tile_size)))
	  (if (eq (and (>= i_tab 0) (< i_tab y) (>= j_tab 0) (< j_tab x)) T)
        (setf (aref arr i_tab j_tab) 0))))
  (when (sdl:mouse-wheel-up-p) ;ca marche pas :'(
    (ft_zoom))
  (when (or (sdl:mouse-wheel-down-p) (sdl:mouse-x2-p))
    (ft_dezoom))
  (ft_print_gui_board arr x y tile_size)
)

(defun ft_algo ()
  (write "jjaniec le terpri")
  (terpri)
)

(defun ft_loop ()
  (sdl:with-init ()
  (sdl:window width height :title-caption "TG FDP")
  (setf (sdl:frame-rate) 60)
  (sdl:update-display)
  (sdl:enable-key-repeat nil nil)
  (sdl:with-events ()
    (:quit-event () t)
    (:video-expose-event () (sdl:update-display))
	(:mouse-button-up-event (:button button :x mouse-x :y mouse-y)
	  (if (= button 4)
		  (if (or (sdl:key-down-p :sdl-key-lshift)
				  (sdl:key-down-p :sdl-key-rshift))
			  nil
			(ft_dezoom)))
	  (if (= button 5)
		  (if (or (sdl:key-down-p :sdl-key-lshift)
				  (sdl:key-down-p :sdl-key-rshift))
			  nil
			(ft_zoom))))
    (:key-down-event (:key key)
      (ft_handle_event key))
    (:idle ()
	  (ft_mouse_event)
	  (if (eq (eq pause 0) T)
	    (ft_algo)
	  )
      ))))
