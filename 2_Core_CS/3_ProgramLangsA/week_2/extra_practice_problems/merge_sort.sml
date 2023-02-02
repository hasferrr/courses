fun merge_sort (lon : int list) =
    let
        fun merge (lon1 : int list, lon2 : int list) =
            if null lon1
            then lon2
            else if null lon2
            then lon1
            else
                if hd lon1 < hd lon2
                then hd lon1 :: merge(tl lon1, lon2)
                else hd lon2 :: merge(lon1, tl lon2)

        fun take (lon0 : int list, n : int) =
            let
                fun take (lon : int list, count : int) =
                    if null lon
                    then []
                    else
                        if count <= n
                        then hd lon :: take (tl lon, count + 1)
                        else []
            in
                take (lon0, 1)
            end

        fun drop (lon0 : int list, n : int) =
            let
                fun drop (lon : int list, count : int) =
                    if null lon
                    then []
                    else
                        if count < n
                        then drop (tl lon, count + 1)
                        else tl lon
            in
                drop (lon0, 1)
            end
    in
        if null lon
        then []
        else if null (tl lon)
        then lon
        else
            merge (merge_sort (take (lon, (length lon) div 2)),
                   merge_sort (drop (lon, (length lon) div 2)))
    end
