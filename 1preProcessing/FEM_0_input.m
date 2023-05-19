%--------------------------------------------------------------------------
% INPORT DATA FROM .s2k FILE THEN FORMAT THE DATA
% OR RUN DIRECTLY FROM .m FILE
% FUTURE VERSION IMPORT DIRECTLY FROM .mat FILE
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function in_data = FEM_0_input(PROB_TYPE)
[fileName,pathName] = uigetfile({'*.m;*.s2k'},'Select a file');
if (isequal(fileName,0) || isequal(pathName,0))
    disp('USER CANCEL'); in_data = [];
else
    [~,~,ext] = fileparts(fileName);
    switch ext
        case '.m'
            run(append(pathName,fileName))
            in_data = ans;
        case '.s2k'
            [in_data] = import_s2k(PROB_TYPE,fileName,pathName);
            in_data = formatInput(PROB_TYPE,in_data,fileName);
    end
end
end

% IMPORT FILE S2K SAP2000 TO MATLAB
function in_data = import_s2k(PROB_TYPE,fileName,pathName)
addpath(pathName)
fid     = fopen(fileName);
s2k     = fscanf(fid,'%c');
rows    = strsplit(s2k, '\n');
%% IMPORT DATA FROM s2k FILE
switch PROB_TYPE
    case '2D FRAME'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 2D FRAME
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % GROUND DISPLACEMENT
        s2kSAP      = extractBetween(s2k,"JOINT LOADS - GROUND DISPLACEMENT","TABLE");
        Joint       = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","   LoadPat"));
        U1          = cellfun(@str2num, extractBetween(s2kSAP,"U1=","   U2="));
        U3          = cellfun(@str2num, extractBetween(s2kSAP,"U3=","   R1="));
        R2          = cellfun(@str2num, extractBetween(s2kSAP,"R2=","   R3="));
        in_data.DBC.dofs  = Joint;
        in_data.DBC.displ = [U1 U3 R2];
        % MATERIAL PROPERTIES
        s2kSAP      = extractBetween(s2k,"MATERIAL PROPERTIES 02 - BASIC MECHANICAL PROPERTIES","TABLE");
        s2kSAP      = eraseBetween(s2kSAP,"Material=4000Psi","Material=");              % TRY TO EARSE THE MATERIAL PROPERTIES OF Material=4000Psi
        s2kSAP      = eraseBetween(s2kSAP,"Material=A992Fy50","Material=");             % TRY TO EARSE THE MATERIAL PROPERTIES OF Material=A992Fy50
        s2kSAP      = eraseBetween(s2kSAP,"Material=A416Gr270","Material=");            % TRY TO EARSE THE MATERIAL PROPERTIES OF Material=4000Psi
        unitWeight  = cellfun(@str2num, extractBetween(s2kSAP,"UnitWeight=","   UnitMass="));
        unitMass    = cellfun(@str2num, extractBetween(s2kSAP,"UnitMass=","   E1="));
        E1          = cellfun(@str2num, extractBetween(s2kSAP,"E1=","   G12="));
        in_data.material = [unitWeight,unitMass,E1];
        if isempty(in_data.material)
            in_data.material = [76.9728639422648,7.84904737995992,199947978.795958];    % MATERIAL PROPERTIES OF A992Fy50
        end
        % SECTION PROPERTIES
        s2kSAP      = extractBetween(s2k,"FRAME SECTION PROPERTIES 01 - GENERAL","TABLE");
        s2kSAP      = eraseBetween(s2kSAP,"SectionName=FSEC1   Material=A992Fy50","I22=3.30125717301008E-06"); % TRY TO EARSE THE SECTION PROPERTIES OF Material=A992Fy50
        Area        = cellfun(@str2num, extractBetween(s2kSAP,"Area=","   TorsConst="));
        I33         = cellfun(@str2num, extractBetween(s2kSAP,"I33=","   I22="));
        in_data.section = [Area,I33];
        if isempty(in_data.section)
            in_data.section = [0.0042645076,6.5724174702235E-05];                       % SECTION PROPERTIES OF FSEC1
        end
        % JOINT COORDINATES
        s2kSAP      = extractBetween(s2k,"JOINT COORDINATES","TABLE");
        Joint       = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","   CoordSys"));
        GlobalX     = cellfun(@str2num, extractBetween(s2kSAP,"GlobalX=","   GlobalY="));
        GlobalZ     = cellfun(@str2num, extractBetween(s2kSAP,"GlobalZ=","   GUID="));
        in_data.ND  = [Joint,GlobalX,GlobalZ];
        % CONNECTIVITY - FRAME
        s2kSAP      = extractBetween(s2k,"CONNECTIVITY - FRAME","TABLE");
        FrameID     = cellfun(@str2num, extractBetween(s2kSAP,"Frame=","   JointI="));
        JointI      = cellfun(@str2num, extractBetween(s2kSAP,"JointI=","   JointJ="));
        JointJ      = cellfun(@str2num, extractBetween(s2kSAP,"JointJ=","   IsCurved="));
        in_data.EL = [FrameID,JointI,JointJ];
        % JOINT RESTRAINT ASSIGNMENTS
        s2kSAP      = extractBetween(s2k,"JOINT RESTRAINT ASSIGNMENTS","TABLE");
        JointCons   = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","U1="));
        U1          = cellfun(@compareStr,extractBetween(s2kSAP,"U1=","   U2="));
        U3          = cellfun(@compareStr,extractBetween(s2kSAP,"U3=","   R1="));
        R2          = cellfun(@compareStr,extractBetween(s2kSAP,"R2=","   R3="));
        in_data.CON = [JointCons U1 U3 R2];
        % JOINT ADDED MASS ASSIGNMENTS
        s2kSAP      = extractBetween(s2k,"JOINT ADDED MASS ASSIGNMENTS","TABLE");
        JointMass   = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","   CoordSys="));
        Mass1       = cellfun(@str2num,extractBetween(s2kSAP,"Mass1=","   Mass2="));
        Mass3       = cellfun(@str2num,extractBetween(s2kSAP,"Mass3=","   MMI1="));
        MMI2        = cellfun(@str2num,extractBetween(s2kSAP,"MMI2=","   MMI3="));
        in_data.JointMass = [JointMass Mass1 Mass3 MMI2];
        % JOINT LOADS - FORCE
        s2kSAP      = extractBetween(s2k,"JOINT LOADS - FORCE","TABLE");
        JointLOAD   = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","   LoadPat="));
        F1          = cellfun(@str2num,extractBetween(s2kSAP,"F1=","   F2="));
        F3          = cellfun(@str2num,extractBetween(s2kSAP,"F3=","   M1="));
        M2          = cellfun(@str2num,extractBetween(s2kSAP,"M2=","   M3="));
        in_data.LOAD_ = [JointLOAD F1 F3 -M2];
        % FRAME LOADS - DISTRIBUTED
        in_data.qx  = zeros(size(in_data.EL,1),1);
        in_data.qz0  = zeros(size(in_data.EL,1),1);
        s2kSAP      = extractBetween(s2k,"FRAME LOADS - DISTRIBUTED","TABLE");
        FrameLOAD   = cellfun(@str2num, extractBetween(s2kSAP,"Frame=","   LoadPat="));
        DirLoad     = extractBetween(s2kSAP,"Dir=","   DistType=");
        F           = cellfun(@str2num,extractBetween(s2kSAP,"FOverLA=","   FOverLB="));
        % X-DIRECTION
        d_X         = strcmp(DirLoad,'X');
        B           = [FrameLOAD.*d_X, F];
        indices     = find(B(:,1)~=0);
        B           = B(indices,:); in_data.qx(B(:,1)) = B(:,2);
        % Z-DIRECTION
        d_Z         = strcmp(DirLoad,'Z');
        C           = [FrameLOAD.*d_Z, F];
        indices     = find(C(:,1)~=0);
        C           = C(indices,:); in_data.qz0(C(:,1)) = C(:,2);
        % GRAVITY-DIRECTION
        d_ZG        = strcmp(DirLoad,'Gravity');
        D           = [FrameLOAD.*d_ZG, -F];
        indices     = find(D(:,1)~=0);
        D           = D(indices,:); in_data.qz0(D(:,1)) = D(:,2);
        % FRAME RELEASE ASSIGNMENTS
        s2kSAP      = extractBetween(s2k,"FRAME RELEASE ASSIGNMENTS 1 - GENERAL","TABLE");
        Frame       = cellfun(@str2num, extractBetween(s2kSAP,"Frame=","   PI="));
        M3I         = extractBetween(s2kSAP,"M3I=","   PJ=");
        M3J         = extractBetween(s2kSAP,"M3J=","   PartialFix=");
        M3I         = strcmp(M3I,'No');
        M3J         = strcmp(M3J,'No');
        in_data.RELEASE = [Frame M3I M3J];
    case '3D TRUSS'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 3D TRUSS
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % MATERIAL PROPERTIES
        ixEnd       = find(startsWith(rows,{'TABLE:  "MATERIAL PROPERTIES 03A - STEEL DATA"'}));
        s2kSAP      = rows{ixEnd-2};
        unitWeight  = cellfun(@str2num, extractBetween(s2kSAP,"UnitWeight=","   UnitMass="));
        unitMass    = cellfun(@str2num, extractBetween(s2kSAP,"UnitMass=","   E1="));
        E1          = cellfun(@str2num, extractBetween(s2kSAP,"E1=","   G12="));
        in_data.material = [unitWeight,unitMass,E1];
        % SECTION PROPERTIES
        ixEnd       = find(startsWith(rows,{'TABLE:  "FRAME SECTION PROPERTIES 13 - TIME DEPENDENT"'}));
        s2kSAP      = rows{ixEnd-3};
        Area        = cellfun(@str2num, extractBetween(s2kSAP,"Area=","   TorsConst="));
        I33         = cellfun(@str2num, extractBetween(s2kSAP,"I33=","   I22="));
        in_data.section = [Area,I33];
        % JOINT COORDINATES
        s2kSAP      = extractBetween(s2k,"JOINT COORDINATES","TABLE");
        Joint       = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","   CoordSys"));
        GlobalX     = cellfun(@str2num, extractBetween(s2kSAP,"GlobalX=","   GlobalY="));
        GlobalY     = cellfun(@str2num, extractBetween(s2kSAP,"GlobalY=","   GlobalZ="));
        GlobalZ    = cellfun(@str2num, extractBetween(s2kSAP,"GlobalZ=","   GUID="));
        in_data.ND  = [Joint,GlobalX,GlobalY,GlobalZ];
        % CONNECTIVITY - FRAME
        s2kSAP      = extractBetween(s2k,"CONNECTIVITY - FRAME","TABLE");
        FrameID     = cellfun(@str2num, extractBetween(s2kSAP,"Frame=","   JointI="));
        JointI      = cellfun(@str2num, extractBetween(s2kSAP,"JointI=","   JointJ="));
        JointJ      = cellfun(@str2num, extractBetween(s2kSAP,"JointJ=","   IsCurved="));
        in_data.EL = [FrameID,JointI,JointJ];
        % JOINT RESTRAINT ASSIGNMENTS
        s2kSAP      = extractBetween(s2k,"JOINT RESTRAINT ASSIGNMENTS","TABLE");
        JointCons   = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","U1="));
        U1          = cellfun(@compareStr,extractBetween(s2kSAP,"U1=","   U2="));
        U2          = cellfun(@compareStr,extractBetween(s2kSAP,"U2=","   U3="));
        U3          = cellfun(@compareStr,extractBetween(s2kSAP,"U3=","   R1="));
        R1          = cellfun(@compareStr,extractBetween(s2kSAP,"R1=","   R2="));
        R2          = cellfun(@compareStr,extractBetween(s2kSAP,"R2=","   R3="));
        in_data.CON = [JointCons U1 U2 U3 R1 R2 R2];
        % JOINT LOADS - FORCE
        s2kSAP      = extractBetween(s2k,"JOINT LOADS - FORCE","TABLE");
        JointLOAD   = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","   LoadPat="));
        F1          = cellfun(@str2num,extractBetween(s2kSAP,"F1=","   F2="));
        F2          = cellfun(@str2num,extractBetween(s2kSAP,"F2=","   F3="));
        F3          = cellfun(@str2num,extractBetween(s2kSAP,"F3=","   M1="));
        in_data.LOAD_ = [JointLOAD F1 F2 F3];
    case '3D FRAME'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 3D FRAME
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % JOINT COORDINATES ------------------------------------------------------
        s2kSAP      = extractBetween(s2k,"JOINT COORDINATES","TABLE");
        Joint       = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","   CoordSys"));
        GlobalX     = cellfun(@str2num, extractBetween(s2kSAP,"GlobalX=","   GlobalY="));
        GlobalY     = cellfun(@str2num, extractBetween(s2kSAP,"GlobalY=","   GlobalZ="));
        GlobalZ    = cellfun(@str2num, extractBetween(s2kSAP,"GlobalZ=","   GUID="));
        in_data.ND  = [Joint,GlobalX,GlobalY,GlobalZ];
        % CONNECTIVITY - FRAME ---------------------------------------------------
        s2kSAP      = extractBetween(s2k,"CONNECTIVITY - FRAME","TABLE");
        FrameID     = cellfun(@str2num, extractBetween(s2kSAP,"Frame=","   JointI="));
        JointI      = cellfun(@str2num, extractBetween(s2kSAP,"JointI=","   JointJ="));
        JointJ      = cellfun(@str2num, extractBetween(s2kSAP,"JointJ=","   IsCurved="));
        in_data.EL = [FrameID,JointI,JointJ];
        % JOINT RESTRAINT ASSIGNMENTS --------------------------------------------
        s2kSAP      = extractBetween(s2k,"JOINT RESTRAINT ASSIGNMENTS","TABLE");
        JointCons   = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","U1="));
        U1          = cellfun(@compareStr,extractBetween(s2kSAP,"U1=","   U2="));
        U2          = cellfun(@compareStr,extractBetween(s2kSAP,"U2=","   U3="));
        U3          = cellfun(@compareStr,extractBetween(s2kSAP,"U3=","   R1="));
        R1          = cellfun(@compareStr,extractBetween(s2kSAP,"R1=","   R2="));
        R2          = cellfun(@compareStr,extractBetween(s2kSAP,"R2=","   R3="));
        in_data.CON = [JointCons U1 U2 U3 R1 R2 R2];
        % JOINT LOADS - FORCE ----------------------------------------------------
        s2kSAP      = extractBetween(s2k,"JOINT LOADS - FORCE","TABLE");
        JointLOAD   = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","   LoadPat="));
        F1          = cellfun(@str2num,extractBetween(s2kSAP,"F1=","   F2="));
        F2          = cellfun(@str2num,extractBetween(s2kSAP,"F2=","   F3="));
        F3          = cellfun(@str2num,extractBetween(s2kSAP,"F3=","   M1="));
        M1          = cellfun(@str2num,extractBetween(s2kSAP,"M1=","   M2="));
        M2          = cellfun(@str2num,extractBetween(s2kSAP,"M2=","   M3="));
        M3          = cellfun(@str2num,extractBetween(s2kSAP,"M3=","   GUID="));
        in_data.LOAD_ = [JointLOAD F1 F2 F3 M1 M2 M3];
    case '2D CSQ'
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 2D CSQ
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % JOINT COORDINATES ------------------------------------------------------
        s2kSAP      = extractBetween(s2k,"JOINT COORDINATES","TABLE");
        Joint       = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","   CoordSys"));
        GlobalX     = cellfun(@str2num, extractBetween(s2kSAP,"GlobalX=","   GlobalY="));
        GlobalZ    = cellfun(@str2num, extractBetween(s2kSAP,"GlobalZ=","   GUID="));
        in_data.ND  = [Joint,GlobalX,GlobalZ];
        % CONNECTIVITY - AREA ---------------------------------------------------
        s2kSAP      = extractBetween(s2k,"CONNECTIVITY - AREA","TABLE");
        Area        = cellfun(@str2num, extractBetween(s2kSAP," Area=","   NumJoints="));
        Joint1      = cellfun(@str2num, extractBetween(s2kSAP,"Joint1=","   Joint2="));
        Joint2      = cellfun(@str2num, extractBetween(s2kSAP,"Joint2=","   Joint3="));
        Joint3      = cellfun(@str2num, extractBetween(s2kSAP,"Joint3=","   Joint4="));
        Joint4      = cellfun(@str2num, extractBetween(s2kSAP,"Joint4=","   Perimeter="));
        CentroidX   = cellfun(@str2num, extractBetween(s2kSAP,"CentroidX=","   CentroidY="));
        CentroidZ   = cellfun(@str2num, extractBetween(s2kSAP,"CentroidZ=","   GUID="));
        in_data.EL = [Area,Joint1,Joint2,Joint3,Joint4,CentroidX,CentroidZ];
        % MATERIAL PROPERTIES
        s2kSAP      = extractBetween(s2k,"MATERIAL PROPERTIES 02 - BASIC MECHANICAL PROPERTIES","TABLE");
        s2kSAP      = eraseBetween(s2kSAP,"Material=4000Psi","Material=");              % TRY TO EARSE THE MATERIAL PROPERTIES OF Material=4000Psi
        s2kSAP      = eraseBetween(s2kSAP,"Material=A992Fy50","Material=");             % TRY TO EARSE THE MATERIAL PROPERTIES OF Material=A992Fy50
        s2kSAP      = eraseBetween(s2kSAP,"Material=A416Gr270","Material=");            % TRY TO EARSE THE MATERIAL PROPERTIES OF Material=4000Psi
        unitWeight  = cellfun(@str2num, extractBetween(s2kSAP,"UnitWeight=","   UnitMass="));
        unitMass    = cellfun(@str2num, extractBetween(s2kSAP,"UnitMass=","   E1="));
        E1          = cellfun(@str2num, extractBetween(s2kSAP,"E1=","   G12="));
        in_data.material = [unitWeight,unitMass,E1];
        if isempty(in_data.material)
            in_data.material = [76.9728639422648,7.84904737995992,199947978.795958];    % MATERIAL PROPERTIES OF A992Fy50
        end
        in_data.material = [unitWeight,unitMass,E1];
        % SECTION PROPERTIES
        s2kSAP      = extractBetween(s2k,"AREA SECTION PROPERTIES","TABLE");
        h        = cellfun(@str2num, extractBetween(s2kSAP,"Thickness=","   BendThick="));
        in_data.section = h;
        % JOINT RESTRAINT ASSIGNMENTS --------------------------------------------
        s2kSAP      = extractBetween(s2k,"JOINT RESTRAINT ASSIGNMENTS","TABLE");
        JointCons   = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","U1="));
        U1          = cellfun(@compareStr,extractBetween(s2kSAP,"U1=","   U2="));
        U3          = cellfun(@compareStr,extractBetween(s2kSAP,"U3=","   R1="));
        in_data.CON = [JointCons U1 U3];
        % JOINT LOADS - FORCE ----------------------------------------------------
        s2kSAP      = extractBetween(s2k,"JOINT LOADS - FORCE","TABLE");
        JointLOAD   = cellfun(@str2num, extractBetween(s2kSAP,"Joint=","   LoadPat="));
        F1          = cellfun(@str2num,extractBetween(s2kSAP,"F1=","   F2="));
        F3          = cellfun(@str2num,extractBetween(s2kSAP,"F3=","   M1="));
        in_data.LOAD_ = [JointLOAD F1 F3];
        %% OTHER (DO LATER)
        in_data.mater.E = E1;
        in_data.mater.h = h;
        in_data.mater.miu = 0.3;
        in_data.mater.rho = unitWeight;
