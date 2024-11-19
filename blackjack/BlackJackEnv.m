classdef BlackJackEnv < handle
    % A MATLAB adaptation of the blackjack environment from the Farama
    % Foundation - https://github.com/Farama-Foundation/Gymnasium/blob/main/gymnasium/envs/toy_text/blackjack.py
    
    properties
        % Define properties
        action_size
        current_state
        max_steps
        step_count
        deck
        dealer
        player
        natural
    end
    
    methods
        function obj = BlackJackEnv(natural)
            % Constructor: Initialize environment parameters
            if nargin < 1
                obj.natural = false;
            else
                obj.natural = natural;
            end
            
            obj.action_size = 1;
            obj.max_steps = 10;  % Maximum steps per episode
            obj.step_count = 0;
            % 1 = Ace, 2-10 = Number cards, Jack/Queen/King = 10
            obj.deck = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10];
        end

        function ret = cmp(obj, a, b)
            ret = double(a > b) - double(a < b);
        end
        
        function card = draw_card(obj)
            % Choose random card instead of sequential draw
            idx = randi(length(obj.deck));
            card = obj.deck(idx);
        end
        
        function hand = draw_hand(obj)
            % Draw two cards to form a hand
            hand = [obj.draw_card(), obj.draw_card()];
        end
        
        function result = usable_ace(obj, hand)
            % Check if hand has a usable ace
            % Returns logical (true/false)
            result = any(hand == 1) && (sum(hand) + 10 <= 21);
        end
        
        function total = sum_hand(obj, hand)
            % Calculate total value of hand, considering aces
            if obj.usable_ace(hand)
                total = sum(hand) + 10;
            else
                total = sum(hand);
            end
        end
        
        function result = is_bust(obj, hand)
            % Check if hand is bust
            % Returns logical (true/false)
            result = obj.sum_hand(hand) > 21;
        end
        
        function hand_score = score(obj, hand)
            % Calculate score of hand (0 if bust)
            if obj.is_bust(hand)
                hand_score = 0;
            else
                hand_score = obj.sum_hand(hand);
            end
        end
        
        function result = is_natural(obj, hand)
            % Check if hand is a natural blackjack
            % Returns logical (true/false)
            sorted_hand = sort(hand);
            result = isequal(sorted_hand, [1, 10]);
        end
        
        function observation = get_obs(obj)
            observation = [obj.sum_hand(obj.player), ...
                obj.dealer(1), obj.usable_ace(obj.player)];
        end

        function [observation, info] = reset(obj)
            % Reset environment to initial state
            % Returns:
            %   observation: Initial state
            %   info: Additional information dictionary
            
            obj.step_count = 0;

            obj.dealer = obj.draw_hand();
            obj.player = obj.draw_hand();
            
            % Set initial observation
            observation = obj.get_obs();

            % Create info struct with additional information
            info = struct('episode_step', obj.step_count);
        end
        
        function [observation, reward, terminated, truncated, info] = step(obj, action)
            % Execute one timestep within the environment
            % Args:
            %   action: scalar {1, 2}, 1-stand, 2-hit
            % Returns:
            %   observation: Next state
            %   reward: Reward value
            %   terminated: Whether episode ended naturally
            %   truncated: Whether episode was artificially terminated
            %   info: Additional information
            
            % Validate action
            assert(numel(action) == obj.action_size, 'Invalid action dimension');
            
            % Update step count
            obj.step_count = obj.step_count + 1;
            
            % Hit: add a card to players hand and return
            if action == 2
                obj.player(end+1) = obj.draw_card();
                if obj.is_bust(obj.player)
                    terminated = true;
                    reward = -1;
                else
                    terminated = false;
                    reward = 0;
                end
            % Stick - play out the dealers hand, and score
            elseif action == 1 
                terminated = true;
                while (obj.sum_hand(obj.dealer)) < 17
                    obj.dealer(end+1) = obj.draw_card();
                end
                reward = obj.cmp(obj.score(obj.player), obj.score(obj.dealer));
                if (obj.natural && obj.is_natural(obj.player) && reward==1.0)
                    reward = 1.5;
                end
            else
                fprintf("Waring!  action should be 1 or 2, given <%f>\n", action);
            end
            
            % Set observation
            observation = obj.get_obs();
            
            % Check truncation (episode length limit) - will always be
            % false
            truncated = obj.step_count >= obj.max_steps;
            
            % Additional info
            info = struct('episode_step', obj.step_count);
        end
    end
end