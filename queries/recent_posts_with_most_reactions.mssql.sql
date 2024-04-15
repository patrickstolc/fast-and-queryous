SELECT TOP 10 
    P.PostId,
        P.Title,
       P.PublicationDate,
       COUNT(R.ReactionId) AS ReactionCount
FROM
    Posts P
        LEFT JOIN
    Comments C ON P.PostId = C.PostId
        LEFT JOIN
    Reactions R ON C.CommentId = R.CommentId
GROUP BY
    P.PostId,
    P.Title,
    P.PublicationDate
ORDER BY
    ReactionCount DESC,
    P.PublicationDate DESC