end
end

% FORMAT INPUT
function in_data = formatInput(PROB_TYPE,in_data,fileName)
switch PROB_TYPE
    case '3D TRUSS'
        % 3D TRUSS
        % ------------------------------------------------------------------------
        A = in_data.section(1,1);
        I = in_data.section(1,2);
        E = in_data.material(1,1);
        rho = in_data.material(1,2);
        EL_TYPE = 31*ones(size(in_data.EL,1),1);
        in_data.EL = [in_data.EL(:,1),EL_TYPE,in_data.EL(:,2:end),repmat([E A I rho],size(in_data.EL,1),1)];
    case '3D FRAME' 
        % ------------------------------------------------------------------------
        % 3D FRAME
        % ------------------------------------------------------------------------
        b   = 0.3; ho  = 0.3;
        E   = 8e9; rho = 1000; G = 3e6; nu  = 0.3;
        EL_TYPE = 3*ones(size(in_data.EL,1),1);
        in_data.EL = [in_data.EL(:,1),EL_TYPE,in_data.EL(:,2:end),repmat([E G b ho rho nu],size(in_data.EL,1),1)];
    case '2D FRAME'
        % ------------------------------------------------------------------------
        % 2D FRAME
        % ------------------------------------------------------------------------
        A   = in_data.section(1,1);
        I   = in_data.section(1,2);
        rho = in_data.material(1,2);
        E   = in_data.material(1,3);
        % FIND FRAME TYPE (0,1,2,333)(FF,FP,PF,PP)
        release = zeros(size(in_data.EL,1),1);
        for ii = 1:size(in_data.RELEASE,1)
            if in_data.RELEASE(ii,2) == 1 && in_data.RELEASE(ii,3) == 1
                FrameType = 0;
            end
            if in_data.RELEASE(ii,2) == 1 && in_data.RELEASE(ii,3) == 0
                FrameType = 1;
            end
            if in_data.RELEASE(ii,2) == 0 && in_data.RELEASE(ii,3) == 1
                FrameType = 2;
            end
            if in_data.RELEASE(ii,2) == 0 && in_data.RELEASE(ii,3) == 0
                FrameType = 333;
            end
            frame = find(in_data.EL(:,1)==in_data.RELEASE(ii,1));
            release(frame) = FrameType;
        end
        in_data.EL = [in_data.EL(:,1),release,in_data.EL(:,2:end),repmat([E A I rho],size(in_data.EL,1),1)];
        % LUMP MASS
        epxilon = 1E-10;
        in_data.MASS = [(1:size(in_data.ND,1))',epxilon*ones(size(in_data.ND,1),3)];
        in_data.JointMass(:,2:end) = in_data.JointMass(:,2:end)+ epxilon;
        in_data.MASS(in_data.JointMass(:,1),2:end) = in_data.JointMass(:,2:end);
        % ADD SELF-WEIGHT AS UNIFORM LOAD IN Y-DIRECTION
        unitWeight = in_data.material(1,1);
        in_data.qz = in_data.qz0 - unitWeight*A*ones(length(in_data.qz0),1);
        % GROUND DISPLACEMENT
        dofs  =[in_data.DBC.dofs*3-2, in_data.DBC.dofs*3-1,in_data.DBC.dofs*3]';
        in_data.DBC.dofs  = reshape(dofs,1,[]);
        displ = in_data.DBC.displ';
        in_data.DBC.displ = reshape(displ,1,[]);
    case '2D CSQ'
        % ------------------------------------------------------------------------
        % 2D CSQ
        % ------------------------------------------------------------------------
        EL_TYPE = 5*ones(size(in_data.EL,1),1);
        E = in_data.material(3)*ones(size(in_data.EL,1),1);
        miu = 0.3*ones(size(in_data.EL,1),1);
        rho = zeros(size(in_data.EL,1),1);
        h = in_data.section;
        rm = repmat([h h h h],size(in_data.EL,1),1);
        in_data.EL = [in_data.EL(:,1),EL_TYPE,in_data.EL(:,2:5),E,rm,miu,rho,in_data.EL(:,6:7)];
end
%% SET SAVE DIR
dPath = which('tmp_dir.txt'); cd(dPath(1:end-11));
warning('off', 'MATLAB:MKDIR:DirectoryExists');
mkdir(fileName)
cd([dPath(1:end-11),fileName]);
end

function out = compareStr(x)
out = strcmp(x,'No');
end
