function final_count =influenceoftoughts()

    % Parameters
    numKids = 80;
    days = 180;
    ax = [0 10 0 10]; % problem domain
    v = .04; % speed of agents (distance traveled per step)
    influences = zeros(numKids, 4);
    final_count = zeros(1, 2);

    % Cell parameters
    cell_size = 1;
    num_cells_x = ceil((ax(2)-ax(1)) / cell_size);
    num_cells_y = ceil((ax(4)-ax(3)) / cell_size);

    % Initialization
    X = rand(numKids,2) .* [diff(ax(1:2)), diff(ax(3:4))] + [ax(1), ax(3)]; % initial positions
    D = rand(numKids,1)*2*pi; % initial angles of direction of agent
    beliefs = randi([0, 1], numKids, 1);

    % Randomly distribute the factors throughout the numkids
    for i = 1:numKids
        influences(i, :) = randi([0, 1], 1, 4); % Randomly choose two influence factors for each kid
    end
    
    
    % Loop over days
    for j = 1:days 
        % Update positions and directions
        X(:,1) = X(:,1) + v*cos(D); 
        X(:,2) = X(:,2) + v*sin(D); % move agents

        % Handle wall collisions
        hit_wall_x = X(:,1) < ax(1) | X(:,1) > ax(2);
        hit_wall_y = X(:,2) < ax(3) | X(:,2) > ax(4);
        D(hit_wall_x | hit_wall_y) = pi + D(hit_wall_x | hit_wall_y);

        % Let agents bounce off walls
        X(:,1) = min(max(X(:,1), ax(1)), ax(2)); % move agents outside of
        X(:,2) = min(max(X(:,2), ax(3)), ax(4)); % domain back onto boundary

        % Initialize new beliefs
        new_beliefs = beliefs;

        % Update agents' beliefs based on neighboring agents in the same cell
        for k = 1:numKids
            % Find cell indices for the current agent
            cell_x = floor(X(k,1) / cell_size) + 1;
            cell_y = floor(X(k,2) / cell_size) + 1;

            % Get indices of agents in the same cell
            agents_in_cell = find(X(:,1) >= (cell_x - 1) * cell_size & X(:,1) < cell_x * cell_size ...
                & X(:,2) >= (cell_y - 1) * cell_size & X(:,2) < cell_y * cell_size);

            % Calculate sum of influences for the current agent
            sum_influences = sum(influences(k, :));

            % Adjust belief change probability based on influences and number of agents in the cell
            if numel(agents_in_cell) >= 3

                %AGENT THAT HAS 2 OR MORE "NEGATIVE" INFLUENCE AND 2+ NEIGHBOORS
                if sum_influences >= 2 && sum(beliefs(agents_in_cell) ~= beliefs(k)) >= 2
                    % Agent has a greater chance to change its belief to 1
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) = 1; % Change belief to 1
                    end
                end

                 %AGENT THAT less 2 "NEGATIVE" INFLUENCE AND 3+ NEIGHBOORS
                if sum_influences < 2 && sum(beliefs(agents_in_cell) ~= beliefs(k)) >= 3
                    % Agent has a greater chance to change its belief to 1
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) = 1; % Change belief to 1
                    end   
                end

               %AGENT THAT HAS LESS THAN 2 "NEGATIVE" AND 2+ NEIGHBOORS
                %AND PRESENT PARENTS
                if sum(beliefs(agents_in_cell) == beliefs(k)) >= 1 && influences(k, 1) == 0
                    % Agent has a greater chance to stay on belief 0
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) = 0; % Stay on belief 0
                    end
                end

                 %AGENT THAT HAS 2 OR MORE "NEGATIVE" AND 1+ NEIGHBOORS
                %AND PRESENT PARENTS
                if sum(beliefs(agents_in_cell) ~= beliefs(k)) >= 2 && influences(k, 1) == 0
                    % Agent has a greater chance to stay on belief 0
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) = 0;
                    end
                end
                %AGENT THAT HAS  1+ NEIGHBOORS
                %AND DONT LIKE FOLLOWING OTHERS
                if influences(k, 3) == 0
                    % Agent has a greater chance to stay on belief 0
                    if rand < 0.5 && beliefs(k)==0% Adjust probability as needed
                        new_beliefs(k) = 0;
                    end    
                end

                %AGENT THAT HAS 2+ NEIGHBOORS
                %AND GOOD TEACHER
                if sum(beliefs(agents_in_cell) ~= beliefs(k)) >=2 && influences(k, 2) == 0
                    % Agent has a greater chance to stay on belief 0
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) = 0; % change on belief 0
                    end
                end

                 %AGENT THAT HAS 2+ NEIGHBOORS
                %AND diverse
                if sum(beliefs(agents_in_cell) ~= beliefs(k)) >= 2 && influences(k, 4) == 0
                    % Agent has a greater chance to stay on belief 0
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) = 0; % change on belief 0
                    end
                end

                 %AGENT THAT HAS LESS THAN 2 "NEGATIVE" AND 2+ NEIGHBOORS
               
                if sum_influences ==0 && sum(beliefs(agents_in_cell) ~= beliefs(k)) >= 3
                    % Agent has a greater chance to change its belief to 0
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) = 0; % Change belief to 0
                    end
                end





               
                 %AGENT THAT HAS 1+ NEIGHBOORS
                %AND PRESENT PARENTS
                if sum(beliefs(agents_in_cell) ~= beliefs(k)) >= 2 && influences(k, 1) == 1
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) = 1;
                    end
                end
                %AGENT THAT HAS 2 OR MORE "NEGATIVE" AND 1+ NEIGHBOORS
                %AND LIKE FOLLOWING OTHERS
                if sum(beliefs(agents_in_cell) ~= beliefs(k)) >= 1 && influences(k, 3) == 1
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) = 1;
                    end    
                end

                %AGENT THAT HAS 2+ NEIGHBOORS
                %AND GOOD TEACHER
                if sum(beliefs(agents_in_cell) ~= beliefs(k)) >= 2 && influences(k, 2) == 1
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) = 1; 
                    end
                end

                 %AGENT THAT HAS 2+ NEIGHBOORS
                %AND diversity
                if sum(beliefs(agents_in_cell) ~= beliefs(k)) >= 2 && influences(k, 4) == 1
                    if rand < 0.5 % Adjust probability as needed
                        new_beliefs(k) =1; 
                    end
                end
            end
        end

        % Update beliefs
        beliefs = new_beliefs;

        % Count red and blue dots
        red_count = sum(beliefs == 1);
        blue_count = sum(beliefs == 0);

        % Plotting
        clf;
        % Plot cell boundaries
        for i = ax(1):cell_size:ax(2)
            plot([i i], [ax(3) ax(4)], 'k--');
            hold on;
        end
        for k = ax(3):cell_size:ax(4)
            plot([ax(1) ax(2)], [k k], 'k--');
        end
        % Plot agents based on beliefs
        scatter(X(beliefs==1,1), X(beliefs==1,2), 'r', 'filled'); % Red dots for belief = 1
        hold on;
        scatter(X(beliefs==0,1), X(beliefs==0,2), 'b', 'filled'); % Blue dots for belief = 0
        hold off;
        axis(ax);
        xlabel('x');
        ylabel('y');
        title(sprintf('Agents with Beliefs (Day %d)', j));
        legend(sprintf('Belief = 1 (%d)', red_count), sprintf('Belief = 0 (%d)', blue_count), 'Location', 'NorthEast');
        drawnow;

        % Pause to see animation
        pause(0.07);
    end
    
    final_count(1)=blue_count;
    final_count(2)=red_count;

   

    
end
