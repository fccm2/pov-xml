module Xt = Xmlerr
let is_background tag =
  ("background" = tag)
let is_color tag =
  ("color" = tag)
let is_camera tag =
  ("camera" = tag)
let is_sphere tag =
  ("sphere" = tag)
let is_texture tag =
  ("texture" = tag)
let is_pigment tag =
  ("pigment" = tag)
let is_light_source tag =
  ("light_source" = tag)
let is_global_settings tag =
  ("global_settings" = tag)
let is_ambient_light tag =
  ("ambient_light" = tag)
let is_box tag =
  ("box" = tag)

let () =
  let xt = Xt.parse_file ~filename:Sys.argv.(1) in
  let xt = Xt.rem_space xt in

  let rec aux_pgm xt =
    match xt with
    | [] -> invalid_arg "pigment"
    | hx :: xt ->
        match hx with
        | Xt.ETag (tag)
          when is_pigment tag ->
            Printf.printf " }\n" ;
            xt

        | Xt.Tag (tag, ttr_lst)
          when is_color tag ->

            let rgbt_color = Xt.val_attr ttr_lst "rgbt" in
            Printf.printf "color rgbt <%s>" rgbt_color ;
            aux_pgm xt

        | Xt.Tag (tag, ttr_lst) -> aux_pgm xt
        | Xt.ETag (tag) -> aux_pgm xt
        | Xt.Data (pdata) -> aux_pgm xt
        | Xt.Comm (cmt) -> aux_pgm xt
  in

  let rec aux_texr xt =
    match xt with
    | [] -> invalid_arg "texture"
    | hx :: xt ->
        match hx with
        | Xt.ETag (tag)
          when is_texture tag ->
            Printf.printf "  }\n" ;
            xt

        | Xt.Tag (tag, ttr_lst)
          when is_pigment tag ->
            Printf.printf "    pigment { " ;
            let xt = aux_pgm xt in
            aux_texr xt

        | Xt.Tag (tag, ttr_lst) -> aux_texr xt
        | Xt.ETag (tag) -> aux_texr xt
        | Xt.Data (pdata) -> aux_texr xt
        | Xt.Comm (cmt) -> aux_texr xt
  in

  let rec aux_box xt =
    match xt with
    | [] -> invalid_arg "box"
    | hx :: xt ->
        match hx with
        | Xt.ETag (tag)
          when is_box tag ->
            Printf.printf "}\n" ;
            xt

        | Xt.Tag (tag, ttr_lst)
          when is_texture tag ->
            Printf.printf "  texture {\n" ;
            let xt = aux_texr xt in
            aux_box xt

        | Xt.Tag (tag, ttr_lst) -> aux_box xt
        | Xt.ETag (tag) -> aux_box xt
        | Xt.Data (pdata) -> aux_box xt
        | Xt.Comm (cmt) -> aux_box xt
  in

  let rec aux_sphr xt =
    match xt with
    | [] -> invalid_arg "sphere"
    | hx :: xt ->
        match hx with
        | Xt.ETag (tag)
          when is_sphere tag ->
            Printf.printf "}\n" ;
            xt

        | Xt.Tag (tag, ttr_lst)
          when is_texture tag ->
            Printf.printf "  texture {\n" ;
            let xt = aux_texr xt in
            aux_sphr xt

        | Xt.Tag (tag, ttr_lst) -> aux_sphr xt
        | Xt.ETag (tag) -> aux_sphr xt
        | Xt.Data (pdata) -> aux_sphr xt
        | Xt.Comm (cmt) -> aux_sphr xt
  in

  let rec aux_cam xt =
    match xt with
    | [] -> invalid_arg "camera"
    | hx :: xt ->
        let xt =
          match hx with
          | Xt.ETag (tag)
            when is_camera tag ->
              Printf.printf "}\n" ;
              xt
          | Xt.Tag (tag, ttr_lst) -> xt
          | Xt.ETag (tag) -> xt
          | Xt.Data (pdata) -> xt
          | Xt.Comm (cmt) -> xt
        in
        xt
  in

  let rec aux_glbstn xt =
    match xt with
    | [] -> invalid_arg "global_settings"
    | hx :: xt ->
        match hx with
        | Xt.Tag (tag, ttr_lst)
          when is_ambient_light tag ->
            let rgb = Xt.val_attr ttr_lst "rgb" in
            Printf.printf "ambient_light rgb <%s>" rgb ;
            aux_glbstn xt
        | Xt.ETag (tag)
          when is_ambient_light tag ->
            Printf.printf " }\n" ;
            xt
        | Xt.Tag (tag, ttr_lst) -> aux_glbstn xt
        | Xt.ETag (tag) -> aux_glbstn xt
        | Xt.Data (pdata) -> aux_glbstn xt
        | Xt.Comm (cmt) -> aux_glbstn xt
  in

  let rec aux_bg xt =
    match xt with
    | [] -> invalid_arg "background"
    | hx :: xt ->
        let xt =
          match hx with
          | Xt.Tag (tag, ttr_lst)
            when is_color tag ->
              let rgb_color = Xt.val_attr ttr_lst "rgb" in
              Printf.printf "color rgb <%s>" rgb_color ;
              xt
          | Xt.ETag (tag)
            when is_color tag ->
              Printf.printf "" ;
              xt
          | Xt.Tag (tag, ttr_lst) -> xt
          | Xt.ETag (tag) -> xt
          | Xt.Data (pdata) -> xt
          | Xt.Comm (cmt) -> xt
        in
        xt
  in

  let rec aux_xt xt =
    match xt with
    | [] -> ()
    | hx :: xt ->
        let xt =
          match hx with
          (*
            <global_settings>
              <ambient_light rgb='0, 0.3, 0.6' />
            </global_settings>
          *)
          (*
            global_settings { ambient_light rgb <0, 0.3, 0.6> }
          *)

          | Xt.Tag (tag, ttr_lst)
            when is_global_settings tag ->
              Printf.printf "global_settings { " (*tag*) ;
              let xt = aux_glbstn xt in
              xt

          | Xt.Tag (tag, ttr_lst)
            when is_light_source tag ->
              let position = Xt.val_attr ttr_lst "position" in
              let color = Xt.val_attr ttr_lst "color" in
              Printf.printf "light_source { <%s> color rgb <%s> }\n" position color ;
              xt

          | Xt.Tag (tag, ttr_lst)
            when is_box tag ->
              let corner1 = Xt.val_attr ttr_lst "corner1" in
              let corner2 = Xt.val_attr ttr_lst "corner2" in
              Printf.printf "box {\n" (*tag*) ;
              Printf.printf "  <%s>,\n" corner1 ;
              Printf.printf "  <%s>\n"  corner2 ;
              let xt = aux_box xt in
              xt

          | Xt.Tag (tag, ttr_lst)
            when is_sphere tag ->
              let position = Xt.val_attr ttr_lst "position" in
              let radius = Xt.val_attr ttr_lst "radius" in
              Printf.printf "sphere {\n" (*tag*) ;
              Printf.printf "  <%s>, %s\n" position radius ;
              let xt = aux_sphr xt in
              xt

          | Xt.Tag (tag, ttr_lst)
            when is_camera tag ->
              Printf.printf "camera {\n" (*tag*) ;

              let location = Xt.val_attr ttr_lst "location" in
              Printf.printf "  location <%s>\n" location ;

              let look_at = Xt.val_attr ttr_lst "look_at" in
              Printf.printf "  look_at <%s>\n" look_at ;

              let xt = aux_cam xt in
              xt

          | Xt.Tag (tag, _)
            when is_background tag ->
              Printf.printf "background { " (*tag*) ;
              let xt = aux_bg xt in
              xt

          | Xt.ETag (tag)
            when is_camera tag ->
              xt

          | Xt.ETag (tag)
            when is_background tag ->
              Printf.printf " }\n" ;
              xt

          | Xt.ETag (tag)
            when is_sphere tag ->
              Printf.printf "}\n" ;
              xt

          | Xt.Tag (tag, ttr_lst) -> xt
          | Xt.ETag (tag) -> xt
          | Xt.Data (pdata) -> xt
          | Xt.Comm (cmt) -> xt
        in
        aux_xt xt
  in
  aux_xt xt
