%% Setting up for the country plots
%% District shapes
Guinea_Districts = shaperead('GIN_admin_SHP/GIN.shp');
SL_Districts = shaperead('SIL_admin_SHP/SIL.shp');
Liberia_Districts = shaperead('LIB-level_1_SHP/LIB-level_1.shp');

% NOTE: To see which elements of the shape struct correspond to each
% district, please see KeyFile.xlsx.  

%% Outlines
Guinea_Outline = shaperead('GIN_outline_SHP/GIN_outline.shp');
SL_Outline = shaperead('SIL_outline_SHP/SIL_outline.shp');
Liberia_Outline = shaperead('LIB_outline_SHP/LIB_outline.shp');

%%%%%%%%%%%%%%%%%%%%%%
%% IMPORTANT NOTES!! %%
%%%%%%%%%%%%%%%%%%%%%%
% Before running this file, run the model's main runfile. 
% To generate a plot, select a startdate (integer value corresponding to a
% date given by the filename of the figure-saving "eval" statement). 
% Uncomment that startdate, MOVE THE EVAL STATEMENT TO THE END OF THE CODE
% (after all the plotting commands), and then run the file. 


%% List of start-dates  
% startdate = 0; 
%eval(['print -dtiff -r900 Mar31ModelPlot.tif'])

% startdate = 57;
%eval(['print -dtiff -r900 May268hybridModelPlot.tif'])

% startdate = 141;
%eval(['print -dtiff -r900 Aug19ModelPlot.tif'])

% startdate = 155;
%eval(['print -dtiff -r900 Sept2ModelPlot.tif'])

% startdate = 184;
%eval(['print -dtiff -r900 Oct1ModelPlot.tif'])

% startdate = 216;
%eval(['print -dtiff -r900 Nov2ModelPlot.tif'])

% startdate = 246;
%eval(['print -dtiff -r900 Dec2ModelPlot.tif'])

% startdate = 276;
%eval(['print -dtiff -r900 Jan1ModelPlot.tif'])

% startdate = 306;
%eval(['print -dtiff -r900 Jan31ModelPlot.tif'])
%% Make plot for date given by startdate 
rCases = zeros(1,63);
casesDate = cases(startdate+1,:);
for j = 1:63
    caseNum = casesDate(1,j);
    if caseNum >= 301
        rCases(1,j) = 0.8;
    elseif caseNum >= 201
        rCases(1,j) = 0.65;
    elseif caseNum >= 101
        rCases(1,j) = 0.5;
    elseif caseNum >= 11
        rCases(1,j) = 0.35;
    elseif caseNum >= 1
        rCases(1,j) = 0.1;
    else
        rCases(1,j) = 0;
    end
end

for junkIndex = 1
    plotDate = 1;
    figure(startdate+2)
    set(gca,'LineWidth',1,'FontSize',20,'FontName','Arial','FontWeight','Bold')
    hold on
    
    for i = 1:length(Guinea_Outline)
        plot(Guinea_Outline(i).X(1:end-1),Guinea_Outline(i).Y(1:end-1),'k','LineWidth',2.7)
    end
    
    for i = 1:length(SL_Outline)
        plot(SL_Outline(i).X(1:end-1),SL_Outline(i).Y(1:end-1),'k','LineWidth',2.7)
    end
    
    for i = 1:length(Liberia_Outline)
        plot(Liberia_Outline(i).X(1:end-1),Liberia_Outline(i).Y(1:end-1),'k','LineWidth',2.7)
    end
    
    for i = 1:length(Guinea_Districts)
        plot(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'k','LineWidth',1.35)
    end
    
    for i = 1:length(SL_Districts)
        plot(SL_Districts(i).X(1:end-1),SL_Districts(i).Y(1:end-1),'k','LineWidth',1.35)
    end
    
    for i = 1:length(Liberia_Districts)
        plot(Liberia_Districts(i).X(1:end-1),Liberia_Districts(i).Y(1:end-1),'k','LineWidth',1.35)
    end
    
    for i = 1:3
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,2))
    end
    for i = 4:13
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,3))
    end
    
    fill(Guinea_Districts(14).X(1:end-1),Guinea_Districts(14).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,11))
    fill(Guinea_Districts(15).X(1:end-1),Guinea_Districts(15).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,13))
    
    for i = 16:22
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,1))
    end
    
    for i = 23:25
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,(i - 3)))
    end
    
    fill(Guinea_Districts(26).X(1:end-1),Guinea_Districts(26).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,30))
    
    for i = 27:31
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,(i - 4)))
    end
    
    fill(Guinea_Districts(32).X(1:end-1),Guinea_Districts(32).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,4))
    
    for i = 33:36
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,5))
    end
    
    for i = 37:39
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,6))
    end
    
    for i = 40:42
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,(i - 33)))
    end
    
    fill(Guinea_Districts(43).X(1:end-1),Guinea_Districts(43).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,12))
    
    for i = 44:46
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,(i - 30)))
    end
    
    fill(Guinea_Districts(47).X(1:end-1),Guinea_Districts(47).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,19))
    fill(Guinea_Districts(48).X(1:end-1),Guinea_Districts(48).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,10))
    
    for i = 49:50
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,(i - 32)))
    end
    for i = 51:52
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,(i - 23)))
    end
    
    for i = 53:56
        fill(Guinea_Districts(i).X(1:end-1),Guinea_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,(i - 22)))
    end
    
    
    for i = 1:4
        fill(SL_Districts(i).X(1:end-1),SL_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,(i + 34)))
    end
    
    for i = 5:7
        fill(SL_Districts(i).X(1:end-1),SL_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,39))
    end
    
    fill(SL_Districts(8).X(1:end-1),SL_Districts(8).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,40))
    
    for i = 9:17
        fill(SL_Districts(i).X(1:end-1),SL_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,41))
    end
    
    for i = 18:19
        fill(SL_Districts(i).X(1:end-1),SL_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,(i + 24)))
    end
    
    for i = 20:37
        fill(SL_Districts(i).X(1:end-1),SL_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,44))
    end
    
    fill(SL_Districts(38).X(1:end-1),SL_Districts(38).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,45))
    
    for i = 39:41
        fill(SL_Districts(i).X(1:end-1),SL_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,46))
    end
    
    for i = 42:43
        fill(SL_Districts(i).X(1:end-1),SL_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,47))
    end
    
    fill(SL_Districts(44).X(1:end-1),SL_Districts(44).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,48))
    
    
    
    fill(Liberia_Districts(1).X(1:end-1),Liberia_Districts(1).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,49))
    fill(Liberia_Districts(2).X(1:end-1),Liberia_Districts(2).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,50))
    for i = 3:12
        fill(Liberia_Districts(i).X(1:end-1),Liberia_Districts(i).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,i + 49))
    end
    fill(Liberia_Districts(13).X(1:end-1),Liberia_Districts(13).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,63))
    fill(Liberia_Districts(14).X(1:end-1),Liberia_Districts(14).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,62))
    fill(Liberia_Districts(15).X(1:end-1),Liberia_Districts(15).Y(1:end-1),'r','FaceAlpha',rCases(plotDate,51))
    diffValues = zeros(1,63);
    diffValue = 0;
end


