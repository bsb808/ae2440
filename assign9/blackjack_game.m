% Using the BlackJackEnv.m environemnt, write a script to allow a user to play repeated hands of blackjack against the computer. The script should:
% 1. Initialize the environment
% 2. reset the environment to start a new hand and display the initial observation
% 3. Prompt the user to enter hit or stick
% 4. Take the action and display the new observation
% 5. Repeat steps 3 and 4 until the game is over
% 6. Display the final observation, the dealer's final hand, the reward for the game, the cummulative rewards and the number of hands played.
% 7. Ask the user if they want to play again
% 8. Repeat steps 2-7 until the user chooses to stop playing
% 9. Display the number of games won, lost, and drawn by the user.  Display the total reward earned by the user and the total number of hands played.
% 10. Exit the script

% Initialize environment
env = BlackJackEnv(1);

% Initialize variables
gamesWon = 0;
gamesLost = 0;
gamesDrawn = 0;
totalReward = 0;
handCount = 0;
play_again = 'y';
while true
    % Reset the environment to start a new game
    observation = env.reset();
    disp('Initial State:');
    disp(observation);
    
    terminated = false;
    % Play the game
    while ~terminated
        % Prompt the user to enter hit or stick
        action = input('Enter 1 for "stick" or 2 for "hit": ','s');
        action = str2num(action)
        % Verify input
        if action ~= 1 && action ~= 2
            disp('Invalid action. Please enter "1" or "2".');
            continue;
        end
        [observation, reward, terminated, truncated, info] = env.step(action);
        disp('New State:');
        disp(observation);
    end
    
    % Display the final state and the result of the game
    handCount = handCount+1;
    disp('Final State:');
    disp(observation);
    fprintf('Dealer Hand: %d\n',info.dealer_hand)
    fprintf('Reward: %d\n', reward);
    fprintf("Hand Count: %d\n", handCount);
    % Update game statistics
    if reward > 0
        gamesWon = gamesWon + 1;
    elseif reward < 0
        gamesLost = gamesLost + 1;
    else
        gamesDrawn = gamesDrawn + 1;
    end
    totalReward = totalReward + reward;
    % Ask the user if they want to play again
    playAgain = input('Do you want to play again? (y/n) [y]: ', 's');
    if strcmp(playAgain, 'n')
        break;
    end
end

% Display the number of games won, lost, and drawn by the user
fprintf("\nGame Statistics:\n");
fprintf("Games Won: %d\n", gamesWon);
fprintf("Games Lost: %d\n", gamesLost);
fprintf("Games Drawn: %d\n", gamesDrawn);
fprintf("Total Reward: %.1f\n", totalReward);
fprintf("Total Hands Played: %d\n", handCount);
