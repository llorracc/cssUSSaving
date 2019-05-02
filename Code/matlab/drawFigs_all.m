
recessionsI=zeros(size(time));
recessionsI(15:19)=1;
recessionsI(31:36)=1;
recessionsI(56:58)=1;
recessionsI(62:67)=1;
recessionsI(98:100)=1;
recessionsI(140:143)=1;
recessionsI(167:173)=1;

fCEA_est=figure;
timeConti=(time(1):.01:time(end))';
recConti=interp1(time,recessionsI,timeConti,'nearest');
hA=area(timeConti,8*recConti); axis tight; hold on;
set(hA,'FaceColor',.85*ones(1,3),'EdgeColor','none');
h=plot(time,[debtLimPDVrescaled_est]); %legend('m Bar');
axis tight; set(h,'linewidth',1.0,'color','black');
print(fCEA_est,'-depsc','fCEA_est.eps');
print(fCEA_est,'-dpng','fCEA_est.png');

fMho_est=figure;
timeConti=(time(1):.01:time(end))';
recConti=interp1(time,recessionsI,timeConti,'nearest');
hA=area(timeConti,0.00015*recConti); axis tight; hold on;
set(hA,'FaceColor',.85*ones(1,3),'EdgeColor','none');
h=plot(time,[mhoRescaled_est]); %legend('m Bar');
axis tight; set(h,'linewidth',1.0,'color','black'); axis([-inf inf 1.2e-4 1.5e-4])
print(fMho_est,'-depsc','fMho_est.eps');
print(fMho_est,'-dpng','fMho_est.png');

fPSR_StructFit=figure;
timeConti=(time(1):.01:time(end))';
recConti=interp1(time,recessionsI,timeConti,'nearest');
hA=area(timeConti,15.5*recConti); axis tight; hold on;
set(hA,'FaceColor',.85*ones(1,3),'EdgeColor','none');
h=plot(time,savingRates); %legend('m Bar');
axis tight;
set(h(1),'linewidth',1.0,'color','black');
set(h(2),'linewidth',2.0,'color','red'); %axis([-inf inf 5e-5 9e-5])
legend([h(1:2)],'Actual PSR','Fitted PSR')
%savefig(fPSR_StructFit,'fPSR_StructFit.fig');
print(fPSR_StructFit,'-depsc','fPSR_StructFit.eps');
print(fPSR_StructFit,'-dpng','fPSR_StructFit.png');
%print(fPSR_StructFit,'-dmeta','fPSR_StructFit.emf');
print(fPSR_StructFit,'-dpdf','fPSR_StructFit.pdf');
%print(fPSR_StructFit,'-dsvg','fPSR_StructFit.svg');

cRescaled_soMhoCEA_dummy=repmat(nan,length(cRescaled_soMhoCEA),1);
cRescaled_soMhoCEA_dummy([1:4:length(cRescaled_soMhoCEA)])=cRescaled_soMhoCEA([1:4:length(cRescaled_soMhoCEA)])';

savingRates_decomp=100*(1-[cRescaled_est,cRescaled_soMho,cRescaled_soMhoCEA,cRescaled_soMhoCEA_dummy]);
fPSR_StructDecomp=figure;
timeConti=(time(1):.01:time(end))';
recConti=interp1(time,recessionsI,timeConti,'nearest');
hA=area(timeConti,14*recConti); axis tight; hold on;
set(hA,'FaceColor',.85*ones(1,3),'EdgeColor','none');
h=plot(time,savingRates_decomp); %legend('m Bar');
axis tight;
set(h(2),'linewidth',1.0,'color','black');
set(h(1),'linewidth',2.0,'color','red'); %axis([-inf inf 5e-5 9e-5])
set(h(3),'linewidth',1.0,'color','black'); %axis([-inf inf 5e-5 9e-5])
set(h(4),'linewidth',1,'linestyle','none','marker','o','color','k','MarkerSize',3);
legend([h(1:2); h(4)],'Fitted PSR','Fitted PSR excl. Uncertainty','Fitted PSR excl. Uncertainty and CEA')
%savefig(fPSR_StructDecomp,'fPSR_StructDecomp.fig');
print(fPSR_StructDecomp,'-depsc','fPSR_StructDecomp.eps');
print(fPSR_StructDecomp,'-dpng','fPSR_StructDecomp.png');
%print(fPSR_StructDecomp,'-dmeta','fPSR_StructDecomp.emf');
print(fPSR_StructDecomp,'-dpdf','fPSR_StructDecomp.pdf');
%print(fPSR_StructFit,'-dsvg','fPSR_StructDecomp.svg');

savingRates_decomp_all=100*(1-[actualC,cRescaled_est,cRescaled_soMho,cRescaled_soMhoCEA,cRescaled_soMhoCEA_dummy]);
fPSR_StructDecomp_all=figure;
timeConti=(time(1):.01:time(end))';
recConti=interp1(time,recessionsI,timeConti,'nearest');
hA=area(timeConti,15.5*recConti); axis tight; hold on;
set(hA,'FaceColor',.85*ones(1,3),'EdgeColor','none');
h=plot(time,savingRates_decomp_all); %legend('m Bar');
axis tight;
set(h(1),'linewidth',1.0,'color','blue');
set(h(3),'linewidth',1.0,'color','black');
set(h(2),'linewidth',2.0,'color','red'); %axis([-inf inf 5e-5 9e-5])
set(h(4),'linewidth',1.0,'color','black'); %axis([-inf inf 5e-5 9e-5])
set(h(5),'linewidth',1,'linestyle','none','marker','o','color','k','MarkerSize',3);
legend([h(1:3); h(5)],'Actual PSR','Fitted PSR','Fitted PSR excl. Uncertainty','Fitted PSR excl. Uncertainty and CEA')
print(fPSR_StructDecomp,'-depsc','fPSR_StructDecomp_all.eps');
print(fPSR_StructDecomp,'-dpng','fPSR_StructDecomp_all.png');

