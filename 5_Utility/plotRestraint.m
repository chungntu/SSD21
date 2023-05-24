%--------------------------------------------------------------------------
% PLOT CONSTRAINT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function plotRestraint(in_data,ND_d,lab)
% UNIT DIMENSION CONSTRAINT
w=1; h=3^0.5/2*w;
x_pin=[0 -w/2 w/2]; z_pin=[0 -h -h];                        % PIN
x_fix = [-w/2 w/2 w/2 -w/2]; y_fix = [-0.05*h -0.05*h -h -h]; % FIX
x_roll = [-1/6 1/6 1/2 1/2 1/6 -1/6 -1/2 -1/2];
z_roll = [0    0   -h/3  -2*h/3   -h  -h  -2*h/3   -h/3];   % ROLLER
x_line = [0 0]; z_line = [0 -h];
transparent = 0.5;
[~,EL_TYPE,~] = elemType(in_data);
switch EL_TYPE
    case {0,1,2,333} % 2D Frame
        for CONSTRAINT = 1:size(in_data.CON,1)
            NODE = find(in_data.ND(:,1)==in_data.CON(CONSTRAINT,1));
            % PIN CONSTRAINT
            if (in_data.CON(CONSTRAINT,2)==0 && in_data.CON(CONSTRAINT,3)==0 && in_data.CON(CONSTRAINT,4)~=0)
                x_pin_move = x_pin*lab + ND_d(NODE,2);
                z_pin_move = z_pin*lab + ND_d(NODE,3);
                patch(x_pin_move,z_pin_move,'g'); alpha(transparent)
                x_line_move = x_line*lab + ND_d(NODE,2);
                z_line_move = z_line*lab + ND_d(NODE,3);
                plot(x_line_move,z_line_move,'k')
                hold on;
            end
            % X-ROLLER CONSTRAINT
            if (in_data.CON(CONSTRAINT,2)~=0 && in_data.CON(CONSTRAINT,3)==0 && in_data.CON(CONSTRAINT,4)~=0)
                x_roll_move = x_roll*lab + ND_d(NODE,2);
                z_roll_move = z_roll*lab + ND_d(NODE,3);
                patch(x_roll_move,z_roll_move,'g'); alpha(transparent)
                x_line_move = x_line*lab + ND_d(NODE,2);
                z_line_move = z_line*lab + ND_d(NODE,3);
                plot(x_line_move,z_line_move,'k')
                hold on;
            end
            % Y-ROLLER CONSTRAINT
            if (in_data.CON(CONSTRAINT,2)==0 && in_data.CON(CONSTRAINT,3)~=0 && in_data.CON(CONSTRAINT,4)~=0)
                x_roll_move = x_roll*lab + ND_d(NODE,2);
                z_roll_move = z_roll*lab + ND_d(NODE,3);
                h1 = patch(x_roll_move,z_roll_move,'g'); alpha(transparent)
                x_line_move = x_line*lab + ND_d(NODE,2);
                z_line_move = z_line*lab + ND_d(NODE,3);
                h2 = plot(x_line_move,z_line_move,'k');
                hold on
                direction = [0 0 1];
                rotate(h1,direction,90,[ND_d(NODE,2),ND_d(NODE,3),0])
                rotate(h2,direction,90,[ND_d(NODE,2),ND_d(NODE,3),0])
                hold on;
            end
            % FIX CONSTRAINT
            if (in_data.CON(CONSTRAINT,2)==0 && in_data.CON(CONSTRAINT,3)==0 && in_data.CON(CONSTRAINT,4)==0)
                x_fix_move = x_fix*lab + ND_d(NODE,2);
                z_fix_move = y_fix*lab + ND_d(NODE,3);
                patch(x_fix_move,z_fix_move,'g'); alpha(transparent)
                x_line_move = x_line*lab + ND_d(NODE,2);
                z_line_move = z_line*lab + ND_d(NODE,3);
                plot(x_line_move,z_line_move,'k')
                hold on;
            end
        end
    case {3,31} % 3D Frame/Truss
        for CONSTRAINT = 1:size(in_data.CON,1)
            NODE = find(in_data.ND(:,1)==in_data.CON(CONSTRAINT,1));
            % PIN CONSTRAINT
            if (in_data.CON(CONSTRAINT,2)==0 && in_data.CON(CONSTRAINT,3)==0 && in_data.CON(CONSTRAINT,4)==0)...
                    && in_data.CON(CONSTRAINT,5)~=0 && in_data.CON(CONSTRAINT,6)~=0 && in_data.CON(CONSTRAINT,7)~=0
                x_pin_move = x_pin*lab + ND_d(NODE,2);
                z_pin_move = z_pin*lab + ND_d(NODE,3);
                h1 = patch(x_pin_move,z_pin_move,'g');
                direction = [1 0 0];
                rotate(h1,direction,90,[ND_d(NODE,2),ND_d(NODE,3),0])
                hold on
                h2 = patch(x_pin_move,z_pin_move,'g');
                direction = [0 0 1];
                rotate(h2,direction,90,[ND_d(NODE,2),ND_d(NODE,3),0])
                direction = [0 1 0];
                rotate(h2,direction,90,[ND_d(NODE,2),ND_d(NODE,3),0])
                hold on;
                alpha(transparent)
                hold on;
            end
            % FIX CONSTRAINT
            if (in_data.CON(CONSTRAINT,2)==0 && in_data.CON(CONSTRAINT,3)==0 && in_data.CON(CONSTRAINT,4)==0)...
                    && in_data.CON(CONSTRAINT,5)==0 && in_data.CON(CONSTRAINT,6)==0 && in_data.CON(CONSTRAINT,7)==0
                x_fix_move = x_fix*lab + ND_d(NODE,2);
                z_fix_move = y_fix*lab + ND_d(NODE,3);
                h1 = patch(x_fix_move,z_fix_move,'g');
                direction = [1 0 0];
                rotate(h1,direction,90,[ND_d(NODE,2),ND_d(NODE,3),0])
                hold on
                h2 = patch(x_fix_move,z_fix_move,'g');
                direction = [0 0 1];
                rotate(h2,direction,90,[ND_d(NODE,2),ND_d(NODE,3),0])
                direction = [0 1 0];
                rotate(h2,direction,90,[ND_d(NODE,2),ND_d(NODE,3),0])
                hold on;
                alpha(transparent)
                hold on
            end
        end
end
hold off