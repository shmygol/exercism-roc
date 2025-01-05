module [twoFer]

twoFer : [Name Str, Anonymous] -> Str
twoFer = \recipient ->
    recipientReference = when recipient is
        Name name -> name
        Anonymous -> "you"
    "One for $(recipientReference), one for me."
