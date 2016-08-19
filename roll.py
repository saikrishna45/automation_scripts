#### This script is the roll 7 game code which works on terminal level

import random

mypot = input("Please enter the amount of money you want in the pot: ")
# or as alternative:
#mypot = int(raw_input("Please enter the amount of money you want in the pot: "))
while mypot > 0:    # looping untill mypot <= 0
    dice_roll = random.randint(1, 7), random.randint(1, 7)  # rolling the dices
    print dice_roll[0], dice_roll[1]
    myrole = sum(dice_roll)
    if myrole == 7:
        mypot += 4    # without this you're not modifing the myrole value
        print "Your roll was a 7 you earned. Press enter to roll again:", mypot
    else:
        mypot -= 1
        print "Sorry you did not roll a 7. Press enter to roll again:", mypot
    raw_input()   # waiting for the user to press Enter

print "Sorry, there's no more money in your pot."
