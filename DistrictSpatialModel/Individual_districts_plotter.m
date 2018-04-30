%% Plot model trajectories for all districts
fredVar = [];
dateformat = 'mmm dd';
tprime = t +90;
for i = 1:1:63
    
%     s3 = 'TimeCourseDataFull/';
    s3 = 'TimeCourseDataLate/';

    s4 = num2str(i);
    s5 = strcat('data',s4);
    temp = xlsread(strcat(s3,s4,'.xlsx'));
    eval([s5 '= temp;'])
    temp(1,:) = temp(1,:) + 91;
%     subplot(7,9,i)   
    figure(i)
        set(gca,'LineWidth',1,'FontSize',20,'FontName','Arial','FontWeight','Bold','tickdir','out')    
        hold on
        %Cases Data2
        plot(temp(1,:),temp(2,:),'ro','MarkerSize',12,'LineWidth',2)
        %Deaths Data
        plot(temp(1,:),temp(3,:),'ko','MarkerSize',12,'LineWidth',2)
        plot(tprime,y(:,(8 + 11*(i-1))),'r','LineWidth',3);
        plot(tprime,y(:,(9 + 11*(i-1))),'k','LineWidth',3);
%         plot(tprime,z(:,(8 + 11*(i-1))),'b','LineWidth',3);
%         plot(tprime,z(:,(9 + 11*(i-1))),'g','LineWidth',3);        
        legend('Data - Cases', 'Data - Deaths', 'Model - Cases', 'Model - Deaths');
        set(legend,'location','northwest')
        xlabel('Date');
        ylabel('Persons');
        title(s5);
        xlim([0+91 306+91])
        legend('boxoff')
        ax = gca;
        set(ax,'XTick',[0 + 91  62 + 91 123 + 91  ...
            184 + 91 245 + 91 306 + 91])
        datetick('x',dateformat,'keeplimits','keepticks')
end