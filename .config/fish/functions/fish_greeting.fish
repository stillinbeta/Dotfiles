function fish_greeting --description "say hello"

    set greetings \
    "“Demon be gone from this Chanel suit!”" \
    "“Sorry guys, but I can barely navigate the hellish vortex between breakfast and dinner, let alone the labyrinth of the field hockey field.”" \
    "“Well…that is the most melancholy pasta”" \
    "“You know what Helena, you don’t deserve this big Toblerone.”" \
    "“Gentlemen, I’m sorry I’m late. As you know, I’ve been really depressed, and it’s affected my attitude towards field hockey.”" \
    "“Don’t get me wrong, I’m very touched by your dedication to your dead wife, but perhaps her spirit would be cheered by newer, more youthful perfumes… The girls of my generation would never wear Babylon 05. They prefer a less mainstream fragrance.”"

    echo (random choice $greetings)
end
